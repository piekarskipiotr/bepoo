import 'package:bepoo/di/get_it.dart';
import 'package:bepoo/widgets/loading_overlay/cubit/loading_overlay_cubit.dart';
import 'package:bepoo/widgets/loading_overlay/cubit/loading_overlay_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<LoadingOverlayCubit>(),
      child: _LoadingOverlayBody(
        child: child,
      ),
    );
  }
}

class _LoadingOverlayBody extends StatelessWidget {
  const _LoadingOverlayBody({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        BlocBuilder(
          bloc: context.read<LoadingOverlayCubit>(),
          builder: (context, state) => state is Loading
              ? const Stack(
                  children: [
                    Opacity(
                      opacity: 0.5,
                      child: ModalBarrier(
                        dismissible: false,
                        color: Colors.black,
                      ),
                    ),
                    Center(
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ],
    );
  }
}
