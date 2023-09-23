import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_content.freezed.dart';
part 'notification_content.g.dart';

@freezed
class NotificationContent with _$NotificationContent {
  const factory NotificationContent({
    required String title,
    required String body,
  }) = _NotificationContent;

  factory NotificationContent.fromJson(Map<String, dynamic> json) =>
      _$NotificationContentFromJson(json);
}
