import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bepoo/helpers/permission_helper.dart';

class AppCamera {
  static Future<bool> _checkCameraPermission(BuildContext context) async {
    final permissions = Platform.isIOS
        ? [Permission.camera]
        : [Permission.camera, Permission.storage];

    for (final perm in permissions) {
      final result = await PermissionHelper.checkPermission(
        context: context,
        permission: perm,
      );

      if (!result) {
        return false;
      }
    }

    return true;
  }

  static Future<bool> _checkGalleryPermission(BuildContext context) async {
    final permissions =
        Platform.isIOS ? [Permission.photos] : [Permission.storage];

    for (final perm in permissions) {
      final result = await PermissionHelper.checkPermission(
        context: context,
        permission: perm,
      );

      if (!result) {
        return false;
      }
    }

    return true;
  }

  static Future<XFile?> takePicture({
    required BuildContext context,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    if (!(await _checkCameraPermission(context))) return null;

    return ImagePicker()
        .pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: preferredCameraDevice,
        )
        .then((image) => image);
  }

  static Future<XFile?> openGallery({
    required BuildContext context,
  }) async {
    if (!(await _checkGalleryPermission(context))) return null;

    return ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((image) => image);
  }
}
