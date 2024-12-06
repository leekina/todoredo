import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

CalendarStyle getCalendarStyle(Color mainColor) {
  return CalendarStyle(
    cellMargin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
    cellPadding: EdgeInsets.only(top: 2),
    cellAlignment: Alignment.topCenter,
    defaultDecoration: BoxDecoration(shape: BoxShape.rectangle),
    weekendDecoration: BoxDecoration(shape: BoxShape.rectangle),
    rangeEndDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      color: mainColor,
    ),
    rangeStartDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      color: mainColor,
    ),
    withinRangeDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      color: Color(0xffbbddff),
    ),
    todayDecoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    outsideDecoration: BoxDecoration(shape: BoxShape.rectangle),
    selectedDecoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
      shape: BoxShape.rectangle,
      border: Border.all(color: mainColor),
    ),
    todayTextStyle: TextStyle(color: Colors.blue.shade800),
    selectedTextStyle: TextStyle(color: mainColor),
  );
}
