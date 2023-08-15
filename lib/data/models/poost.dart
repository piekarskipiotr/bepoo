import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pooapp/data/enums/poop_type.dart';
import 'package:pooapp/data/models/user_data.dart';
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
    String? newestComment,
    String? newestCommentUserName,
    // ignore: invalid_annotation_target
    @JsonKey(includeToJson: false, includeFromJson: false) UserData? userData,
  }) = _Poost;

  factory Poost.fromJson(Map<String, dynamic> json) => _$PoostFromJson(json);

  static UUID _generateUuid() {
    const uuid = Uuid();
    return uuid.v4();
  }
}
