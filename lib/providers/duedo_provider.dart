import 'package:chattodo/models/duedo.model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'duedo_provider.g.dart';

@riverpod
class CrudDuedo extends _$CrudDuedo {
  @override
  FutureOr<List<Duedo>> build() async {
    return [];
  }

  void addDuedo({required String title, required DateTime dueDate}) async {
    final newRedo =
        Duedo.add(title: title, createDate: DateTime.now(), dueDate: dueDate);
    state = AsyncData([...?state.value, newRedo]);
  }

  void deleteDuedo(Duedo entity) async {
    state = AsyncData([
      for (final redo in state.value ?? [])
        if (redo.id != entity.id) redo
    ]);
  }

  void editDuedo({required Duedo entity, required String title}) async {
    final newRedo = entity.copyWith(title: title);

    state = AsyncData([
      for (final redo in state.value ?? [])
        redo.id == entity.id ? newRedo : redo
    ]);
  }
}
