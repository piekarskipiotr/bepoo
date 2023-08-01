import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/poost.dart';
import 'package:pooapp/data/models/user.dart';

@lazySingleton
class FirestoreRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<bool> isUserNameExists(String name) async {
    try {
      final doc = await _firestore.collection('users').doc(name).get();
      return doc.exists;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<User>?> searchForUsers(String username) async {
    try {
      final searchText = username.toLowerCase();
      final querySnapshot = await _firestore
          .collection('users')
          .orderBy('lower_case_name')
          .startAt([searchText]).endAt(['$searchText\uf8ff']).get();

      final documents = querySnapshot.docs;
      return documents.map((e) => User.fromJson(e.data())).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> addUser(User user) async {
    try {
      if (user.name.isEmpty) {
        throw Exception('name-empty');
      }

      final exists = await isUserNameExists(user.name);
      if (exists) {
        throw Exception('name-already-exists');
      }

      final json = user.toJson();
      json['lower_case_name'] = user.name.toLowerCase();
      await _firestore.collection('users').doc(user.name).set(json);
    } catch (e) {
      rethrow;
    }
  }

  Future<String> generateDocId({required String collection}) async {
    try {
      return await _firestore.collection(collection).add({}).then(
        (ref) => ref.id,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> addPoost({
    required String docId,
    required Poost poost,
  }) async {
    try {
      await _firestore.collection('poosts').doc(docId).set(poost.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
