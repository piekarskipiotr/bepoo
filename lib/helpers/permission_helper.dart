import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pooapp/data/enums/app_permission.dart';
import 'package:pooapp/router/app_routes.dart';

class PermissionHelper {
  static Future<bool> _isAndroid13orHigher() async {
    final deviceInfo = DeviceInfoPlugin();
    if (!Platform.isAndroid) {
      return false;
    }

    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt >= 33;
  }

  static Future<bool> checkPermission({
    required BuildContext context,
    required Permission permission,
  }) async {
    if (permission == Permission.location) {
      return _checkLocationPermission(context: context).then((result) {
        if (!result) {
          context.push(
            AppRoutes.permissionRationale,
            extra: AppPermission.location,
          );
        }

        return result;
      });
    } else if (permission == Permission.storage &&
        await _isAndroid13orHigher()) {
      final android13Permissions = [
        Permission.photos,
        Permission.videos,
        Permission.audio
      ];

      for (final p in android13Permissions) {
        final status = await p.request().then(
              (request) => _handleRequest(
                permission,
                request,
                context,
              ),
            );

        if (status.isDenied || status.isPermanentlyDenied) {
          return false;
        }
      }

      return true;
    } else {
      final status = await permission.request().then(
            (request) => _handleRequest(
              permission,
              request,
              context,
            ),
          );
      return !(status.isDenied || status.isPermanentlyDenied);
    }
  }

  static Future<bool> _checkLocationPermission({
    required BuildContext context,
  }) async {
    final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isServiceEnabled) {
      await Geolocator.openLocationSettings();
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        return false;
      }
    }

    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    } else {
      return true;
    }
  }

  static PermissionStatus _handleRequest(
    Permission permission,
    PermissionStatus request,
    BuildContext context,
  ) {
    if (request.isDenied || request.isPermanentlyDenied) {
      AppPermission? rationaleType;
      if (permission == Permission.camera) {
        rationaleType = AppPermission.camera;
      } else if (permission == Permission.storage) {
        rationaleType = AppPermission.storage;
      } else if (permission == Permission.photos ||
          permission == Permission.videos ||
          permission == Permission.audio) {
        rationaleType = AppPermission.gallery;
      } else {
        return request;
      }

      context.push(
        AppRoutes.permissionRationale,
        extra: rationaleType,
      );
    }

    return request;
  }
}
