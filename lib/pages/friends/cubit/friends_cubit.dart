import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/repositories/firestore_repository.dart';
import 'package:pooapp/pages/friends/cubit/friends_state.dart';

@lazySingleton
class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(this._firestoreRepository) : super(ReturningSearchData(null));

  final FirestoreRepository _firestoreRepository;
  Timer? _debounce;

  Future<dynamic> search(String? username) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      try {
        emit(Searching());
        if (username != null && username.isNotEmpty) {
          await _firestoreRepository.searchForUsers(username).then(
                (users) => emit(ReturningSearchData(users)),
              );
        }
      } catch (e) {
        emit(SearchingFailed(e.toString()));
      }
    });
  }
}
