import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pooapp/di/get_it.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/router/app_router.dart';
import 'package:pooapp/themes/app_theme.dart';
import 'package:pooapp/widgets/loading_overlay/loading_overlay.dart';

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
      builder: (context, child) => BlocProvider.value(
        value: getIt<LoadingOverlayCubit>(),
        child: LoadingOverlay(
          child: child ?? Container(),
        ),
      ),
    );
  }
}
