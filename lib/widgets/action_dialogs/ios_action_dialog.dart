import 'package:flutter/cupertino.dart';

class IOSActionDialog extends StatelessWidget {
  const IOSActionDialog({
    required this.title,
    required this.subtitle,
    required this.primaryText,
    required this.secondaryText,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    super.key,
  });

  final String title;
  final String subtitle;
  final String primaryText;
  final String secondaryText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(subtitle),
      actions: [
        CupertinoDialogAction(
          onPressed: onPrimaryPressed,
          isDestructiveAction: true,
          child: Text(primaryText),
        ),
        CupertinoDialogAction(
          onPressed: onSecondaryPressed,
          child: Text(secondaryText),
        ),
      ],
    );
  }
}
