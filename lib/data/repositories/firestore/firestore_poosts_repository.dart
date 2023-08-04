import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/poost.dart';

@lazySingleton
class FirestorePoostsRepository {
  static const _collection = 'poosts';
  final _firestore = FirebaseFirestore.instance.collection(_collection);

  Future<dynamic> addPoost({
    required String docId,
    required Poost poost,
  }) async {
    try {
      await _firestore.doc(docId).set(poost.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<String> generateDocId() async {
    try {
      return await _firestore.add({}).then((ref) => ref.id);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
