import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'comment.freezed.dart';

part 'comment.g.dart';

typedef UUID = String;

@freezed
class Comment with _$Comment {
  factory Comment({
    required String userId,
    required String content,
  }) {
    return _Comment(
      id: _generateUuid(),
      userId: userId,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
  }

  const factory Comment.def({
    required String id,
    required String userId,
    required String content,
    required DateTime createdAt,
    required DateTime? updatedAt,
  }) = _Comment;

  factory Comment.fromJson(Map<String, Object?> json) =>
      _$CommentFromJson(json);

  static UUID _generateUuid() {
    const uuid = Uuid();
    return uuid.v4();
  }
}
