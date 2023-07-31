import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  factory User({
    required String id,
    required String name,
    String? avatarUrl,
  }) {
    return _User(
      id: id,
      name: name,
      avatarUrl: avatarUrl,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
  }

  const factory User.def({
    required String id,
    required String name,
    required String? avatarUrl,
    required DateTime createdAt,
    required DateTime? updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}
