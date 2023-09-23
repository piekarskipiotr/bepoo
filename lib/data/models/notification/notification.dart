import 'package:bepoo/data/models/notification/notification_content.dart';
import 'package:bepoo/data/models/notification/notification_data.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification.freezed.dart';
part 'notification.g.dart';

@freezed
class Notification with _$Notification {
  const factory Notification({
    required NotificationData data,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'notification') required NotificationContent content,
    required String priority,
    // ignore: invalid_annotation_target
    @JsonKey(name: 'to') required String destinationToken,
  }) = _Notification;

  factory Notification.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
}
