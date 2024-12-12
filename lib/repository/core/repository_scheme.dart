import 'package:chattodo/model/models/common.dart';
import 'package:chattodo/model/models/redo.model.dart';
import 'package:chattodo/model/models/todo.model.dart';

abstract interface class TodoRepositoryScheme {
  Future<List<Todo>> getTodos({TodoType? type});

  Future<void> addTodo({required Todo todo});

  Future<void> removeTodo({required String id});

  Future<void> editTodo({
    required String id,
    required Todo editTodo,
  });
}

abstract class RedoRepositoryScheme {
  Future<List<Redo>> getRedos();

  Future<void> addRedo({required Redo redo});

  Future<void> removeRedo({required String id});

  Future<void> editRedo({
    required String id,
    required Redo editRedo,
  });
}
