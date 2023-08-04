import 'package:equatable/equatable.dart';

abstract class FriendsState extends Equatable {}

class Searching extends FriendsState {
  @override
  List<Object?> get props => [];
}

class ReturningSearchData extends FriendsState {
  @override
  List<Object?> get props => [];
}

class SearchingFailed extends FriendsState {
  SearchingFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}

class FetchingNextPage extends FriendsState {
  @override
  List<Object?> get props => [];
}

class ReturningNextPageData extends FriendsState {
  @override
  List<Object?> get props => [];
}

class FetchingNextPageFailed extends FriendsState {
  FetchingNextPageFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [error];
}
