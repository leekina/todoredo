import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/todo.model.dart';

import 'package:todoredo/repository/todo_repository.dart';
import 'package:todoredo/util/common.dart';

part 'todo_providers.g.dart';

@riverpod
class CrudTodo extends _$CrudTodo {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(todosRepositoryProvider).getTodos();
  }

  void addTodo({required String chat, DateTime? date, TodoType? type}) {
    final newTodo = Todo.add(
      todo: chat,
      date: date ?? DateTime.now(),
      type: type ?? TodoType.todo,
    );
    ref.read(todosRepositoryProvider).addTodo(todo: newTodo);
    state = AsyncData([...state.value!, newTodo]);
  }

  void editTodoTitle(String id, String chat) {
    ref.read(todosRepositoryProvider).editTodoTitle(id: id, desc: chat);
    state = AsyncData([
      for (final todo in state.value!)
        todo.id == id ? todo.copyWith(title: chat) : todo
    ]);
  }

  void editTodoType(String id, TodoType type) {
    ref.read(todosRepositoryProvider).editTodoType(id: id, type: type);
    state = AsyncData([
      for (final todo in state.value!)
        todo.id == id ? todo.copyWith(type: type) : todo
    ]);
  }

  void toogleTodoComplete(String id) {
    ref.read(todosRepositoryProvider).toogleTodoComplete(id: id);
    state = AsyncData([
      for (final todo in state.value!)
        todo.id == id ? todo.copyWith(complete: !todo.complete) : todo
    ]);
  }

  void deleteTodo(String id) {
    ref.read(todosRepositoryProvider).removeTodo(id: id);
    state = AsyncData([
      for (final todo in state.value!)
        if (todo.id != id) todo
    ]);
  }
}

@riverpod
class GetTodo extends _$GetTodo {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(todosRepositoryProvider).getTodos(type: TodoType.todo);
  }
}

@riverpod
class GetSchedule extends _$GetSchedule {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(todosRepositoryProvider).getTodos(type: TodoType.schedule);
  }
}

@riverpod
class GetRedo extends _$GetRedo {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(todosRepositoryProvider).getTodos(type: TodoType.redo);
  }
}
