import 'package:bepoo/resources/resources.dart';
import 'package:bepoo/themes/app_theme.dart';
import 'package:flutter/material.dart';

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
    required this.onPressed,
    required this.icon,
    this.isLeading = false,
    super.key,
  });

  final VoidCallback onPressed;
  final dynamic icon;
  final bool isLeading;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = AppTheme.isDarkMode();
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: isLeading ? 0 : 16,
      ),
      child: SizedBox(
        width: isLeading ? 64 : 48,
        height: isLeading ? 64 : 48,
        child: RawMaterialButton(
          onPressed: onPressed,
          fillColor: isDarkMode ? Colors.white : Colors.black,
          shape: const CircleBorder(),
          child: icon is IconData
              ? Icon(
                  icon as IconData,
                  color: isDarkMode ? Colors.black : Colors.white,
                )
              : ClipOval(
                child: SizedBox(
                    width: 40,
                    height: 40,
                    child: Image.network(
                      icon as String? ?? '',
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, e) => Image.asset(
                        AppIcons.appIcon,
                      ),
                    ),
                  ),
              ),
        ),
      ),
    );
  }
}
