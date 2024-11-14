import 'package:chattodo/models/redo.model.dart';
import 'package:chattodo/repository/redo_repository.dart';
import 'package:chattodo/util/common.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'redo_provider.g.dart';

@riverpod
class CrudRedo extends _$CrudRedo {
  @override
  FutureOr<List<Redo>> build() async {
    return ref.read(redoRepositoryProvider).getRedos();
  }

  void addRedo({required String title}) async {
    final newRedo = Redo.add(title: title, createDate: now);
    await ref.read(redoRepositoryProvider).addRedo(redo: newRedo);
    state = AsyncData([...?state.value, newRedo]);
  }

  void deleteRedo(Redo entity) async {
    await ref.read(redoRepositoryProvider).removeRedo(id: entity.id);
    state = AsyncData([
      for (final redo in state.value ?? [])
        if (redo.id != entity.id) redo
    ]);
  }

  void editRedo({required Redo entity, required String title}) async {
    final newRedo = entity.copyWith(title: title);
    await ref
        .read(redoRepositoryProvider)
        .editRedo(id: entity.id, editRedo: newRedo);
    state = AsyncData([
      for (final redo in state.value ?? [])
        redo.id == entity.id ? newRedo : redo
    ]);
  }
}
