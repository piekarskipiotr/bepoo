import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/enums/poop_type.dart';
import 'package:pooapp/data/models/poost.dart';
import 'package:pooapp/data/repositories/auth_repository.dart';
import 'package:pooapp/data/repositories/cloud_storage_repository.dart';
import 'package:pooapp/data/repositories/firestore/firestore_poosts_repository.dart';

part 'poost_creation_event.dart';
part 'poost_creation_state.dart';

@injectable
class PoostCreationBloc extends Bloc<PoostCreationEvent, PoostCreationState> {
  PoostCreationBloc(
    this._authRepository,
    this._cloudStorageRepository,
    this._poostsRepository,
  ) : super(AwaitingForFormSubmit()) {
    on<CreatePoost>((event, emit) async {
      emit(Creating());
      try {
        if (!_isRequiredFieldsFilled()) {
          throw Exception('required-fields-not-filled');
        }

        final currentUser = _authRepository.getCurrentUser();
        if (currentUser == null) {
          throw Exception('current-user-data-not-found');
        }

        final docId = await _poostsRepository.generateDocId();
        final imageUrl = await _cloudStorageRepository.uploadPoostImage(
          docId: docId,
          userName: currentUser.displayName!,
          image: image!,
        );

        if (imageUrl == null) {
          throw Exception('uploading-image-failed');
        }

        final poost = Poost(
          userId: currentUser.uid,
          imageUrl: imageUrl,
          poopType: poopType!,
          description: description,
        );

        await _poostsRepository.addPoost(docId: docId, poost: poost);
        emit(Created());
      } catch (e) {
        emit(CreatingError(e.toString()));
      }
    });
  }

  bool _isRequiredFieldsFilled() => image != null && poopType != null;

  bool isAnyFieldFilled() =>
      image != null || poopType != null || (description?.isNotEmpty ?? false);

  final AuthRepository _authRepository;
  final CloudStorageRepository _cloudStorageRepository;
  final FirestorePoostsRepository _poostsRepository;

  XFile? image;
  PoopType? poopType;
  String? description;
}
