import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pooapp/widgets/action_dialogs/android_action_dialog.dart';
import 'package:pooapp/widgets/action_dialogs/ios_action_dialog.dart';

class AppActionDialog {
  static void show({
    required String title,
    required String subtitle,
    required String primaryText,
    required String secondaryText,
    required VoidCallback onPrimaryPressed,
    required VoidCallback onSecondaryPressed,
    required BuildContext context,
  }) =>
      showDialog<dynamic>(
        context: context,
        builder: (context) => Platform.isAndroid
            ? AndroidActionDialog(
                title: title,
                subtitle: subtitle,
                primaryText: primaryText,
                secondaryText: secondaryText,
                onPrimaryPressed: onPrimaryPressed,
                onSecondaryPressed: onSecondaryPressed,
              )
            : IOSActionDialog(
                title: title,
                subtitle: subtitle,
                primaryText: primaryText,
                secondaryText: secondaryText,
                onPrimaryPressed: onPrimaryPressed,
                onSecondaryPressed: onSecondaryPressed,
              ),
      );
}
