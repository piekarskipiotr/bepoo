import 'package:bepoo/data/repositories/notifications_repository.dart';
import 'package:bepoo/pages/home/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HomeCubit extends Cubit<HomeState> {
  HomeCubit(
    this._notificationRepository,
  ) : super(InitHomeState()) {
    _initNotifications();
  }

  final NotificationRepository _notificationRepository;

  Future<void> _initNotifications() async {
    await _notificationRepository.requestPermission();
    await _notificationRepository.loadFCM();
    await _notificationRepository.listenFCM();
    await _notificationRepository.initializeNotification();
    _notificationRepository.cancelAll();
  }
}
