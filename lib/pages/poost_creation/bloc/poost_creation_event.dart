part of 'poost_creation_bloc.dart';

abstract class PoostCreationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePoost extends PoostCreationEvent {}
