import 'package:chattodo/models/redo.model.dart';
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

  void redoComplete(String redoId) async {
    //TODO : 리투두 삭제, 컴플리트 변경될때 최근 날짜 수정하려면 구조차제가 변경되야함, 혹은 리투두들을 따로 가지고 있거나, 변경할 점이 필요함
    final redo = await ref.read(redoRepositoryProvider).getRedo(redoId);
    if (redo != null) {
      final editRedo = redo.copyWith(
          completeCount: redo.completeCount + 1,
          lastCompleteDate: DateTime.now());
      await ref
          .read(redoRepositoryProvider)
          .editRedo(id: redoId, editRedo: editRedo);
      state = AsyncData([
        for (final redo in state.value ?? [])
          redo.id == redoId ? editRedo : redo
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
