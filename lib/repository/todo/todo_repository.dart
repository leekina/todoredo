import 'package:chattodo/model/models/common.dart';
import 'package:chattodo/repository/tutorial/tutorial_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:chattodo/model/models/todo.model.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chattodo/repository/core/repository_scheme.dart';
import 'package:chattodo/util/common.dart';
part '../todo_repository.g.dart';

@riverpod
TodoRepository todoRepository(Ref ref) {
  throw UnimplementedError();
}

class TodoRepository implements TodoRepositoryScheme {
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
      todoList.sort(todoDateCompare);
      //Type 정의되면 타입에 해당하는것만
      //default : 전체
      switch (type) {
        case TodoType.todo:
          return [
            for (final todo in todoList)
              if (todo.type == TodoType.todo) todo
          ];
        case TodoType.duedo:
          return [
            for (final todo in todoList)
              if (todo.type == TodoType.duedo) todo
          ];
        case TodoType.redo:
          return [
            for (final todo in todoList)
              if (todo.type == TodoType.redo) todo
          ];
        default:
          return todoList;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Todo?> getTedo(String id) async {
    try {
      final todo = todoBox.get(id);
      return Todo.fromJson(Map<String, dynamic>.from(todo));
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

  Future<void> addTodoTutorial() async {
    for (final todo in tutorialTodo) {
      await addTodo(todo: todo);
    }
  }
}
