import 'package:hive/hive.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:todoredo/models/schedule.model.dart';
part 'schedule_repository.g.dart';

@riverpod
SchedulesRepository schedulesRepository(SchedulesRepositoryRef ref) {
  throw UnimplementedError();
}

abstract class SchedulesRepository {
  Future<List<Schedule>> getSchedules();
  Future<void> addSchedule({required Schedule schedule});
  Future<void> removeSchedule({required String id});
  Future<void> editSchedule({
    required String id,
    required String desc,
  });
  Future<void> completeSchedule({required String id});
}

class HiveScheduleRepository extends SchedulesRepository {
  final Box scheduleBox = Hive.box('schedules');

  @override
  Future<List<Schedule>> getSchedules() async {
    try {
      return [
        for (final schedule in scheduleBox.values)
          Schedule.fromJson(Map<String, dynamic>.from(schedule))
      ];
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addSchedule({required Schedule schedule}) async {
    try {
      scheduleBox.put(schedule.id, schedule.toJson());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> editSchedule({required String id, required String desc}) async {
    try {
      final scheduleMap = scheduleBox.get(id);
      scheduleMap['desc'] = desc;
      await scheduleBox.put(id, scheduleMap);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> removeSchedule({required String id}) async {
    try {
      await scheduleBox.delete(id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> completeSchedule({required String id}) async {
    try {
      final scheduleMap = scheduleBox.get(id);
      scheduleMap['complete'] = !scheduleMap['complete'];
      await scheduleBox.put(id, scheduleMap);
    } catch (e) {
      rethrow;
    }
  }
}
