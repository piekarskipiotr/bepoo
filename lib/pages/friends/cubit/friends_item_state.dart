import 'package:equatable/equatable.dart';

abstract class FriendsItemState extends Equatable {}

class InitializeState extends FriendsItemState {
  @override
  List<Object?> get props => [];
}

class AddingFriend extends FriendsItemState {
  @override
  List<Object?> get props => [];
}

class AddingFriendSucceeded extends FriendsItemState {
  @override
  List<Object?> get props => [];
}

class AddingFriendFailed extends FriendsItemState {
  AddingFriendFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

class AcceptingFriendRequest extends FriendsItemState {
  @override
  List<Object?> get props => [];
}

class AcceptingFriendRequestSucceeded extends FriendsItemState {
  @override
  List<Object?> get props => [];
}

class AcceptingFriendRequestFailed extends FriendsItemState {
  AcceptingFriendRequestFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

class DecliningFriendRequest extends FriendsItemState {
  @override
  List<Object?> get props => [];
}

class DecliningFriendRequestSucceeded extends FriendsItemState {
  @override
  List<Object?> get props => [];
}

class DecliningFriendRequestFailed extends FriendsItemState {
  DecliningFriendRequestFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
