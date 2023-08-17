import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bepoo/di/get_it.dart';
import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/user_name_set_up/cubit/user_name_set_up_cubit.dart';
import 'package:bepoo/pages/user_name_set_up/cubit/user_name_set_up_state.dart';
import 'package:bepoo/router/app_routes.dart';
import 'package:bepoo/widgets/buttons/primary_button.dart';
import 'package:bepoo/widgets/loading_overlay/loading_overlay.dart';
import 'package:bepoo/widgets/snackbars/error_snack_bar.dart';

class UserNameSetUpPage extends StatelessWidget {
  const UserNameSetUpPage({required this.formKey, super.key});

  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener(
      bloc: context.read<UserNameSetUpCubit>(),
      listener: (context, state) {
        getIt<LoadingOverlayCubit>()
            .changeLoadingState(isLoading: state is Finishing);

        if (state is SettingUpSucceeded) {
          context.pushReplacement(AppRoutes.home);
        } else if (state is SettingUpFailed) {
          final error = state.error;
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackbar(context: context, error: error),
          );
        }
      },
      child: Form(
        key: formKey,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        l10n.user_name_set_up_title,
                        style: GoogleFonts.inter(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder(
                        bloc: context.read<UserNameSetUpCubit>(),
                        builder: (context, state) {
                          final isValid =
                              context.read<UserNameSetUpCubit>().isValid;

                          return TextFormField(
                            onChanged: (v) => context
                                .read<UserNameSetUpCubit>()
                                .validateUserName(v.trim()),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (v) => (v?.isNotEmpty ?? false)
                                ? (isValid ?? true)
                                    ? null
                                    : l10n.user_name_taken
                                : l10n.user_name_empty,
                            style: GoogleFonts.inter(),
                            autofocus: true,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.inter(),
                              suffixIcon: _suffixValidIndicator(
                                isLoading: state is ValidatingUserName,
                                isValid: isValid,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                PrimaryButton(
                  text: l10n.finish,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      context.read<UserNameSetUpCubit>().finishSettingUp();
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _suffixValidIndicator({
    required bool isLoading,
    required bool? isValid,
  }) {
    Icon? icon;

    switch (isValid) {
      case true:
        icon = const Icon(
          Icons.check_circle_outline_rounded,
          color: Colors.green,
        );
      case false:
        icon = const Icon(
          Icons.cancel_outlined,
          color: Color(0xFFCF6679),
        );
      case null:
        icon = null;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: isLoading
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                  ),
                ),
              ],
            )
          : icon,
    );
  }
}
