import 'package:equatable/equatable.dart';
import 'package:pooapp/data/models/user_data.dart';

abstract class FriendsState extends Equatable {}

class Searching extends FriendsState {
  @override
  List<Object?> get props => [];
}

class ReturningSearchData extends FriendsState {
  ReturningSearchData(this.users);

  final List<UserData>? users;

  @override
  List<Object?> get props => [];
}

class SearchingFailed extends FriendsState {
  SearchingFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
