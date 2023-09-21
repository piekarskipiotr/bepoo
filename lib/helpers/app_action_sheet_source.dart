import 'dart:io';

import 'package:bepoo/widgets/action_dialogs/android_action_sheet_source.dart';
import 'package:bepoo/widgets/action_dialogs/ios_action_sheet_source.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppActionSheetSource {
  static void show({
    required BuildContext context,
    required VoidCallback onCameraPressed,
    required VoidCallback onGalleryPressed,
  }) =>
      Platform.isAndroid
          ? showModalBottomSheet<dynamic>(
              context: context,
              showDragHandle: true,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              builder: (context) => AndroidActionSheetSource(
                onCameraPressed: onCameraPressed,
                onGalleryPressed: onGalleryPressed,
              ),
            )
          : showCupertinoModalPopup<void>(
              context: context,
              builder: (BuildContext context) => IOSActionSheetSource(
                onCameraPressed: onCameraPressed,
                onGalleryPressed: onGalleryPressed,
              ),
            );
}
