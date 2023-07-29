import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirestoreRepository {
  final _firestore = FirebaseFirestore.instance;

  Future<bool> isUserNameExists(String name) async {
    try {
      final doc = await _firestore.collection('user_names').doc(name).get();
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

      await _firestore.collection('user_names').doc(name).set({});
    } catch (e) {
      rethrow;
    }
  }
}
