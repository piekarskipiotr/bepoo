part of 'profile_bloc.dart';

@immutable
abstract class ProfileState extends Equatable {}

class Initialize extends ProfileState {
  @override
  List<Object?> get props => [];
}

class FetchingPoosts extends ProfileState {
  @override
  List<Object?> get props => [];
}

class FetchingPoostsSucceeded extends ProfileState {
  @override
  List<Object?> get props => [];
}

class FetchingPoostsFailed extends ProfileState {
  FetchingPoostsFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

class SavingAvatar extends ProfileState {
  @override
  List<Object?> get props => [];
}

class SavingAvatarSucceeded extends ProfileState {
  @override
  List<Object?> get props => [];
}

class SavingAvatarFailed extends ProfileState {
  SavingAvatarFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
