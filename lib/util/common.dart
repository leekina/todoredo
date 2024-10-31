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
