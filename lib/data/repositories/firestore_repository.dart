import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/poost.dart';

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

  Future<dynamic> addUserName(String name) async {
    try {
      if (name.isEmpty) {
        throw Exception('name-empty');
      }

      final exists = await isUserNameExists(name);
      if (exists) {
        throw Exception('name-already-exists');
      }

      await _firestore.collection('users').doc(name).set({});
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
