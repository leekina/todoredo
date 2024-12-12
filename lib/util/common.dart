import 'package:chattodo/model/models/common.dart';
import 'package:chattodo/model/models/duedo.model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

FocusNode addTodoNode = FocusNode();

int todoDateCompare(a, b) {
  final adate = a.type == TodoType.duedo.name && a.completeDate != null
      ? a.completeDate!
      : a.createDate;
  final bdate = b.type == TodoType.duedo.name && b.completeDate != null
      ? b.completeDate!
      : b.createDate;

  return adate.compareTo(bdate);
}

int duedoDateCompare(a, b) {
  final adate = a is Duedo ? a.dueDate : a.createDate;
  final bdate = b is Duedo ? b.dueDate : b.createDate;

  return adate.compareTo(bdate);
}

String getDateToStringFormat(DateTime date) {
  return DateFormat('MM. dd').format(date);
}
