import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/todo.model.dart';

import 'package:todoredo/repository/todo_repository.dart';

part 'todo_providers.g.dart';

@riverpod
class CrudTodo extends _$CrudTodo {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(todosRepositoryProvider).getTodos();
  }

  void addTodo({required String chat, DateTime? date}) {
    final newTodo = Todo.add(todo: chat, date: date ?? DateTime.now());
    ref.read(todosRepositoryProvider).addTodo(todo: newTodo);
    state = AsyncData([...state.value!, newTodo]);
  }

  void editTodo(String id, String chat) {
    ref.read(todosRepositoryProvider).editTodo(id: id, desc: chat);
    state = AsyncData([
      for (final todo in state.value!)
        todo.id == id ? todo.copyWith(title: chat) : todo
    ]);
  }

  void deleteTodo(String id) {
    ref.read(todosRepositoryProvider).removeTodo(id: id);
    state = AsyncData([
      for (final todo in state.value!)
        if (todo.id != id) todo
    ]);
  }

  void completeTodo(String id) {
    ref.read(todosRepositoryProvider).completeTodo(id: id);
    state = AsyncData([
      for (final todo in state.value!)
        todo.id == id ? todo.copyWith(complete: !todo.complete) : todo
    ]);
  }
}
