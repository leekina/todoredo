import 'package:hive/hive.dart';
import 'package:todoredo/models/todo.model.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'todo_repository.g.dart';

@riverpod
TodosRepository todosRepository(TodosRepositoryRef ref) {
  throw UnimplementedError();
}

abstract class TodosRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo({required Todo todo});
  Future<void> removeTodo({required String id});
  Future<void> editTodo({
    required String id,
    required String desc,
  });
  Future<void> completeTodo({required String id});
  Future<void> changeReTodo({required String id});
}

class HiveTodoRepository extends TodosRepository {
  final Box todoBox = Hive.box('todos');

  @override
  Future<List<Todo>> getTodos() async {
    try {
      return [
        for (final todo in todoBox.values)
          Todo.fromJson(Map<String, dynamic>.from(todo))
      ];
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
  Future<void> editTodo({required String id, required String desc}) async {
    try {
      final todoMap = todoBox.get(id);
      todoMap['desc'] = desc;
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

  @override
  Future<void> completeTodo({required String id}) async {
    try {
      final todoMap = todoBox.get(id);
      todoMap['complete'] = !todoMap['complete'];
      await todoBox.put(id, todoMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> changeReTodo({required String id}) async {
    try {
      final todoMap = todoBox.get(id);
      todoMap['redo'] = !todoMap['redo'];
      await todoBox.put(id, todoMap);
    } catch (e) {
      rethrow;
    }
  }
}
