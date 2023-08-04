import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/user_data.dart';

@lazySingleton
class FirestoreFriendsRepository {
  static const _collection = 'friends';
  final _firestore = FirebaseFirestore.instance.collection(_collection);

  Future<dynamic> sendFriendRequest({
    required UserData currentUser,
    required UserData targetUser,
  }) async {
    try {
      await Future.wait([
        _firestore.doc(currentUser.id).update({
          'ownRequests.${targetUser.id}': targetUser.toJson(),
        }),
        _firestore.doc(targetUser.id).update({
          'friendRequests.${currentUser.id}': currentUser.toJson(),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> cancelFriendRequest({
    required UserData currentUser,
    required UserData targetUser,
  }) async {
    try {
      await Future.wait([
        _firestore.doc(currentUser.id).update({
          'ownRequests.${targetUser.id}': FieldValue.delete(),
        }),
        _firestore.doc(targetUser.id).update({
          'friendRequests.${currentUser.id}': FieldValue.delete(),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> declineFriendRequest({
    required UserData currentUser,
    required UserData targetUser,
  }) async {
    try {
      await Future.wait([
        _firestore.doc(currentUser.id).update({
          'friendRequests.${targetUser.id}': FieldValue.delete(),
        }),
        _firestore.doc(targetUser.id).update({
          'ownRequests.${currentUser.id}': FieldValue.delete(),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> removeFriend({
    required UserData currentUser,
    required UserData targetUser,
  }) async {
    try {
      await Future.wait([
        _firestore.doc(currentUser.id).update({
          'allFriends.${targetUser.id}': FieldValue.delete(),
        }),
        _firestore.doc(targetUser.id).update({
          'allFriends.${currentUser.id}': FieldValue.delete(),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> acceptFriendRequest({
    required UserData currentUser,
    required UserData targetUser,
  }) async {
    try {
      await Future.wait([
        _firestore.doc(currentUser.id).update({
          'allFriends.${targetUser.id}': targetUser.toJson(),
          'friendRequests.${targetUser.id}': FieldValue.delete(),
        }),
        _firestore.doc(targetUser.id).update({
          'allFriends.${currentUser.id}': currentUser.toJson(),
          'ownRequests.${currentUser.id}': FieldValue.delete(),
        }),
      ]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> isFriend({
    required UserData currentUser,
    required UserData targetUser,
  }) async {
    try {
      final snapshot = await _firestore.doc(targetUser.id).get();

      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('allFriends')) {
        final data = snapshot.data();
        final friends = data?['allFriends'] as Map<String, dynamic>;

        return friends.containsKey(currentUser.id);
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> isAwaitingForAccept({
    required UserData currentUser,
    required UserData targetUser,
  }) async {
    try {
      final snapshot = await _firestore.doc(currentUser.id).get();

      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('ownRequests')) {
        final data = snapshot.data();
        final friends = data?['ownRequests'] as Map<String, dynamic>;

        return friends.containsKey(targetUser.id);
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> isFriendRequest({
    required UserData currentUser,
    required UserData targetUser,
  }) async {
    try {
      final snapshot = await _firestore.doc(targetUser.id).get();

      if (snapshot.exists &&
          snapshot.data() != null &&
          snapshot.data()!.containsKey('friendRequests')) {
        final data = snapshot.data();
        final friends = data?['friendRequests'] as Map<String, dynamic>;

        return friends.containsKey(currentUser.id);
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
