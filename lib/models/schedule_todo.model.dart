import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todoredo/util/common.dart';

part 'schedule_todo.model.freezed.dart';
part 'schedule_todo.model.g.dart';

@freezed
class ScheduleTodo with _$ScheduleTodo {
  const factory ScheduleTodo({
    required String id,
    required String title,
    required DateTime date,
    @Default(false) bool complete,
    @Default(false) bool redo,
  }) = _ScheduleTodo;

  factory ScheduleTodo.add(
      {required String todo, required bool re, required DateTime date}) {
    return ScheduleTodo(
      id: uuid.v4(),
      title: todo,
      date: date,
      redo: re,
    );
  }

  factory ScheduleTodo.fromJson(Map<String, dynamic> json) =>
      _$ScheduleTodoFromJson(json);
}
