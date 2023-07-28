import 'package:flutter/material.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/router/app_router.dart';
import 'package:pooapp/themes/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter.instance,
    );
  }
}
