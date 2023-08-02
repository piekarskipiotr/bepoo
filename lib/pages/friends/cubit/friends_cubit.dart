import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/repositories/auth_repository.dart';
import 'package:pooapp/data/repositories/firestore_repository.dart';
import 'package:pooapp/pages/friends/cubit/friends_state.dart';

@injectable
class FriendsCubit extends Cubit<FriendsState> {
  FriendsCubit(this._firestoreRepository, this._authRepository)
      : super(ReturningSearchData(null));

  final FirestoreRepository _firestoreRepository;
  final AuthRepository _authRepository;
  Timer? _debounce;

  Future<dynamic> search(String? username) async {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), () async {
      try {
        emit(Searching());
        if (username != null && username.isNotEmpty) {
          final currentUser = _authRepository.getCurrentUser();
          if (currentUser == null) throw Exception('user-not-sign-in');

          final users = await _firestoreRepository.searchForUsers(username);
          users?.removeWhere((user) => user.id == currentUser.uid);
          emit(ReturningSearchData(users));
        }
      } catch (e) {
        emit(SearchingFailed(e.toString()));
      }
    });
  }
}
