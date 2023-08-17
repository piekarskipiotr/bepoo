import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bepoo/data/enums/sign_in_method.dart';
import 'package:bepoo/di/get_it.dart';
import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/sign_in/bloc/auth_bloc.dart';
import 'package:bepoo/resources/resources.dart';
import 'package:bepoo/router/app_routes.dart';
import 'package:bepoo/widgets/buttons/sign_in_button.dart';
import 'package:bepoo/widgets/loading_overlay/loading_overlay.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener(
      bloc: context.read<AuthBloc>(),
      listener: (context, state) {
        getIt<LoadingOverlayCubit>().changeLoadingState(
          isLoading: state is Authenticating || state is CheckingIfUserExists,
        );

        if (state is Authenticated) {
          context.read<AuthBloc>().add(CheckIfUserExists());
        }

        if (state is CheckingIfUserExistsSucceeded) {
          final doesUserExists = state.doesUserExists;
          context.pushReplacement(
            doesUserExists ? AppRoutes.home : AppRoutes.userNameSetUp,
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(),
                Column(
                  children: [
                    Image.asset(AppIcons.appIcon),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.only(right: 48),
                      child: Column(
                        children: [
                          Text(
                            l10n.sign_in_title,
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              height: 1.1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.sign_in_subtitle,
                            style: GoogleFonts.inter(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SignInButton(
                      signInMethod: SignInMethod.google,
                      onPressed: () => context.read<AuthBloc>().add(
                            SigningInWithGoogle(),
                          ),
                    ),
                    if (Platform.isIOS) ...[
                      const SizedBox(height: 16),
                      SignInButton(
                        signInMethod: SignInMethod.apple,
                        onPressed: () => context.read<AuthBloc>().add(
                              SigningInWithApple(),
                            ),
                      ),
                    ],
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
