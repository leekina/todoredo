import 'package:chattodo/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chattodo/models/todo.model.dart';

import 'package:chattodo/repository/todo_repository.dart';
import 'package:chattodo/util/common.dart';

part 'todo_provider.g.dart';

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
  }

  void addReTodo(
      {required String chat, required String redoId, DateTime? date}) async {
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

  void editTodoType(Todo entity, TodoType type) async {
    final newtodo = entity.copyWith(type: type.name);
    await ref
        .read(todoRepositoryProvider)
        .editTodo(id: entity.id, editTodo: newtodo);
    state = AsyncData([
      for (final todo in state.value ?? [])
        todo.id == entity.id ? newtodo : todo
    ]);
  }

  void toggleTodoComplete(Todo entity) async {
    final fixedTodo = entity.complete
        ? entity.copyWith(complete: false, completeDate: null)
        : entity.copyWith(complete: true, completeDate: DateTime.now());

    if (entity.type == 'redo') {
      ref.read(crudRedoProvider.notifier).redoComplete(entity.redoId!);
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
    state = AsyncData([
      for (final todo in state.value ?? [])
        if (todo.id != entity.id) todo
    ]);
  }
}
