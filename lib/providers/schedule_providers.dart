import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/schedule.model.dart';
import 'package:todoredo/repository/schedule_repository.dart';

part 'schedule_providers.g.dart';

@riverpod
class CrudSchedule extends _$CrudSchedule {
  @override
  FutureOr<List<Schedule>> build() {
    return ref.read(schedulesRepositoryProvider).getSchedules();
  }

  void addSchedule({required String chat, required bool re, DateTime? date}) {
    final newSchedule =
        Schedule.add(todo: chat, re: re, date: date ?? DateTime.now());

    ref.read(schedulesRepositoryProvider).addSchedule(schedule: newSchedule);
    state = AsyncData([...state.value!, newSchedule]);
  }

  void editSchedule(String id, String chat) {
    ref.read(schedulesRepositoryProvider).editSchedule(id: id, desc: chat);
    state = AsyncData([
      for (final schedule in state.value!)
        schedule.id == id ? schedule.copyWith(title: chat) : schedule
    ]);
  }

  void deleteSchedule(String id) {
    ref.read(schedulesRepositoryProvider).removeSchedule(id: id);
    state = AsyncData([
      for (final schedule in state.value!)
        if (schedule.id != id) schedule
    ]);
  }

  void completeSchedule(String id) {
    ref.read(schedulesRepositoryProvider).completeSchedule(id: id);
    state = AsyncData([
      for (final schedule in state.value!)
        schedule.id == id
            ? schedule.copyWith(complete: !schedule.complete)
            : schedule
    ]);
  }
}
