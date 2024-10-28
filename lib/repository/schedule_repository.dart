import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/repository/repository_scheme.dart';
import 'package:todoredo/util/common.dart';

part 'schedule_repository.g.dart';

@riverpod
ScheduleRepository scheduleRepository(ScheduleRepositoryRef ref) {
  throw UnimplementedError();
}

class ScheduleRepository extends TodoRepositoryScheme {
  final Box scheduleBox = Hive.box('schedule');

  @override
  Future<List<Todo>> getTodos({TodoType? type}) async {
    try {
      return [
        for (final todo in scheduleBox.values)
          Todo.fromJson(Map<String, dynamic>.from(todo))
      ];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addTodo({required Todo todo}) async {
    try {
      scheduleBox.put(todo.id, todo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editTodoTitle({required String id, required String desc}) async {
    try {
      final todoMap = scheduleBox.get(id);
      todoMap['desc'] = desc;
      await scheduleBox.put(id, todoMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeTodo({required String id}) async {
    try {
      await scheduleBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }
}
