import 'package:chattodo/models/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chattodo/util/common.dart';

part 'todo.model.g.dart';
part 'todo.model.freezed.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    //default
    required String id,
    required String title,
    required TodoType type,
    required DateTime createDate,
    DateTime? completeDate,
    bool? important,
    @Default(false) bool complete,
    String? redoId,
  }) = _Todo;

  factory Todo.addTodo({
    required String todo,
    required DateTime createDate,
  }) {
    return Todo(
      id: uuid.v4(),
      title: todo,
      type: TodoType.todo,
      createDate: createDate,
    );
  }

  factory Todo.addReTodo({
    required String todo,
    required DateTime createDate,
    required String redoId,
  }) {
    return Todo(
      id: uuid.v4(),
      redoId: redoId,
      title: todo,
      type: TodoType.redo,
      createDate: createDate,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
