import 'package:bepoo/data/models/user_data.dart';
import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_friends_info.freezed.dart';
part 'user_friends_info.g.dart';

@freezed
class UserFriendsInfo with _$UserFriendsInfo {
  factory UserFriendsInfo() {
    return const _UserFriendsInfo(
      friends: <Map<String, UserData>>[],
      sentRequests: <Map<String, UserData>>[],
      receivedRequests: <Map<String, UserData>>[],
    );
  }

  const factory UserFriendsInfo.def({
    required List<Map<String, UserData>> friends,
    required List<Map<String, UserData>> sentRequests,
    required List<Map<String, UserData>> receivedRequests,
  }) = _UserFriendsInfo;

  const UserFriendsInfo._();

  factory UserFriendsInfo.fromJson(Map<String, Object?> json) =>
      _$UserFriendsInfoFromJson(json);

  bool isFriendWith({required String userId}) =>
      friends.singleWhereOrNull((f) => f.containsKey(userId)) != null;

  bool isAwaiting({required String userId}) =>
      receivedRequests.singleWhereOrNull((f) => f.containsKey(userId)) != null;

  bool hasRequested({required String userId}) =>
      sentRequests.singleWhereOrNull((f) => f.containsKey(userId)) != null;
}
