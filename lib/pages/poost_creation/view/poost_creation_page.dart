import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bepoo/di/get_it.dart';
import 'package:bepoo/helpers/app_action_dialog.dart';
import 'package:bepoo/l10n/l10n.dart';
import 'package:bepoo/pages/poost_creation/bloc/poost_creation_bloc.dart';
import 'package:bepoo/pages/poost_creation/view/poop_type_selection.dart';
import 'package:bepoo/pages/poost_creation/view/poost_description.dart';
import 'package:bepoo/pages/poost_creation/view/poost_image_selection.dart';
import 'package:bepoo/widgets/app_bar_icon.dart';
import 'package:bepoo/widgets/buttons/primary_button.dart';
import 'package:bepoo/widgets/loading_overlay/loading_overlay.dart';
import 'package:bepoo/widgets/snackbars/error_snack_bar.dart';

class PoostCreationPage extends StatefulWidget {
  const PoostCreationPage({super.key});

  @override
  State<PoostCreationPage> createState() => _PoostCreationPageState();
}

class _PoostCreationPageState extends State<PoostCreationPage> {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocListener(
      bloc: context.read<PoostCreationBloc>(),
      listener: (context, state) {
        getIt<LoadingOverlayCubit>()
            .changeLoadingState(isLoading: state is Creating);

        if (state is Created) {
          context.pop();
        }

        if (state is CreatingError) {
          final error = state.error;
          ScaffoldMessenger.of(context).showSnackBar(
            errorSnackbar(context: context, error: error),
          );
        }
      },
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.only(top: 60),
        child: Scaffold(
          appBar: _appBar(context),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  BlocProvider.value(
                    value: context.read<PoostCreationBloc>(),
                    child: const PoostImageSelection(),
                  ),
                  const SizedBox(height: 24),
                  BlocProvider.value(
                    value: context.read<PoostCreationBloc>(),
                    child: const PoopTypeSelection(),
                  ),
                  const SizedBox(height: 24),
                  BlocProvider.value(
                    value: context.read<PoostCreationBloc>(),
                    child: const PoostDescription(),
                  ),
                  const SizedBox(height: 72),
                ],
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: PrimaryButton(
              text: l10n.publish,
              onPressed: () => context.read<PoostCreationBloc>().add(
                    CreatePoost(),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    final l10n = context.l10n;
    return AppBar(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        l10n.add_poost,
        style: GoogleFonts.inter(),
      ),
      leadingWidth: 64,
      leading: AppBarIcon(
        onPressed: () => context.read<PoostCreationBloc>().isAnyFieldFilled()
            ? showCloseOrCancelDialog(context)
            : context.pop(),
        icon: Icons.close,
        isLeading: true,
      ),
    );
  }

  void showCloseOrCancelDialog(BuildContext context) {
    final l10n = context.l10n;
    AppActionDialog.show(
      title: l10n.close_poost_creator_title,
      subtitle: l10n.close_poost_creator_subtitle,
      primaryText: l10n.close,
      secondaryText: l10n.cancel,
      onPrimaryPressed: () => context
        ..pop()
        ..pop(),
      onSecondaryPressed: () => context.pop(),
      context: context,
    );
  }
}
