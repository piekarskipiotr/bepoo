part of 'auth_bloc.dart';

@immutable
abstract class AuthState extends Equatable {}

class Authenticating extends AuthState {
  @override
  List<Object?> get props => [];
}

class LoggingOut extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  Authenticated({required this.isAnonymous});

  final bool isAnonymous;

  @override
  List<Object?> get props => [isAnonymous];
}

class UnAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  AuthError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
