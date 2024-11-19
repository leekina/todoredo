import 'package:chattodo/models/redo.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:chattodo/repository/repository_scheme.dart';

part 'redo_repository.g.dart';

@riverpod
RedoRepository redoRepository(Ref ref) {
  throw UnimplementedError();
}

class RedoRepository extends RedoRepositoryScheme {
  final Box redoBox = Hive.box('redos');

  @override
  Future<void> addRedo({required Redo redo}) async {
    try {
      redoBox.put(redo.id, redo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Redo>> getRedos() async {
    try {
      final redoList = redoBox.values
          .map((e) => Redo.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      return redoList;
    } catch (e) {
      rethrow;
    }
  }

  Future<Redo?> getRedo(String id) async {
    try {
      final redo = redoBox.get(id);

      return redo == null
          ? null
          : Redo.fromJson(Map<String, dynamic>.from(redo));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeRedo({required String id}) async {
    try {
      await redoBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editRedo({required String id, required Redo editRedo}) async {
    try {
      final redo = Redo.fromJson(Map<String, dynamic>.from(redoBox.get(id)));
      if (redo.id == editRedo.id) await redoBox.put(id, editRedo.toJson());
    } catch (e) {
      rethrow;
    }
  }
}
