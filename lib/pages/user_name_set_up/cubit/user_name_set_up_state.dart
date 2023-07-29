import 'package:equatable/equatable.dart';

abstract class UserNameSetUpState extends Equatable {}

class UserNameValidated extends UserNameSetUpState {
  @override
  List<Object?> get props => [];
}

class ValidatingUserName extends UserNameSetUpState {
  @override
  List<Object?> get props => [];
}

class Finishing extends UserNameSetUpState {
  @override
  List<Object?> get props => [];
}

class SettingUpSucceeded extends UserNameSetUpState {
  @override
  List<Object?> get props => [];
}

class SettingUpFailed extends UserNameSetUpState {
  SettingUpFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
