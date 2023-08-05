import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/user_data.dart';
import 'package:pooapp/data/repositories/auth_repository.dart';
import 'package:pooapp/data/repositories/firestore/firestore_friends_repository.dart';
import 'package:pooapp/pages/friends/cubit/friends_item_state.dart';

@injectable
class FriendsItemCubit extends Cubit<FriendsItemState> {
  FriendsItemCubit(
    this._friendsRepository,
    this._authRepository,
  ) : super(InitializeState());

  final FirestoreFriendsRepository _friendsRepository;
  final AuthRepository _authRepository;
  bool isFriend = false;
  bool isAwaiting = false;
  bool hasRequested = false;

  void initializeFriendsInfo(UserData user) {
    isFriend = _isFriend(user);
    isAwaiting = _isAwaiting(user);
    hasRequested = _hasRequested(user);
  }

  Future<dynamic> addFriend(UserData targetUser) async {
    emit(AddingFriend());
    try {
      final currentUser = _authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('user-not-sign-in');
      await _friendsRepository.sendFriendRequest(
        currentUser: currentUser,
        targetUser: targetUser,
      );

      isAwaiting = true;
      emit(AddingFriendSucceeded());
    } catch (e) {
      emit(AddingFriendFailed(e.toString()));
    }
  }

  Future<dynamic> acceptFriendRequest(UserData targetUser) async {
    emit(AcceptingFriendRequest());
    try {
      final currentUser = _authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('user-not-sign-in');
      await _friendsRepository.acceptFriendRequest(
        currentUser: currentUser,
        targetUser: targetUser,
      );

      isFriend = true;
      emit(AcceptingFriendRequestSucceeded());
    } catch (e) {
      emit(AcceptingFriendRequestFailed(e.toString()));
    }
  }

  Future<dynamic> decliningFriendRequest(UserData targetUser) async {
    emit(DecliningFriendRequest());
    try {
      final currentUser = _authRepository.getCurrentUser();
      if (currentUser == null) throw Exception('user-not-sign-in');
      await _friendsRepository.declineFriendRequest(
        currentUser: currentUser,
        targetUser: targetUser,
      );

      hasRequested = false;
      emit(DecliningFriendRequestSucceeded());
    } catch (e) {
      emit(DecliningFriendRequestFailed(e.toString()));
    }
  }

  bool _isFriend(UserData user) {
    final currentUser = _authRepository.getCurrentUser();
    if (currentUser == null) return false;

    return user.friendsInfo?.isFriendWith(userId: currentUser.uid) ?? false;
  }

  bool _isAwaiting(UserData user) {
    final currentUser = _authRepository.getCurrentUser();
    if (currentUser == null) return false;

    return user.friendsInfo?.isAwaiting(userId: currentUser.uid) ?? false;
  }

  bool _hasRequested(UserData user) {
    final currentUser = _authRepository.getCurrentUser();
    if (currentUser == null) return false;

    return user.friendsInfo?.hasRequested(userId: currentUser.uid) ?? false;
  }
}
