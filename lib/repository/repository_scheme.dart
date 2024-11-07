import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/util/common.dart';

abstract class TodoRepositoryScheme {
  Future<List<Todo>> getTodos({TodoType? type});

  Future<void> addTodo({required Todo todo});

  Future<void> removeTodo({required String id});

  Future<void> editTodo({
    required String id,
    required Todo editTodo,
  });
}
