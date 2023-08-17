import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bepoo/data/models/poost.dart';
import 'package:bepoo/data/models/user_data.dart';
import 'package:bepoo/data/repositories/auth_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_friends_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_poosts_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_users_repository.dart';
import 'package:bepoo/pages/home/cubit/home_feed_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

@lazySingleton
class HomeFeedCubit extends Cubit<HomeFeedState> {
  HomeFeedCubit(
    this._poostsRepository,
    this._usersRepository,
    this._friendsRepository,
    this._authRepository,
  ) : super(ReturningData());

  final poostsList = List<Poost>.empty(growable: true);
  final _usersId = List<String>.empty(growable: true);
  final FirestorePoostsRepository _poostsRepository;
  final FirestoreUsersRepository _usersRepository;
  final FirestoreFriendsRepository _friendsRepository;
  final AuthRepository _authRepository;
  DocumentSnapshot? _lastDocSnap;

  Future<dynamic> fetchPoosts({RefreshController? refreshController}) async {
    try {
      emit(FetchingPoosts());
      final user = _authRepository.getCurrentUser();
      if (user == null) throw Exception('user-not-sign-in');
      final userFriendsInfo = await _friendsRepository.getUserFriendsInfo(
        userId: user.uid,
      );

      final usersId =
          (userFriendsInfo?.friends.map((e) => e.keys.first).toList() ?? [])
            ..add(user.uid);
      _usersId
        ..clear()
        ..addAll(usersId);

      final fetchResults = await _poostsRepository.fetchPoosts(usersId);
      final poosts = fetchResults.$1;
      final lastDocumentSnapshot = fetchResults.$2;
      for (final poost in poosts ?? <Poost>[]) {
        final userData = await _usersRepository.getUserData(
          poost.userId,
        );

        _fillUserData(poosts ?? [], poost, userData);
      }

      _lastDocSnap = lastDocumentSnapshot;
      poostsList
        ..clear()
        ..addAll(poosts ?? []);
      emit(ReturningPoosts());
      refreshController?.refreshCompleted();
    } catch (e) {
      emit(FetchingPoostsFailed(e.toString()));
      refreshController?.refreshFailed();
    }
  }

  Future<dynamic> fetchNextPage(RefreshController refreshController) async {
    try {
      if (_lastDocSnap == null) {
        refreshController.loadComplete();
        return;
      }

      emit(FetchingNextPage());
      final fetchResults = await _poostsRepository.fetchNext(
        _usersId,
        _lastDocSnap!,
      );

      final poosts = fetchResults.$1;
      final lastDocumentSnapshot = fetchResults.$2;
      for (final poost in poosts ?? <Poost>[]) {
        final userData = await _usersRepository.getUserData(
          poost.userId,
        );

        _fillUserData(poosts ?? [], poost, userData);
      }

      _lastDocSnap = lastDocumentSnapshot;
      poostsList.addAll(poosts ?? []);
      emit(ReturningNextPageData());
      (poosts?.isEmpty ?? true)
          ? refreshController.loadNoData()
          : refreshController.loadComplete();
    } catch (e) {
      emit(FetchingNextPageFailed(e.toString()));
      refreshController.loadFailed();
    }
  }

  void _fillUserData(
    List<Poost> poosts,
    Poost poost,
    UserData? userData,
  ) {
    final indexOfUser = poosts.indexOf(poost);
    final filledUser = poost.copyWith(userData: userData);

    poosts
      ..remove(poost)
      ..insert(indexOfUser, filledUser);
  }
}
