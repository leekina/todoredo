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
  Future<void> editTodoTitle({required String id, required String desc}) async {
    try {
      final todoMap = todoBox.get(id);
      todoMap['title'] = desc;
      await todoBox.put(id, todoMap);
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
      todoList.sort(
        (a, b) {
          if (a.type == TodoType.schedule.name && a.completeDate != null) {
            return a.completeDate!.compareTo(b.createDate);
          }
          if (b.type == TodoType.schedule.name && b.completeDate != null) {
            return a.createDate.compareTo(b.completeDate!);
          }
          return a.createDate.compareTo(b.createDate);
        },
      );

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

  Future<void> toogleTodoComplete({required Todo entity}) async {
    try {
      await todoBox.put(entity.id, entity.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
