import 'package:bepoo/data/enums/app_permission.dart';
import 'package:bepoo/di/get_it.dart';
import 'package:bepoo/pages/friends/cubit/friends_cubit.dart';
import 'package:bepoo/pages/friends/friends.dart';
import 'package:bepoo/pages/home/cubit/home_feed_cubit.dart';
import 'package:bepoo/pages/home/home.dart';
import 'package:bepoo/pages/permission_rationale/permission_rationale.dart';
import 'package:bepoo/pages/profile/bloc/profile_bloc.dart';
import 'package:bepoo/pages/profile/profile.dart';
import 'package:bepoo/pages/settings/settings.dart';
import 'package:bepoo/pages/sign_in/sign_in.dart';
import 'package:bepoo/pages/user_name_set_up/user_name_set_up.dart';
import 'package:bepoo/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final instance = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) async {
          final isAuthenticated = getIt<AuthBloc>().isAuthenticated();
          if (isAuthenticated) {
            return AppRoutes.home;
          }

          return AppRoutes.signIn;
        },
      ),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => BlocProvider.value(
          value: getIt<AuthBloc>(),
          child: const SignInPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.userNameSetUp,
        builder: (context, state) => BlocProvider.value(
          value: getIt<UserNameSetUpCubit>(),
          child: UserNameSetUpPage(
            formKey: GlobalKey<FormState>(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: getIt<AuthBloc>(),
            ),
            BlocProvider.value(
              value: getIt<HomeFeedCubit>(),
            ),
          ],
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.friends,
        builder: (context, state) => BlocProvider.value(
          value: getIt<FriendsCubit>()..fetchUserFriendsInfo(),
          child: const FriendsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: getIt<AuthBloc>(),
            ),
            BlocProvider.value(
              value: getIt<ProfileBloc>(),
            ),
          ],
          child: const ProfilePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => BlocProvider.value(
          value: getIt<AuthBloc>(),
          child: const SettingsPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.permissionRationale,
        builder: (context, state) {
          final appPermission = state.extra! as AppPermission;
          return PermissionRationalePage(appPermission: appPermission);
        },
      ),
    ],
  );
}
