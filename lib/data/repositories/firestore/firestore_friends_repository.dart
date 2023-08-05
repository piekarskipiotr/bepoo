import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/user_data.dart';
import 'package:pooapp/data/models/user_friends_info.dart';

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
    required UserData targetUser,
  }) async {
    try {
      await Future.wait([
        _firestore.doc(currentUser.uid).update({
          'sentRequests': FieldValue.arrayUnion([
            {targetUser.id: true},
          ]),
        }),
        _firestore.doc(targetUser.id).update({
          'receivedRequests': FieldValue.arrayUnion([
            {currentUser.uid: true},
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
      await Future.wait([
        _firestore.doc(currentUser.uid).update({
          'sentRequests': FieldValue.arrayRemove([
            {targetUser.id: true},
          ]),
        }),
        _firestore.doc(targetUser.id).update({
          'receivedRequests': FieldValue.arrayRemove([
            {currentUser.uid: true},
          ]),
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
      await Future.wait([
        _firestore.doc(currentUser.uid).update({
          'receivedRequests': FieldValue.arrayRemove([
            {targetUser.id: true},
          ]),
        }),
        _firestore.doc(targetUser.id).update({
          'sentRequests': FieldValue.arrayRemove([
            {currentUser.uid: true},
          ]),
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
      await Future.wait([
        _firestore.doc(currentUser.uid).update({
          'friends': FieldValue.arrayRemove([
            {targetUser.id: true},
          ]),
        }),
        _firestore.doc(targetUser.id).update({
          'friends': FieldValue.arrayRemove([
            {currentUser.uid: true},
          ]),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> acceptFriendRequest({
    required User currentUser,
    required UserData targetUser,
  }) async {
    try {
      await Future.wait([
        _firestore.doc(currentUser.uid).update({
          'friends.${targetUser.id}': true,
          'receivedRequests': FieldValue.arrayRemove([
            {targetUser.id: true},
          ]),
        }),
        _firestore.doc(targetUser.id).update({
          'friends.${currentUser.uid}': true,
          'sentRequests': FieldValue.arrayRemove([
            {currentUser.uid: true},
          ]),
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
