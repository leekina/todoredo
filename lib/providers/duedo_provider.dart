import 'package:chattodo/model/models/duedo.model.dart';
import 'package:chattodo/providers/todo_provider.dart';

import 'package:chattodo/repository/duedo_repository.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'duedo_provider.g.dart';

@riverpod
class CrudDuedo extends _$CrudDuedo {
  @override
  FutureOr<List<Duedo>> build() async {
    return ref.read(duedoRepositoryProvider).getDuedos();
  }

  void addDuedo({required String title, required DateTime dueDate}) async {
    final newDuedo =
        Duedo.add(title: title, createDate: DateTime.now(), dueDate: dueDate);
    await ref.read(duedoRepositoryProvider).addDuedo(duedo: newDuedo);
    ref.invalidateSelf();

    ref.read(crudTodoProvider.notifier).addDueTodo(
          chat: '${DateFormat('MM. dd').format(dueDate)} ${newDuedo.title} 등록',
          duedoId: newDuedo.id,
          complete: true,
        );
  }
}

@riverpod
class GetDuedoWithDate extends _$GetDuedoWithDate {
  @override
  FutureOr<List<Duedo>> build({required DateTime date}) async {
    listenSelf((previous, next) {
      ref.invalidate(crudDuedoProvider);
    });
    return ref.read(duedoRepositoryProvider).getDuedos(date: date);
  }

  void addDuedo({required String title, required DateTime dueDate}) async {
    final newDuedo =
        Duedo.add(title: title, createDate: DateTime.now(), dueDate: dueDate);
    await ref.read(duedoRepositoryProvider).addDuedo(duedo: newDuedo);
    state = AsyncData([...?state.value, newDuedo]);
    ref.read(crudTodoProvider.notifier).addTodo(
          chat: '${DateFormat('MM. dd').format(dueDate)} ${newDuedo.title} 등록',
        );
  }

  void deleteDuedo(Duedo entity) async {
    await ref.read(duedoRepositoryProvider).removeDuedo(id: entity.id);
    state = AsyncData([
      for (final redo in state.value ?? [])
        if (redo.id != entity.id) redo
    ]);
  }

  void editDuedoTitle({required Duedo entity, required String title}) async {
    final newDuedo = entity.copyWith(title: title);
    await ref.read(duedoRepositoryProvider).editDuedo(
          id: entity.id,
          editDuedo: newDuedo,
        );
    state = AsyncData([
      for (final duedo in state.value ?? [])
        duedo.id == entity.id ? newDuedo : duedo
    ]);
    ref.read(crudTodoProvider.notifier).addDueTodo(
          chat: '수정: ${entity.title} -> ${newDuedo.title}',
          duedoId: newDuedo.id,
          complete: newDuedo.complete,
          comment:
              '${DateFormat('MM. dd').format(newDuedo.dueDate)} ${newDuedo.title}',
        );
  }

  void editDuedoDueDate(
      {required Duedo entity, required DateTime dueDate}) async {
    final newDuedo = entity.copyWith(dueDate: dueDate);
    await ref.read(duedoRepositoryProvider).editDuedo(
          id: entity.id,
          editDuedo: newDuedo,
        );
    state = AsyncData([
      for (final duedo in state.value ?? [])
        duedo.id == entity.id ? newDuedo : duedo
    ]);
    ref.read(crudTodoProvider.notifier).addDueTodo(
          chat:
              '수정: ${DateFormat('MM. dd').format(entity.dueDate)} -> ${DateFormat('MM. dd').format(newDuedo.dueDate)}',
          duedoId: newDuedo.id,
          complete: newDuedo.complete,
          comment:
              '${DateFormat('MM. dd').format(newDuedo.dueDate)} ${newDuedo.title}',
        );
  }

  void toggleDuedoComplete(Duedo entity) async {
    final newDuedo = entity.copyWith(complete: !entity.complete);
    await ref.read(duedoRepositoryProvider).editDuedo(
          id: entity.id,
          editDuedo: newDuedo,
        );
    state = AsyncData([
      for (final duedo in state.value ?? [])
        duedo.id == entity.id ? newDuedo : duedo
    ]);

    ref.read(crudTodoProvider.notifier).addDueTodo(
          chat:
              '${DateFormat('MM. dd').format(entity.dueDate)} ${newDuedo.title} ${newDuedo.complete ? '완료' : '미완료'}',
          duedoId: newDuedo.id,
          complete: newDuedo.complete,
        );
  }
}

@riverpod
class GetCurrentDateDuedo extends _$GetCurrentDateDuedo {
  @override
  FutureOr<Duedo?> build() async {
    final duedoList = ref.watch(crudDuedoProvider);
    final duedo = duedoList.maybeWhen(
      data: (duedos) {
        for (final duedo in duedos) {
          if (duedo.dueDate.isAfter(DateTime.now()) && !duedo.complete) {
            return duedo;
          }
        }
        return null;
      },
      orElse: () => null,
    );
    return duedo;
  }
}
