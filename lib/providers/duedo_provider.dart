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
}
