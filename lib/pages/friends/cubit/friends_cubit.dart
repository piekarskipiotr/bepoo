import 'dart:async';

import 'package:bepoo/data/models/user_data.dart';
import 'package:bepoo/data/models/user_friends_info.dart';
import 'package:bepoo/data/repositories/auth_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_friends_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_users_repository.dart';
import 'package:bepoo/pages/friends/cubit/friends_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@injectable
class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(
    this._friendsRepository,
    this._usersRepository,
    this._authRepository,
  ) : super(ReturningSearchData());

  final usersList = List<UserData>.empty(growable: true);
  final requestUsersList = List<UserData>.empty(growable: true);
  final friendUsersList = List<UserData>.empty(growable: true);
  final FirestoreFriendsRepository _friendsRepository;
  final FirestoreUsersRepository _usersRepository;
  final AuthRepository _authRepository;

  Timer? _debounce;
  String? _name;
  DocumentSnapshot? _lastDocSnap;

  Future<void> search(String? name) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      try {
        emit(Searching());
        _name = null;
        usersList.clear();

        if (name != null && name.isNotEmpty) {
          _name = name;
          final currentUser = _authRepository.getCurrentUser();
          if (currentUser == null) throw Exception('user-not-sign-in');

          final searchResults = await _usersRepository.searchForUsers(name);
          final users = searchResults.$1;
          final lastDocumentSnapshot = searchResults.$2;
          if (users == null) throw Exception('cannot-fetch-users');

          users.removeWhere((user) => user.id == currentUser.uid);
          _lastDocSnap = lastDocumentSnapshot;
          for (final user in users) {
            final friendsInfo = await _friendsRepository.getUserFriendsInfo(
              userId: user.id,
            );

            _fillUserFriendsInfo(users, user, friendsInfo);
          }

          usersList.addAll(users);
          emit(ReturningSearchData());
        }
      } catch (e) {
        emit(SearchingFailed(e.toString()));
      }
    });
  }

  Future<void> fetchNextPage(RefreshController refreshController) async {
    try {
      if (_name == null || _lastDocSnap == null) {
        refreshController.loadComplete();
        return;
      }

      emit(FetchingNextPage());
      final pageResults = await _usersRepository.fetchNext(
        _name!,
        _lastDocSnap!,
      );

      final users = pageResults.$1;
      final lastDocumentSnapshot = pageResults.$2;
      _lastDocSnap = lastDocumentSnapshot;

      for (final user in users ?? <UserData>[]) {
        final friendsInfo = await _friendsRepository.getUserFriendsInfo(
          userId: user.id,
        );

        _fillUserFriendsInfo(users ?? <UserData>[], user, friendsInfo);
      }

      usersList.addAll(users ?? []);
      emit(ReturningNextPageData());
      (users?.isEmpty ?? true)
          ? refreshController.loadNoData()
          : refreshController.loadComplete();
    } catch (e) {
      emit(FetchingNextPageFailed(e.toString()));
      refreshController.loadFailed();
    }
  }

  Future<void> fetchUserFriendsInfo({
    RefreshController? refreshController,
  }) async {
    try {
      emit(GettingUserFriendsInfo());
      final currentUser = _authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('user-not-sign-in');
      final friendsInfo = await _friendsRepository.getUserFriendsInfo(
        userId: currentUser.uid,
      );

      requestUsersList
        ..clear()
        ..addAll(
          friendsInfo?.receivedRequests
                  .map((e) => e.values.first)
                  .toList() ??
              [],
        );

      friendUsersList
        ..clear()
        ..addAll(
          friendsInfo?.friends
                  .map((e) => e.values.first)
                  .toList() ??
              [],
        );

      emit(GettingUserFriendsInfoSucceeded());
    } catch (e) {
      refreshController?.refreshFailed();
      emit(GettingUserFriendsInfoFailed(e.toString()));
    }
  }

  void _fillUserFriendsInfo(
    List<UserData> users,
    UserData user,
    UserFriendsInfo? friendsInfo,
  ) {
    final indexOfUser = users.indexOf(user);
    final filledUser = user.copyWith(friendsInfo: friendsInfo);

    users
      ..remove(user)
      ..insert(indexOfUser, filledUser);
  }
}
