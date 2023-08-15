import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/comment.dart';

@lazySingleton
class FirestoreCommentsRepository {
  static const _pageSize = 10;
  static const _collection = 'comments';
  final _firestore = FirebaseFirestore.instance.collection(_collection);

  Future<dynamic> addComment({
    required Comment comment,
  }) async {
    try {
      await _firestore.doc().set(comment.toJson());
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<(List<Comment>?, DocumentSnapshot?)> fetchComments(
    String poostId,
  ) async {
    try {
      final querySnapshot = await _firestore
          .orderBy('createdAt', descending: true)
          .where('poostId', isEqualTo: poostId)
          .limit(_pageSize)
          .get();

      final documents = querySnapshot.docs;
      final comments =
          documents.map((e) => Comment.fromJson(e.data())).toList();
      final lastDoc = comments.isEmpty ? null : documents.last;
      return (comments, lastDoc);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<(List<Comment>?, DocumentSnapshot?)> fetchNext(
    String poostId,
    DocumentSnapshot lastDocSnap,
  ) async {
    try {
      final querySnapshot = await _firestore
          .orderBy('createdAt', descending: true)
          .where('poostId', isEqualTo: poostId)
          .startAfterDocument(lastDocSnap)
          .limit(_pageSize)
          .get();

      final documents = querySnapshot.docs;
      final comments =
          documents.map((e) => Comment.fromJson(e.data())).toList();
      final lastDoc = comments.isEmpty ? null : documents.last;
      return (comments, lastDoc);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
