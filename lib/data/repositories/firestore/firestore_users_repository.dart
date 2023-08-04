import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:pooapp/data/models/user_data.dart';

@lazySingleton
class FirestoreUsersRepository {
  static const _collection = 'users';
  final _firestore = FirebaseFirestore.instance.collection(_collection);

  Future<bool> isUserNameExists(String name) async {
    try {
      final doc = await _firestore.doc(name).get();
      return doc.exists;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> registerUserData(UserData user) async {
    try {
      if (user.name.isEmpty) {
        throw Exception('name-empty');
      }

      final exists = await isUserNameExists(user.name);
      if (exists) {
        throw Exception('name-already-exists');
      }

      final lowerCaseName = user.name.toLowerCase();
      final json = user.toJson();
      json['lower_case_name'] = lowerCaseName;
      await _firestore.doc(lowerCaseName).set(json);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<UserData>?> searchForUsers(String name) async {
    try {
      final convertedName = name.toLowerCase();
      final querySnapshot = await _firestore
          .orderBy('lower_case_name')
          .startAt([convertedName]).endAt(['$convertedName\uf8ff']).get();

      final documents = querySnapshot.docs;
      return documents.map((e) => UserData.fromJson(e.data())).toList();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
