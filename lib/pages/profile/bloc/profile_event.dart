part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchPoosts extends ProfileEvent {
  FetchPoosts(this.date);

  final DateTime date;
}

class SaveAvatar extends ProfileEvent {
  SaveAvatar(this.image);

  final XFile image;
}
