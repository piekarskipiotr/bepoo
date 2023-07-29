import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class CloudStorageRepository {
  final _storage = FirebaseStorage.instance.ref();

  Future<String?> uploadAvatar({
    required String profileName,
    required XFile image,
  }) async {
    try {
      final timeStamp = DateTime.now().millisecondsSinceEpoch;
      final imagePath = 'avatars/$profileName/$timeStamp.jpg';
      final avatarRef = _storage.child(imagePath);
      final imageFile = File(image.path);
      await avatarRef.putFile(imageFile);
      return avatarRef.getDownloadURL();
    } catch (e) {
      throw Exception(e);
    }
  }
}
