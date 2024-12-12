import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:table_calendar/table_calendar.dart';

part '../../canendar_page.state.g.dart';

@riverpod
class DuedoScrollController extends _$DuedoScrollController {
  @override
  ScrollController build() {
    return ScrollController();
  }

  void moveToCurrentDate(GlobalKey key) async {
    Scrollable.ensureVisible(
      key.currentContext!,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      alignment: 0,
    );
  }
}

@riverpod
class CurrentDate extends _$CurrentDate {
  @override
  DateTime build() {
    return DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day);
  }

  void updateCurrentDate(DateTime date) {
    state = date;
  }
}

@riverpod
class CurrentCalendarFormat extends _$CurrentCalendarFormat {
  @override
  CalendarFormat build() => CalendarFormat.month;

  void updateCalendarFormat(CalendarFormat format) {
    state = format;
  }
}
