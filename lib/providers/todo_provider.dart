import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/providers/schedule_provider.dart';

import 'package:todoredo/repository/todo_repository.dart';
import 'package:todoredo/util/common.dart';

part 'todo_provider.g.dart';

@riverpod
class CrudTodo extends _$CrudTodo {
  void addTodo({required String chat, DateTime? date, TodoType? type}) async {
    final newTodo = Todo.add(
      todo: chat,
      createDate: date ?? now,
      type: type ?? TodoType.todo,
    );
    await ref.read(todoRepositoryProvider).addTodo(todo: newTodo);
    state = AsyncData([...?state.value, newTodo]);
  }

  void addTodoFromSchedule(Todo todo) async {
    final newTodo = todo.copyWith(
        complete: true, completeDate: DateTime(now.year, now.month, now.day));
    await ref.read(todoRepositoryProvider).addTodo(todo: newTodo);
    state = AsyncData([...?state.value, newTodo]..sort(dateCompare));
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

  void toogleTodoComplete(Todo entity) async {
    final fixedTodo = entity.complete
        ? entity.copyWith(complete: false, completeDate: null)
        : entity.copyWith(complete: true, completeDate: now);
    //스케쥴 일 경우에는 완료안된 스케쥴로 복귀
    if (entity.type == TodoType.schedule.name) {
      ref.read(crudScheduleProvider.notifier).addScheduleFromTodo(fixedTodo);
      deleteTodo(entity.id);
    } else {
      await ref
          .read(todoRepositoryProvider)
          .toogleTodoComplete(entity: fixedTodo);
      state = AsyncData([
        for (final todo in state.value ?? [])
          todo.id == entity.id ? fixedTodo : todo
      ]);
    }
  }

  void deleteTodo(String id) async {
    await ref.read(todoRepositoryProvider).removeTodo(id: id);
    state = AsyncData([
      for (final todo in state.value ?? [])
        if (todo.id != id) todo
    ]);
  }

  @override
  FutureOr<List<Todo>> build() async {
    return ref.read(todoRepositoryProvider).getTodos();
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
