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
  Future<List<Todo>> getTodos({TodoType? type}) async {
    try {
      //Type 정의되면 타입에 해당하는것만
      //default : 전체
      switch (type) {
        case TodoType.todo:
          return [
            for (final todo in todoBox.values)
              if (todo['type'] == TodoType.todo.name)
                Todo.fromJson(Map<String, dynamic>.from(todo))
          ];
        case TodoType.schedule:
          return [
            for (final todo in todoBox.values)
              if (todo['type'] == TodoType.schedule.name)
                Todo.fromJson(Map<String, dynamic>.from(todo))
          ];
        case TodoType.redo:
          return [
            for (final todo in todoBox.values)
              if (todo['type'] == TodoType.redo.name)
                Todo.fromJson(Map<String, dynamic>.from(todo))
          ];
        default:
          return [
            for (final todo in todoBox.values)
              Todo.fromJson(Map<String, dynamic>.from(todo))
          ];
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addTodo({required Todo todo}) async {
    try {
      todoBox.put(todo.id, todo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editTodoTitle({required String id, required String desc}) async {
    try {
      final todoMap = todoBox.get(id);
      todoMap['desc'] = desc;
      await todoBox.put(id, todoMap);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editTodoType(
      {required String id, required TodoType type}) async {
    try {
      final todoMap = todoBox.get(id);
      todoMap['type'] = type.name;
      await todoBox.put(id, todoMap);
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

  Future<void> toogleTodoComplete({required String id}) async {
    try {
      final todoMap = Todo.fromJson(todoBox.get(id));
      final completedTodo = todoMap.copyWith(
          complete: !todoMap.complete, completeDate: DateTime.now());
      await todoBox.put(id, completedTodo.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
