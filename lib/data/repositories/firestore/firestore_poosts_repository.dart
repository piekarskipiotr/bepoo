import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/app_hive.dart';
import 'package:pooapp/data/models/comment.dart';
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
      await poostsBox.put(poost.id, poost.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> updatePoostComment({
    required String poostId,
    required Comment comment,
  }) async {
    try {
      final querySnapshot =
          await _firestore.where('id', isEqualTo: poostId).get();

      for (final docSnapshot in querySnapshot.docs) {
        final docRef = docSnapshot.reference;
        await docRef.update({
          'newestComment': comment.content,
          'newestCommentUserName': comment.userData?.name,
        });
      }
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
          .orderBy('createdAt', descending: true)
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
          .orderBy('createdAt', descending: true)
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

  List<Poost> getPoostsByDate(DateTime date) {
    final poosts = _getLocalPoosts();
    return poosts.where((poost) {
      final poostDate = DateTime(
        poost.createdAt.year,
        poost.createdAt.month,
        poost.createdAt.day,
      );

      return poostDate.isAtSameMomentAs(date);
    }).toList();
  }

  int countPoostsByDate(DateTime date) {
    final poosts = _getLocalPoosts();
    return poosts
        .where((poost) {
          final poostDate = DateTime(
            poost.createdAt.year,
            poost.createdAt.month,
            poost.createdAt.day,
          );

          return poostDate.isAtSameMomentAs(date);
        })
        .toList()
        .length;
  }

  List<Poost> _getLocalPoosts() {
    final values =
        poostsBox.values.map((e) => e.cast<String, dynamic>()).toList();

    final poosts = List<Poost>.empty(growable: true);
    for (final json in values) {
      poosts.add(Poost.fromJson(json as Map<String, dynamic>));
    }

    return poosts;
  }
}
