part of 'poost_creation_bloc.dart';

@immutable
abstract class PoostCreationState extends Equatable {}

class AwaitingForFormSubmit extends PoostCreationState {
  @override
  List<Object?> get props => [];
}

class Creating extends PoostCreationState {
  @override
  List<Object?> get props => [];
}

class Created extends PoostCreationState {
  @override
  List<Object?> get props => [];
}

class CreatingError extends PoostCreationState {
  CreatingError(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
