import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pooapp/di/get_it.dart';
import 'package:pooapp/l10n/l10n.dart';
import 'package:pooapp/pages/home/cubit/home_feed_cubit.dart';
import 'package:pooapp/pages/home/view/home_feed.dart';
import 'package:pooapp/pages/poost_creation/bloc/poost_creation_bloc.dart';
import 'package:pooapp/pages/poost_creation/poost_creation.dart';
import 'package:pooapp/pages/sign_in/bloc/auth_bloc.dart';
import 'package:pooapp/router/app_routes.dart';
import 'package:pooapp/widgets/app_bar_icon.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: context.watch<HomeFeedCubit>().poostsList.isEmpty,
      appBar: _appBar(context),
      body: BlocProvider.value(
        value: context.read<HomeFeedCubit>(),
        child: const HomeFeed(),
      ),
      floatingActionButton: _fab(context),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) => AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: Text(
          'PooApp',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w900,
          ),
        ),
        leadingWidth: 64,
        leading: AppBarIcon(
          onPressed: () => context.push(AppRoutes.friends),
          icon: Icons.people,
          isLeading: true,
        ),
        actions: [
          AppBarIcon(
            onPressed: () => context.push(AppRoutes.profile),
            icon: context.read<AuthBloc>().getCurrentUser()?.photoURL,
          ),
        ],
      );

  Widget _fab(BuildContext context) {
    final l10n = context.l10n;
    return FloatingActionButton.extended(
      onPressed: () => showModalBottomSheet<dynamic>(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        builder: (context) => BlocProvider(
          create: (_) => getIt<PoostCreationBloc>(),
          child: const PoostCreationPage(),
        ),
      ),
      icon: const Icon(Icons.add),
      label: Text(
        l10n.add_poost,
        style: GoogleFonts.inter(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
