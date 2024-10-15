import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'todo.model.g.dart';
part 'todo.model.freezed.dart';

const uuid = Uuid();

@freezed
class Todo with _$Todo {
  const factory Todo({
    required String id,
    required String title,
    required DateTime date,
    @Default(false) bool complete,
    @Default(false) bool redo,
  }) = _Todo;

  factory Todo.add(
      {required String todo, required bool re, required DateTime date}) {
    return Todo(
      id: uuid.v4(),
      title: todo,
      date: date,
      redo: re,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);
}
