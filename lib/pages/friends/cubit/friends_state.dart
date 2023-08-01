import 'package:equatable/equatable.dart';
import 'package:pooapp/data/models/user.dart';

abstract class FriendsState extends Equatable {}

class Searching extends FriendsState {
  @override
  List<Object?> get props => [];
}

class ReturningSearchData extends FriendsState {
  ReturningSearchData(this.users);

  final List<User>? users;

  @override
  List<Object?> get props => [];
}

class SearchingFailed extends FriendsState {
  SearchingFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
