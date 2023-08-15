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
  @override
  List<Object?> get props => [];
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

class CheckingIfUserExists extends AuthState {
  @override
  List<Object?> get props => [];
}

class CheckingIfUserExistsSucceeded extends AuthState {
  CheckingIfUserExistsSucceeded({required this.doesUserExists});

  final bool doesUserExists;

  @override
  List<Object?> get props => [];
}

class CheckingIfUserExistsFailed extends AuthState {
  CheckingIfUserExistsFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
