import 'package:chattodo/models/common.dart';
import 'package:chattodo/models/redo.model.dart';
import 'package:chattodo/models/todo.model.dart';

/* 
Repository에서는 상태변경이 일어나지 않음
모든 상태변경은 provider에서 일어남
*/

abstract class TodoRepositoryScheme {
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
