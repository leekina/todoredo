import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todoredo/util/common.dart';

part 'todo.model.g.dart';
part 'todo.model.freezed.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required String type,
    required DateTime createDate,
    DateTime? completeDate,
    @Default(false) bool complete,
  }) = _Todo;

  factory Todo.add(
      {required String todo,
      required DateTime createDate,
      required TodoType type}) {
    return Todo(
      id: uuid.v4(),
      title: todo,
      type: type.name,
      createDate: createDate,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
