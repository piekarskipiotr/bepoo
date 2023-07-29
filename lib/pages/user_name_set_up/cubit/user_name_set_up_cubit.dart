import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/repositories/auth_repository.dart';
import 'package:pooapp/data/repositories/firestore_repository.dart';
import 'package:pooapp/pages/user_name_set_up/cubit/user_name_set_up_state.dart';

@lazySingleton
class UserNameSetUpCubit extends Cubit<UserNameSetUpState> {
  UserNameSetUpCubit(this._firestoreRepository, this._authRepository)
      : super(UserNameValidated());

  final FirestoreRepository _firestoreRepository;
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
          await _firestoreRepository.isUserNameExists(name).then(
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
      await _firestoreRepository.addUserName(_name ?? '');
      await _authRepository.updateProfile(
        name: _name!,
      );

      emit(SettingUpSucceeded());
    } catch (e) {
      emit(SettingUpFailed(e.toString()));
    }
  }
}
