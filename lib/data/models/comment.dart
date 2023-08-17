import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bepoo/data/models/user_data.dart';
import 'package:uuid/uuid.dart';

part 'comment.freezed.dart';

part 'comment.g.dart';

typedef UUID = String;

@freezed
class Comment with _$Comment {
  factory Comment({
    required String poostId,
    required String userId,
    required String content,
  }) {
    return _Comment(
      poostId: poostId,
      id: _generateUuid(),
      userId: userId,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: null,
    );
  }

  const factory Comment.def({
    required String poostId,
    required String id,
    required String userId,
    required String content,
    required DateTime createdAt,
    required DateTime? updatedAt,
    // ignore: invalid_annotation_target
    @JsonKey(includeToJson: false, includeFromJson: false) UserData? userData,
  }) = _Comment;

  factory Comment.fromJson(Map<String, Object?> json) =>
      _$CommentFromJson(json);

  static UUID _generateUuid() {
    const uuid = Uuid();
    return uuid.v4();
  }
}
