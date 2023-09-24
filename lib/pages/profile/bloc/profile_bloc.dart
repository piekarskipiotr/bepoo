import 'package:bepoo/data/models/poost.dart';
import 'package:bepoo/data/models/user_data.dart';
import 'package:bepoo/data/repositories/auth_repository.dart';
import 'package:bepoo/data/repositories/cloud_storage_repository.dart';
import 'package:bepoo/data/repositories/firestore/firestore_poosts_repository.dart';
import 'package:bepoo/data/repositories/notifications_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@lazySingleton
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(this._notificationRepository,
    this._poostsRepository,
    this._cloudStorageRepository,
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
        final token = await _notificationRepository.getToken();
        if (token == null) throw Exception('token-cannot-be-null');

        final userData = UserData(
          id: user.uid,
          name: user.displayName!,
          avatarUrl: user.photoURL,
          notificationsToken: token,
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
    on<SaveAvatar>((event, emit) async {
      try {
        emit(SavingAvatar());
        final image = event.image;
        final user = _authRepository.getCurrentUser();
        if (user == null) throw Exception('user-not-sign-in');
        final avatarUrl = await _cloudStorageRepository.uploadAvatar(
          profileName: user.displayName!,
          image: image,
        );

        await user.updatePhotoURL(avatarUrl);
        emit(SavingAvatarSucceeded());
      } catch (e) {
        emit(SavingAvatarFailed(e.toString()));
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
  final NotificationRepository _notificationRepository;
  final FirestorePoostsRepository _poostsRepository;
  final CloudStorageRepository _cloudStorageRepository;
  final AuthRepository _authRepository;
}
