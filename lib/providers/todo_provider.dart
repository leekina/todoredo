import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/todo.model.dart';

import 'package:todoredo/repository/todo_repository.dart';
import 'package:todoredo/util/common.dart';

part 'todo_provider.g.dart';

@riverpod
class CrudTodo extends _$CrudTodo {
  @override
  FutureOr<List<Todo>> build() async {
    return ref.read(todoRepositoryProvider).getTodos();
  }

  void addTodo({required String chat, DateTime? date, TodoType? type}) async {
    final newTodo = Todo.add(
      todo: chat,
      createDate: date ?? DateTime.now(),
      type: type ?? TodoType.todo,
    );
    await ref.read(todoRepositoryProvider).addTodo(todo: newTodo);
    state = AsyncData([...?state.value, newTodo]);
  }

  void addTodoFromSchedule(Todo todo) async {
    await ref.read(todoRepositoryProvider).addTodo(todo: todo);
    state = AsyncData([...?state.value, todo]);
  }

  void editTodoTitle(String id, String chat) async {
    await ref.read(todoRepositoryProvider).editTodoTitle(id: id, desc: chat);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == id ? todo.copyWith(title: chat) : todo
    ]);
  }

  void editTodoType(String id, TodoType type) async {
    await ref.read(todoRepositoryProvider).editTodoType(id: id, type: type);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == id ? todo.copyWith(type: type.name) : todo
    ]);
  }

  void toogleTodoComplete(String id) async {
    await ref.read(todoRepositoryProvider).toogleTodoComplete(id: id);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == id ? todo.copyWith(complete: !todo.complete) : todo
    ]);
  }

  void deleteTodo(String id) async {
    await ref.read(todoRepositoryProvider).removeTodo(id: id);
    state = AsyncData([
      for (final todo in state.value ?? [])
        if (todo.id != id) todo
    ]);
  }
}

@riverpod
class GetTodosOnly extends _$GetTodosOnly {
  @override
  FutureOr<List<Todo>> build() async {
    return ref.read(todoRepositoryProvider).getTodos(type: TodoType.todo);
  }
}

@riverpod
class GetSchedulesOnly extends _$GetSchedulesOnly {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(todoRepositoryProvider).getTodos(type: TodoType.schedule);
  }
}

@riverpod
class GetRedoOnly extends _$GetRedoOnly {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(todoRepositoryProvider).getTodos(type: TodoType.redo);
  }
}
