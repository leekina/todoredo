import 'package:chattodo/models/redo.model.dart';
import 'package:chattodo/models/todo.model.dart';
import 'package:chattodo/repository/redo_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'redo_provider.g.dart';

@riverpod
class CrudRedo extends _$CrudRedo {
  @override
  FutureOr<List<Redo>> build() async {
    return ref.read(redoRepositoryProvider).getRedos();
  }

  void addRedo({required String title}) async {
    final newRedo = Redo.add(title: title, createDate: DateTime.now());
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

  void redoUpdateComplete(Todo todo) async {
    final redo = await ref.read(redoRepositoryProvider).getRedo(todo.redoId!);
    if (redo != null) {
      final editRedo = redo.copyWith(
          completeCount: redo.completeCount + 1,
          retodoList: [...redo.retodoList, todo.id]);
      await ref
          .read(redoRepositoryProvider)
          .editRedo(id: todo.redoId!, editRedo: editRedo);
      state = AsyncData([
        for (final redo in state.value ?? [])
          redo.id == todo.redoId! ? editRedo : redo
      ]);
    }
  }

  void redoUpdateUncomplete(Todo todo) async {
    final redo = await ref.read(redoRepositoryProvider).getRedo(todo.redoId!);
    if (redo != null) {
      final editRedo =
          redo.copyWith(completeCount: redo.completeCount - 1, retodoList: [
        for (final todoId in redo.retodoList)
          if (todoId != todo.id) todoId
      ]);
      await ref
          .read(redoRepositoryProvider)
          .editRedo(id: todo.redoId!, editRedo: editRedo);
      state = AsyncData([
        for (final redo in state.value ?? [])
          redo.id == todo.redoId! ? editRedo : redo
      ]);
    }
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
