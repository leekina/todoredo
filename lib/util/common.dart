import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

FocusNode addTodoNode = FocusNode();
final now = DateTime.now();
final today = DateFormat('MM. dd').format(now);

enum TodoType {
  todo,
  schedule,
  redo,
}

int dateCompare(a, b) {
  final adate = a.type == TodoType.schedule.name && a.completeDate != null
      ? a.completeDate!
      : a.createDate;
  final bdate = b.type == TodoType.schedule.name && b.completeDate != null
      ? b.completeDate!
      : b.createDate;

  return adate.compareTo(bdate);
}
