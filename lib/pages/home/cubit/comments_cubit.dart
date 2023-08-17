import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bepoo/data/models/comment.dart';
import 'package:bepoo/data/models/user_data.dart';
import 'package:bepoo/data/repositories/auth_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_comments_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_poosts_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_users_repository.dart';
import 'package:bepoo/pages/home/cubit/comments_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@injectable
class CommentsCubit extends Cubit<CommentsState> {
  CommentsCubit(
    this._commentsRepository,
    this._poostsRepository,
    this._usersRepository,
    this._authRepository,
  ) : super(ReturningComments());

  final commentsList = List<Comment>.empty(growable: true);
  final FirestoreCommentsRepository _commentsRepository;
  final FirestorePoostsRepository _poostsRepository;
  final FirestoreUsersRepository _usersRepository;
  final AuthRepository _authRepository;
  DocumentSnapshot? _lastDocSnap;

  Future<void> addComment(String poostId, String content) async {
    try {
      emit(AddingComment());
      final user = _authRepository.getCurrentUser();
      if (user == null) throw Exception('user-not-sign-in');
      final comment = Comment(
        poostId: poostId,
        userId: user.uid,
        content: content,
      );

      await _commentsRepository.addComment(comment: comment);
      final userData = await _usersRepository.getUserData(
        comment.userId,
      );

      final updatedComment = comment.copyWith(userData: userData);
      commentsList.insert(0, updatedComment);
      await _poostsRepository.updatePoostComment(
        poostId: poostId,
        comment: updatedComment,
      );

      emit(AddingCommentSucceeded());
    } catch (e) {
      emit(AddingCommentFailed(e.toString()));
    }
  }

  Future<dynamic> fetchComments({
    required String poostId,
    RefreshController? refreshController,
  }) async {
    try {
      emit(FetchingComments());
      final user = _authRepository.getCurrentUser();
      if (user == null) throw Exception('user-not-sign-in');
      final fetchResults = await _commentsRepository.fetchComments(poostId);
      final comments = fetchResults.$1;
      final lastDocumentSnapshot = fetchResults.$2;
      for (final comment in comments ?? <Comment>[]) {
        final userData = await _usersRepository.getUserData(
          comment.userId,
        );

        _fillUserData(comments ?? [], comment, userData);
      }

      _lastDocSnap = lastDocumentSnapshot;
      commentsList
        ..clear()
        ..addAll(comments ?? []);
      emit(ReturningComments());
      refreshController?.refreshCompleted();
    } catch (e) {
      emit(FetchingCommentsFailed(e.toString()));
      refreshController?.refreshFailed();
    }
  }

  Future<dynamic> fetchNextPage({
    required String poostId,
    required RefreshController refreshController,
  }) async {
    try {
      if (_lastDocSnap == null) {
        refreshController.loadComplete();
        return;
      }

      emit(FetchingNextPage());
      final fetchResults = await _commentsRepository.fetchNext(
        poostId,
        _lastDocSnap!,
      );

      final comments = fetchResults.$1;
      final lastDocumentSnapshot = fetchResults.$2;
      for (final comment in comments ?? <Comment>[]) {
        final userData = await _usersRepository.getUserData(
          comment.userId,
        );

        _fillUserData(comments ?? [], comment, userData);
      }

      _lastDocSnap = lastDocumentSnapshot;
      commentsList.addAll(comments ?? []);
      emit(ReturningNextPageData());
      (comments?.isEmpty ?? true)
          ? refreshController.loadNoData()
          : refreshController.loadComplete();
    } catch (e) {
      emit(FetchingNextPageFailed(e.toString()));
      refreshController.loadFailed();
    }
  }

  void _fillUserData(
    List<Comment> comments,
    Comment comment,
    UserData? userData,
  ) {
    final indexOfUser = comments.indexOf(comment);
    final filledUser = comment.copyWith(userData: userData);

    comments
      ..remove(comment)
      ..insert(indexOfUser, filledUser);
  }
}
