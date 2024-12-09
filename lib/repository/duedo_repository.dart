import 'package:chattodo/model/models/duedo.model.dart';
import 'package:chattodo/util/common.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'duedo_repository.g.dart';

@riverpod
DuedoRepository duedoRepository(Ref ref) {
  throw UnimplementedError();
}

class DuedoRepository {
  final Box duedoBox = Hive.box('duedos');

  Future<void> addDuedo({required Duedo duedo}) async {
    try {
      duedoBox.put(duedo.id, duedo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Duedo>> getDuedos({DateTime? date}) async {
    try {
      final duedoListAll = duedoBox.values
          .map((e) => Duedo.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      if (date != null) {
        final duedoList = [
          for (final duedo in duedoListAll)
            if (duedo.dueDate.year == date.year &&
                duedo.dueDate.month == date.month &&
                duedo.dueDate.day == date.day)
              duedo
        ];
        duedoList.sort(duedoDateCompare);
        return duedoList;
      }
      duedoListAll.sort(duedoDateCompare);
      return duedoListAll;
    } catch (e) {
      rethrow;
    }
  }

  Future<Duedo?> getDuedo(String id) async {
    try {
      final duedo = duedoBox.get(id);

      return duedo == null
          ? null
          : Duedo.fromJson(Map<String, dynamic>.from(duedo));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removeDuedo({required String id}) async {
    try {
      await duedoBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editDuedo({required String id, required Duedo editDuedo}) async {
    try {
      final duedo = Duedo.fromJson(Map<String, dynamic>.from(duedoBox.get(id)));
      if (duedo.id == editDuedo.id) await duedoBox.put(id, editDuedo.toJson());
    } catch (e) {
      rethrow;
    }
  }

  // Future<void> addDuedoTutorial() async {
  //   for (final duedo in tutorialDuedo) {
  //     await addDuedo(duedo: duedo);
  //   }
  // }
}
