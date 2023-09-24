import 'dart:async';

import 'package:bepoo/data/models/user_data.dart';
import 'package:bepoo/data/repositories/auth_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_friends_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_users_repository.dart';
import 'package:bepoo/data/repositories/notifications_repository.dart';
import 'package:bepoo/pages/user_name_set_up/cubit/user_name_set_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class UserNameSetUpCubit extends Cubit<UserNameSetUpState> {
  UserNameSetUpCubit(this._notificationRepository,
    this._friendsRepository,
    this._usersRepository,
    this._authRepository,
  ) : super(UserNameValidated());

  final NotificationRepository _notificationRepository;
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

      final token = await _notificationRepository.getToken();
      if (token == null) throw Exception('token-cannot-be-null');

      final user = UserData(
        id: currentUser.uid,
        name: _name!,
        notificationsToken: token,
      );

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
