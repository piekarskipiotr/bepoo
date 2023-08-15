import 'package:equatable/equatable.dart';

abstract class CommentsState extends Equatable {}

class FetchingComments extends CommentsState {
  @override
  List<Object?> get props => [];
}

class ReturningComments extends CommentsState {
  @override
  List<Object?> get props => [];
}

class FetchingCommentsFailed extends CommentsState {
  FetchingCommentsFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [];
}

class FetchingNextPage extends CommentsState {
  @override
  List<Object?> get props => [];
}

class ReturningNextPageData extends CommentsState {
  @override
  List<Object?> get props => [];
}

class FetchingNextPageFailed extends CommentsState {
  FetchingNextPageFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [];
}

class AddingComment extends CommentsState {
  @override
  List<Object?> get props => [];
}

class AddingCommentSucceeded extends CommentsState {
  @override
  List<Object?> get props => [];
}

class AddingCommentFailed extends CommentsState {
  AddingCommentFailed(this.error);

  final String error;

  @override
  List<Object?> get props => [];
}
