import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pooapp/di/get_it.dart';
import 'package:pooapp/pages/home/home.dart';
import 'package:pooapp/pages/sign_in/sign_in.dart';
import 'package:pooapp/pages/user_name_set_up/user_name_set_up.dart';
import 'package:pooapp/router/app_routes.dart';

class AppRouter {
  static final instance = GoRouter(
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
        builder: (context, state) => BlocProvider.value(
          value: getIt<UserNameSetUpCubit>(),
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.friends,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(AppRoutes.friends)),
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (context, state) => Scaffold(
          appBar: AppBar(title: Text(AppRoutes.profile)),
        ),
      ),
    ],
  );
}
