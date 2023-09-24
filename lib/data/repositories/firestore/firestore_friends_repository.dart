import 'package:bepoo/data/models/user_data.dart';
import 'package:bepoo/data/models/user_friends_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirestoreFriendsRepository {
  static const _collection = 'friends';
  final _firestore = FirebaseFirestore.instance.collection(_collection);

  Future<UserFriendsInfo> createDocument(UserData user) async {
    try {
      final userFriendsInfo = UserFriendsInfo();
      final json = userFriendsInfo.toJson();
      await _firestore.doc(user.id).set(json);

      return userFriendsInfo;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> sendFriendRequest({
    required User currentUser,
    required String currentUserNotificationsToken,
    required UserData targetUser,
  }) async {
    try {
      await Future.wait([
        _firestore.doc(currentUser.uid).update({
          'sentRequests': FieldValue.arrayUnion([
            {targetUser.id: targetUser.toJson()},
          ]),
        }),
        _firestore.doc(targetUser.id).update({
          'receivedRequests': FieldValue.arrayUnion([
            {
              currentUser.uid: UserData.fromAuthUser(
                currentUser,
                currentUserNotificationsToken,
              ).toJson(),
            },
          ]),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> cancelFriendRequest({
    required User currentUser,
    required UserData targetUser,
  }) async {
    try {
      final targetUserInfo = await getUserFriendsInfo(userId: targetUser.id);
      final currentUserInfo = await getUserFriendsInfo(userId: currentUser.uid);

      final targetUserItem = currentUserInfo?.sentRequests
          .where(
            (element) => element.keys.firstOrNull == targetUser.id,
          )
          .firstOrNull;

      final targetJson = <String, dynamic>{};
      targetUserItem?.forEach((key, userData) {
        targetJson[key] = userData.toJson();
      });

      final currentUserItem = targetUserInfo?.sentRequests
          .where(
            (element) => element.keys.firstOrNull == targetUser.id,
          )
          .firstOrNull;

      final currentJson = <String, dynamic>{};
      currentUserItem?.forEach((key, userData) {
        currentJson[key] = userData.toJson();
      });

      await Future.wait([
        _firestore.doc(currentUser.uid).update({
          'sentRequests': FieldValue.arrayRemove([targetJson]),
        }),
        _firestore.doc(targetUser.id).update({
          'receivedRequests': FieldValue.arrayRemove([currentJson]),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> declineFriendRequest({
    required User currentUser,
    required UserData targetUser,
  }) async {
    try {
      final targetUserInfo = await getUserFriendsInfo(userId: targetUser.id);
      final currentUserInfo = await getUserFriendsInfo(userId: currentUser.uid);
      final targetUserItem = targetUserInfo?.sentRequests
          .where(
            (element) => element.keys.firstOrNull == currentUser.uid,
          )
          .firstOrNull;

      final targetJson = <String, dynamic>{};
      targetUserItem?.forEach((key, userData) {
        targetJson[key] = userData.toJson();
      });

      final currentUserItem = currentUserInfo?.receivedRequests
          .where(
            (element) => element.keys.firstOrNull == targetUser.id,
          )
          .firstOrNull;

      final currentJson = <String, dynamic>{};
      currentUserItem?.forEach((key, userData) {
        currentJson[key] = userData.toJson();
      });

      await Future.wait([
        _firestore.doc(currentUser.uid).update({
          'receivedRequests': FieldValue.arrayRemove([currentUserItem]),
        }),
        _firestore.doc(targetUser.id).update({
          'sentRequests': FieldValue.arrayRemove([targetJson]),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> removeFriend({
    required User currentUser,
    required UserData targetUser,
  }) async {
    try {
      final targetUserInfo = await getUserFriendsInfo(userId: targetUser.id);
      final currentUserInfo = await getUserFriendsInfo(userId: currentUser.uid);
      final targetUserItem = targetUserInfo?.friends
          .where(
            (element) => element.keys.firstOrNull == currentUser.uid,
          )
          .firstOrNull;

      final targetJson = <String, dynamic>{};
      targetUserItem?.forEach((key, userData) {
        targetJson[key] = userData.toJson();
      });

      final currentUserItem = currentUserInfo?.friends
          .where(
            (element) => element.keys.firstOrNull == targetUser.id,
          )
          .firstOrNull;

      final currentJson = <String, dynamic>{};
      currentUserItem?.forEach((key, userData) {
        currentJson[key] = userData.toJson();
      });

      await Future.wait([
        _firestore.doc(currentUser.uid).update({
          'friends': FieldValue.arrayRemove([currentJson]),
        }),
        _firestore.doc(targetUser.id).update({
          'friends': FieldValue.arrayRemove([targetJson]),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> acceptFriendRequest({
    required User currentUser,
    required String currentUserNotificationsToken,
    required UserData targetUser,
  }) async {
    try {
      final targetUserInfo = await getUserFriendsInfo(userId: targetUser.id);
      final currentUserInfo = await getUserFriendsInfo(userId: currentUser.uid);
      final targetUserItem = targetUserInfo?.sentRequests
          .where(
            (element) => element.keys.firstOrNull == currentUser.uid,
          )
          .firstOrNull;

      final targetJson = <String, dynamic>{};
      targetUserItem?.forEach((key, userData) {
        targetJson[key] = userData.toJson();
      });

      final currentUserItem = currentUserInfo?.receivedRequests
          .where(
            (element) => element.keys.firstOrNull == targetUser.id,
          )
          .firstOrNull;

      final currentJson = <String, dynamic>{};
      currentUserItem?.forEach((key, userData) {
        currentJson[key] = userData.toJson();
      });

      await Future.wait([
        _firestore.doc(currentUser.uid).update({
          'friends': FieldValue.arrayUnion([
            {targetUser.id: targetUser.toJson()},
          ]),
          'receivedRequests': FieldValue.arrayRemove([currentJson]),
        }),
        _firestore.doc(targetUser.id).update({
          'friends': FieldValue.arrayUnion([
            {
              currentUser.uid: UserData.fromAuthUser(
                currentUser,
                currentUserNotificationsToken,
              ).toJson(),
            },
          ]),
          'sentRequests': FieldValue.arrayRemove([targetJson]),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserFriendsInfo?> getUserFriendsInfo({required String userId}) async {
    try {
      final snapshot = await _firestore.doc(userId).get();
      final data = snapshot.data();
      if (data == null) throw Exception('fail-to-fetch-user-friends-info');
      return UserFriendsInfo.fromJson(data);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
