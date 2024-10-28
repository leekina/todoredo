import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/repository/schedule_repository.dart';
import 'package:todoredo/util/common.dart';

part 'schedule_provider.g.dart';

@riverpod
class CrudSchedule extends _$CrudSchedule {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(scheduleRepositoryProvider).getTodos();
  }

  void addSchedule({required String chat, DateTime? createDate}) async {
    final newTodo = Todo.add(
        todo: chat,
        createDate: createDate ?? DateTime.now(),
        type: TodoType.schedule);
    await ref.read(scheduleRepositoryProvider).addTodo(todo: newTodo);
    state = AsyncData([...?state.value, newTodo]);
  }

  void addScheduleFromTodo(Todo todo) async {
    await ref
        .read(scheduleRepositoryProvider)
        .addTodo(todo: todo.copyWith(complete: false));
    state = AsyncData([...?state.value, todo]);
  }

  void editTodoTitle(String id, String chat) async {
    await ref
        .read(scheduleRepositoryProvider)
        .editTodoTitle(id: id, desc: chat);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == id ? todo.copyWith(title: chat) : todo
    ]);
  }

  void deleteTodo(String id) async {
    await ref.read(scheduleRepositoryProvider).removeTodo(id: id);
    state = AsyncData([
      for (final todo in state.value ?? [])
        if (todo.id != id) todo
    ]);
  }
}
