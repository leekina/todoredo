import 'package:hive/hive.dart';
import 'package:todoredo/models/todo.model.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/repository/repository_scheme.dart';
import 'package:todoredo/util/common.dart';
part 'todo_repository.g.dart';

@riverpod
TodoRepository todoRepository(TodoRepositoryRef ref) {
  throw UnimplementedError();
}

class TodoRepository extends TodoRepositoryScheme {
  final Box todoBox = Hive.box('todos');

  @override
  Future<void> addTodo({required Todo todo}) async {
    try {
      todoBox.put(todo.id, todo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editTodo({required String id, required Todo editTodo}) async {
    try {
      //double check
      final todo = Todo.fromJson(Map<String, dynamic>.from(todoBox.get(id)));
      if (todo.id == editTodo.id) await todoBox.put(id, editTodo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Todo>> getTodos({TodoType? type}) async {
    try {
      final todoList = todoBox.values
          .map((e) => Todo.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      todoList.sort(dateCompare);
      //Type 정의되면 타입에 해당하는것만
      //default : 전체
      switch (type) {
        case TodoType.todo:
          return [
            for (final todo in todoList)
              if (todo.type == TodoType.todo.name) todo
          ];
        case TodoType.schedule:
          return [
            for (final todo in todoList)
              if (todo.type == TodoType.schedule.name) todo
          ];
        case TodoType.redo:
          return [
            for (final todo in todoList)
              if (todo.type == TodoType.redo.name) todo
          ];
        default:
          return todoList;
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeTodo({required String id}) async {
    try {
      await todoBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTutorial() async {
    for (final todo in tutorial) {
      await addTodo(todo: todo);
    }
  }
}
