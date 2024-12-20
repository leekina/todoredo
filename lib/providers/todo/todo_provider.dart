import 'package:chattodo/model/models/common.dart';
import 'package:chattodo/pages/todo/state/chat_view.state.dart';
import 'package:chattodo/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chattodo/model/models/todo.model.dart';

import 'package:chattodo/repository/todo/todo_repository.dart';

part '../todo_provider.g.dart';

@riverpod
class CrudTodo extends _$CrudTodo {
  @override
  FutureOr<List<Todo>> build() async {
    return ref.read(todoRepositoryProvider).getTodos();
  }

  void addTodo({required String chat, DateTime? date}) async {
    final newTodo = Todo.addTodo(
      todo: chat,
      createDate: date ?? DateTime.now(),
    );
    await ref.read(todoRepositoryProvider).addTodo(todo: newTodo);
    state = AsyncData([...?state.value, newTodo]);
    ref.read(myScrollControllerProvider.notifier).moveToBottom();
  }

  void addDueTodo({
    required String chat,
    required String duedoId,
    DateTime? date,
    bool? complete,
    String? comment,
  }) async {
    final newTodo = Todo.addDueTodo(
      todo: chat,
      createDate: date ?? DateTime.now(),
      duedoId: duedoId,
      complete: complete,
      comment: comment,
    );
    await ref.read(todoRepositoryProvider).addTodo(todo: newTodo);
    state = AsyncData([...?state.value, newTodo]);
    ref.read(myScrollControllerProvider.notifier).moveToBottom();
  }

  void addReTodo({
    required String chat,
    required String redoId,
    DateTime? date,
  }) async {
    final newTodo = Todo.addReTodo(
      todo: chat,
      redoId: redoId,
      createDate: date ?? DateTime.now(),
    );
    await ref.read(todoRepositoryProvider).addTodo(todo: newTodo);
    state = AsyncData([...?state.value, newTodo]);
  }

  void editTodoTitle(Todo entity, String title) async {
    final newTodo = entity.copyWith(title: title);
    await ref
        .read(todoRepositoryProvider)
        .editTodo(id: entity.id, editTodo: newTodo);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == entity.id ? newTodo : todo
    ]);
  }

  void editTodoComment(Todo entity, String? comment) async {
    final newTodo = entity.copyWith(comment: comment);
    await ref
        .read(todoRepositoryProvider)
        .editTodo(id: entity.id, editTodo: newTodo);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == entity.id ? newTodo : todo
    ]);
  }

  void editTodoType(Todo entity, TodoType type) async {
    final newTodo = entity.copyWith(type: type);
    await ref
        .read(todoRepositoryProvider)
        .editTodo(id: entity.id, editTodo: newTodo);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == entity.id ? newTodo : todo
    ]);
  }

  void toggleTodoComplete(Todo entity) async {
    final fixedTodo = entity.complete
        ? entity.copyWith(complete: false, completeDate: null)
        : entity.copyWith(complete: true, completeDate: DateTime.now());

    if (entity.type == TodoType.redo) {
      entity.complete
          ? ref.read(crudRedoProvider.notifier).redoUpdateUncomplete(entity)
          : ref.read(crudRedoProvider.notifier).redoUpdateComplete(entity);
    }
    await ref
        .read(todoRepositoryProvider)
        .editTodo(id: fixedTodo.id, editTodo: fixedTodo);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == entity.id ? fixedTodo : todo
    ]);
  }

  void toggleTodoImportant(Todo entity) async {
    final fixedTodo =
        entity.copyWith(important: entity.important == true ? false : true);

    await ref
        .read(todoRepositoryProvider)
        .editTodo(id: fixedTodo.id, editTodo: fixedTodo);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == entity.id ? fixedTodo : todo
    ]);
  }

  void deleteTodo(Todo entity) async {
    await ref.read(todoRepositoryProvider).removeTodo(id: entity.id);
    if (entity.type == TodoType.redo) {
      if (entity.complete) {
        ref.read(crudRedoProvider.notifier).redoUpdateUncomplete(entity);
      }
    }
    state = AsyncData([
      for (final todo in state.value ?? [])
        if (todo.id != entity.id) todo
    ]);
  }
}

@riverpod
class GetTodo extends _$GetTodo {
  @override
  FutureOr<Todo?> build(String id) {
    return ref.read(todoRepositoryProvider).getTedo(id);
  }
}
