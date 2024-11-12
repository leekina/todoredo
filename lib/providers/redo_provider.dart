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

  void addRedo() {}
  void removeRedo() {}
  void editRedo() {}
}
