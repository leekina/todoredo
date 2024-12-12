import 'package:chattodo/model/models/common.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chattodo/util/common.dart';

part '../todo.model.g.dart';
part '../todo.model.freezed.dart';

@freezed
class Todo with _$Todo {
  const factory Todo({
    //default
    required String id,
    required String title,
    String? comment,
    required TodoType type,
    required DateTime createDate,
    DateTime? completeDate,
    bool? important,
    @Default(false) bool complete,
    String? connectedId,
  }) = _Todo;

  factory Todo.addTodo({
    required String todo,
    required DateTime createDate,
    String? comment,
  }) {
    return Todo(
      id: uuid.v4(),
      title: todo,
      type: TodoType.todo,
      createDate: createDate,
      comment: comment,
    );
  }

  factory Todo.addReTodo({
    required String todo,
    required DateTime createDate,
    required String redoId,
  }) {
    return Todo(
      id: uuid.v4(),
      connectedId: redoId,
      title: todo,
      type: TodoType.redo,
      createDate: createDate,
    );
  }

  factory Todo.addDueTodo({
    required String todo,
    required DateTime createDate,
    required String duedoId,
    String? comment,
    bool? complete,
  }) {
    return Todo(
      id: uuid.v4(),
      connectedId: duedoId,
      title: todo,
      type: TodoType.duedo,
      createDate: createDate,
      comment: comment,
      complete: complete ?? false,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
