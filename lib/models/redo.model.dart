import 'package:chattodo/util/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'redo.model.g.dart';
part 'redo.model.freezed.dart';

@freezed
class Redo with _$Redo {
  const factory Redo({
    required String id,
    required String title,
    required DateTime createDate,
    required List<String> retodoList,
    @Default(false) bool pin,
    @Default(0) int completeCount,
    String? redoId,
  }) = _Redo;

  factory Redo.add({
    required String title,
    required DateTime createDate,
  }) {
    return Redo(
      id: uuid.v4(),
      title: title,
      createDate: createDate,
      retodoList: [],
    );
  }

  factory Redo.fromJson(Map<String, dynamic> json) => _$RedoFromJson(json);
}
