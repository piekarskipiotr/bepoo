import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:bepoo/widgets/loading_overlay/cubit/loading_overlay_state.dart';

@lazySingleton
class LoadingOverlayCubit extends Cubit<LoadingOverlayState> {
  LoadingOverlayCubit() : super(Waiting());

  void changeLoadingState({required bool isLoading}) =>
      emit(isLoading ? Loading() : Waiting());
}
