import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_data.freezed.dart';
part 'notification_data.g.dart';

@freezed
class NotificationData with _$NotificationData {
  const factory NotificationData({
    required String id,
    required String action,
    required String status,
  }) = _NotificationData;

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      _$NotificationDataFromJson(json);
}
