import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/poost.dart';
import 'package:pooapp/data/models/user_data.dart';
import 'package:pooapp/data/repositories/auth_repository.dart';
import 'package:pooapp/data/repositories/firestore/firestore_poosts_repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@lazySingleton
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(
    this._poostsRepository,
    this._authRepository,
  ) : super(Initialize()) {
    on<FetchPoosts>((event, emit) async {
      try {
        emit(FetchingPoosts());
        final date = event.date;
        final normalizedDate = DateTime(date.year, date.month, date.day);
        final poosts = _poostsRepository.getPoostsByDate(normalizedDate);
        final user = _authRepository.getCurrentUser();
        if (user == null) throw Exception('user-not-sign-in');

        final userData = UserData(
          id: user.uid,
          name: user.displayName!,
          avatarUrl: user.photoURL,
        );

        final updatedPoosts =
            poosts.map((poost) => poost.copyWith(userData: userData)).toList();

        poostsList
          ..clear()
          ..addAll(updatedPoosts);

        emit(FetchingPoostsSucceeded());
      } catch (e) {
        emit(FetchingPoostsFailed(e.toString()));
      }
    });
  }

  List<bool> getPoostsCountByDate(DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return List.filled(
      _poostsRepository.countPoostsByDate(normalizedDate),
      true,
    );
  }

  final poostsList = List<Poost>.empty(growable: true);
  final FirestorePoostsRepository _poostsRepository;
  final AuthRepository _authRepository;
}