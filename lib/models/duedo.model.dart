import 'package:chattodo/util/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'duedo.model.g.dart';
part 'duedo.model.freezed.dart';

@freezed
class Duedo with _$Duedo {
  const factory Duedo({
    required String id,
    required String title,
    required DateTime createDate,
    required DateTime dueDate,
    @Default(false) bool complete,
  }) = _Duedo;

  factory Duedo.add({
    required DateTime createDate,
    required DateTime dueDate,
    required String title,
  }) {
    return Duedo(
      id: uuid.v4(),
      title: title,
      createDate: createDate,
      dueDate: dueDate,
    );
  }

  factory Duedo.fromJson(Map<String, dynamic> json) => _$DuedoFromJson(json);
}
