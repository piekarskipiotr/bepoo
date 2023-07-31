import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._authRepository) : super(UnAuthenticated()) {
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
    on<SignOut>((event, emit) async {
      emit(LoggingOut());
      await _authRepository.signOut();
      emit(UnAuthenticated());
    });
  }

  bool isAuthenticated() => _authRepository.isAuthenticated();

  User? getCurrentUser() => _authRepository.getCurrentUser();

  final AuthRepository _authRepository;
}
