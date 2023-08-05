import 'package:equatable/equatable.dart';

abstract class HomeFeedState extends Equatable {}

class ReturningData extends HomeFeedState {
  @override
  List<Object?> get props => [];
}

class FetchingPoosts extends HomeFeedState {
  @override
  List<Object?> get props => [];
}

class ReturningPoosts extends HomeFeedState {
  @override
  List<Object?> get props => [];
}

class FetchingPoostsFailed extends HomeFeedState {
  FetchingPoostsFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [];
}

class FetchingNextPage extends HomeFeedState {
  @override
  List<Object?> get props => [];
}

class ReturningNextPageData extends HomeFeedState {
  @override
  List<Object?> get props => [];
}

class FetchingNextPageFailed extends HomeFeedState {
  FetchingNextPageFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [];
}
