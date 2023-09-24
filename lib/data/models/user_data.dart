import 'package:bepoo/data/models/user_friends_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_data.freezed.dart';
part 'user_data.g.dart';

@freezed
class UserData with _$UserData {
  factory UserData({
    required String id,
    required String name,
    required String notificationsToken,
    String? avatarUrl,
  }) {
    return _UserData(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      createdAt: DateTime.now(),
      updatedAt: null,
      notificationsToken: notificationsToken,
    );
  }

  const factory UserData.def({
    required String id,
    required String name,
    required String? avatarUrl,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required String notificationsToken,
    // ignore: invalid_annotation_target
    @JsonKey(includeToJson: false, includeFromJson: false)
    UserFriendsInfo? friendsInfo,
  }) = _UserData;

  factory UserData.fromJson(Map<String, Object?> json) =>
      _$UserDataFromJson(json);

  factory UserData.fromAuthUser(User user, String notificationsToken) =>
      UserData.def(
        id: user.uid,
        name: user.displayName!,
        avatarUrl: user.photoURL,
        createdAt: user.metadata.creationTime!,
        updatedAt: null,
        notificationsToken: notificationsToken,
      );
}
