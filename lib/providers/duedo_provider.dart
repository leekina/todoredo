import 'package:chattodo/models/duedo.model.dart';

import 'package:chattodo/repository/duedo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'duedo_provider.g.dart';

@riverpod
class CrudDuedo extends _$CrudDuedo {
  @override
  FutureOr<List<Duedo>> build() async {
    return ref.read(duedoRepositoryProvider).getDuedos();
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
  }

  void deleteDuedo(Duedo entity) async {
    await ref.read(duedoRepositoryProvider).removeDuedo(id: entity.id);
    state = AsyncData([
      for (final redo in state.value ?? [])
        if (redo.id != entity.id) redo
    ]);
  }

  void editDuedo({required Duedo entity, required String title}) async {
    final newDuedo = entity.copyWith(title: title);
    await ref.read(duedoRepositoryProvider).editDuedo(
          id: entity.id,
          editDuedo: newDuedo,
        );
    state = AsyncData([
      for (final duedo in state.value ?? [])
        duedo.id == entity.id ? newDuedo : duedo
    ]);
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
