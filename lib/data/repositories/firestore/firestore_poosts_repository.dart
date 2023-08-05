import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/poost.dart';

@lazySingleton
class FirestorePoostsRepository {
  static const _pageSize = 5;
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

  Future<(List<Poost>?, DocumentSnapshot?)> fetchPoosts(
    List<String> usersId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .orderBy('createdAt')
          .where('userId', whereIn: usersId)
          .limit(_pageSize)
          .get();

      final documents = querySnapshot.docs;
      final poosts = documents.map((e) => Poost.fromJson(e.data())).toList();
      final lastDoc = poosts.isEmpty ? null : documents.last;
      return (poosts, lastDoc);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<(List<Poost>?, DocumentSnapshot?)> fetchNext(
    List<String> usersId,
    DocumentSnapshot lastDocSnap,
  ) async {
    try {
      final querySnapshot = await _firestore
          .orderBy('createdAt')
          .where('userId', whereIn: usersId)
          .startAfterDocument(lastDocSnap)
          .limit(_pageSize)
          .get();

      final documents = querySnapshot.docs;
      final poosts = documents.map((e) => Poost.fromJson(e.data())).toList();
      final lastDoc = poosts.isEmpty ? null : documents.last;
      return (poosts, lastDoc);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
