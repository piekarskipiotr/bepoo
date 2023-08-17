import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bepoo/di/get_it.dart';
import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/sign_in/bloc/auth_bloc.dart';
import 'package:bepoo/router/app_routes.dart';
import 'package:bepoo/widgets/app_bar_icon.dart';
import 'package:bepoo/widgets/loading_overlay/cubit/loading_overlay_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener(
      bloc: context.read<AuthBloc>(),
      listener: (context, state) {
        getIt<LoadingOverlayCubit>().changeLoadingState(
          isLoading: state is LoggingOut,
        );

        if (state is UnAuthenticated) {
          context.go(AppRoutes.signIn);
        }
      },
      child: Scaffold(
        appBar: _appBar(context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              _button(
                title: l10n.log_out,
                onPressed: () => context.read<AuthBloc>().add(LogOut()),
                context: context,
                txtColor: Colors.red,
              ),
              // _button(
              //   title: l10n.delete_account,
              //   onPressed: () {
              // TODO(xazai): handle deleting account
              //   },
              //   context: context,
              //   bgColor: Colors.red,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        l10n.settings,
        style: GoogleFonts.inter(),
      ),
      leadingWidth: 64,
      leading: AppBarIcon(
        onPressed: () => context.pop(),
        icon: Icons.arrow_back_ios_new,
        isLeading: true,
      ),
    );
  }

  Widget _button({
    required String title,
    required VoidCallback onPressed,
    required BuildContext context,
    Color? bgColor,
    Color txtColor = Colors.white,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                backgroundColor:
                    bgColor == null ? null : MaterialStateProperty.all(bgColor),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
              ),
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                color: txtColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
