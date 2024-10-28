import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/todo.model.dart';

import 'package:todoredo/repository/todo_repository.dart';
import 'package:todoredo/util/common.dart';

part 'todo_providers.g.dart';

//TODO: 상태관리자 적용하기

@riverpod
class CrudTodo extends _$CrudTodo {
  @override
  FutureOr<List<Todo>?> build() async {
    return null;
  }

  void addTodo({required String chat, DateTime? date, TodoType? type}) async {
    final newTodo = Todo.add(
      todo: chat,
      date: date ?? DateTime.now(),
      type: type ?? TodoType.todo,
    );
    await ref.read(todosRepositoryProvider).addTodo(todo: newTodo);
    state = AsyncData([...?state.value, newTodo]);
  }

  void editTodoTitle(String id, String chat) async {
    await ref.read(todosRepositoryProvider).editTodoTitle(id: id, desc: chat);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == id ? todo.copyWith(title: chat) : todo
    ]);
  }

  void editTodoType(String id, TodoType type) async {
    await ref.read(todosRepositoryProvider).editTodoType(id: id, type: type);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == id ? todo.copyWith(type: type.name) : todo
    ]);
  }

  void toogleTodoComplete(String id) async {
    await ref.read(todosRepositoryProvider).toogleTodoComplete(id: id);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == id ? todo.copyWith(complete: !todo.complete) : todo
    ]);
  }

  void deleteTodo(String id) async {
    await ref.read(todosRepositoryProvider).removeTodo(id: id);
    state = AsyncData([
      for (final todo in state.value ?? [])
        if (todo.id != id) todo
    ]);
  }
}

@riverpod
class GetAllTodos extends _$GetAllTodos {
  @override
  FutureOr<List<Todo>> build() async {
    ref.listen(
      crudTodoProvider,
      (previous, next) {
        // state = AsyncData([...state.value!.merge(next)]);
      },
    );
    return ref.read(todosRepositoryProvider).getTodos();
  }
}

@riverpod
class GetTodosOnly extends _$GetTodosOnly {
  @override
  FutureOr<List<Todo>> build() async {
    return ref.read(todosRepositoryProvider).getTodos(type: TodoType.todo);
  }
}

@riverpod
class GetSchedulesOnly extends _$GetSchedulesOnly {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(todosRepositoryProvider).getTodos(type: TodoType.schedule);
  }
}

@riverpod
class GetScheduleNotCompleted extends _$GetScheduleNotCompleted {
  @override
  FutureOr<List<Todo>> build() async {
    final schedules = ref.watch(getSchedulesOnlyProvider).valueOrNull;
    if (schedules != null) {
      final scheduleNot = [
        for (final schedule in schedules)
          if (schedule.complete == false) schedule
      ];
      return scheduleNot;
    }
    return [];
  }
}

@riverpod
class GetRedo extends _$GetRedo {
  @override
  FutureOr<List<Todo>> build() {
    return ref.read(todosRepositoryProvider).getTodos(type: TodoType.redo);
  }
}
