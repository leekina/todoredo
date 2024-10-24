import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:todoredo/util/common.dart';

part 'schedule.model.g.dart';
part 'schedule.model.freezed.dart';

@freezed
class Schedule with _$Schedule {
  const factory Schedule({
    required String id,
    required String title,
    required DateTime date,
    @Default(false) bool complete,
    @Default(false) bool redo,
  }) = _Schedule;

  factory Schedule.add(
      {required String todo, required bool re, required DateTime date}) {
    return Schedule(
      id: uuid.v4(),
      title: todo,
      date: date,
      redo: re,
    );
  }

  factory Schedule.fromJson(Map<String, dynamic> json) =>
      _$ScheduleFromJson(json);
}
