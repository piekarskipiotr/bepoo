import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/user_data.dart';
import 'package:pooapp/data/repositories/auth_repository.dart';
import 'package:pooapp/data/repositories/firestore/firestore_friends_repository.dart';
import 'package:pooapp/data/repositories/firestore/firestore_users_repository.dart';
import 'package:pooapp/pages/user_name_set_up/cubit/user_name_set_up_state.dart';

@lazySingleton
class UserNameSetUpCubit extends Cubit<UserNameSetUpState> {
  UserNameSetUpCubit(
    this._friendsRepository,
    this._usersRepository,
    this._authRepository,
  ) : super(UserNameValidated());

  final FirestoreFriendsRepository _friendsRepository;
  final FirestoreUsersRepository _usersRepository;
  final AuthRepository _authRepository;
  Timer? _debounce;
  String? _name;
  bool? isValid;

  Future<dynamic> validateUserName(String? name) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      _name = name;
      isValid = null;

      try {
        emit(ValidatingUserName());
        if (name != null && name.isNotEmpty) {
          await _usersRepository.isUserNameExists(name).then(
                (exists) => isValid = !exists,
              );
        }
      } catch (_) {
        isValid = false;
      }

      emit(UserNameValidated());
    });
  }

  Future<dynamic> finishSettingUp() async {
    if (_debounce?.isActive ?? false) return;
    try {
      emit(Finishing());
      final currentUser = _authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('user-not-found');

      final user = UserData(id: currentUser.uid, name: _name!);
      await _usersRepository.registerUserData(user);
      await _friendsRepository.createDocument(user);
      await _authRepository.updateProfile(
        name: _name!,
      );

      emit(SettingUpSucceeded());
    } catch (e) {
      emit(SettingUpFailed(e.toString()));
    }
  }
}
