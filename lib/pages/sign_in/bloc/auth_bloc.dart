import 'package:bepoo/data/repositories/auth_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_users_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(
    this._authRepository,
    this._usersRepository,
  ) : super(UnAuthenticated()) {
    on<SigningInWithGoogle>((event, emit) async {
      emit(Authenticating());
      try {
        await _authRepository.signInWithGoogle();
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    on<SigningInWithApple>((event, emit) async {
      emit(Authenticating());
      try {
        await _authRepository.signInWithApple();
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });
    on<CheckIfUserExists>((event, emit) async {
      emit(CheckingIfUserExists());
      try {
        final user = _authRepository.getCurrentUser();
        if (user == null) throw Exception('user-not-sign-in');
        final userData = await _usersRepository.getUserData(
          user.uid,
        );

        final doesUserExists = userData != null;
        emit(CheckingIfUserExistsSucceeded(doesUserExists: doesUserExists));
      } catch (e) {
        emit(CheckingIfUserExistsFailed(e.toString()));
      }
    });
    on<LogOut>((event, emit) async {
      emit(LoggingOut());
      await _authRepository.signOut();
      emit(UnAuthenticated());
    });
  }

  bool isAuthenticated() => _authRepository.isAuthenticated();

  User? getCurrentUser() => _authRepository.getCurrentUser();

  final AuthRepository _authRepository;
  final FirestoreUsersRepository _usersRepository;
}
