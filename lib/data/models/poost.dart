import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pooapp/data/enums/poop_type.dart';
import 'package:pooapp/data/models/comment.dart';
import 'package:uuid/uuid.dart';

part 'poost.freezed.dart';

part 'poost.g.dart';

typedef UUID = String;

@freezed
class Poost with _$Poost {
  factory Poost({
    required String userId,
    required String imageUrl,
    required PoopType poopType,
    required String? description,
  }) {
    return _Poost(
      id: _generateUuid(),
      userId: userId,
      imageUrl: imageUrl,
      poopType: poopType,
      description: description,
      createdAt: DateTime.now(),
      updatedAt: null,
      comments: <Comment>[],
    );
  }

  const factory Poost.def({
    required String id,
    required String userId,
    required String imageUrl,
    required PoopType poopType,
    required String? description,
    required DateTime createdAt,
    required DateTime? updatedAt,
    required List<Comment> comments,
  }) = _Poost;

  factory Poost.fromJson(Map<String, Object?> json) => _$PoostFromJson(json);

  static UUID _generateUuid() {
    const uuid = Uuid();
    return uuid.v4();
  }
}
