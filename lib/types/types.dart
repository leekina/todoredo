import 'package:flutter/material.dart';

extension DateTimeX on DateTime {
  DateTime get date => DateTime(year, month, day);
  TimeOfDay get time => TimeOfDay(hour: hour, minute: minute);
}
