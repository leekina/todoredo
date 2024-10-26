import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

FocusNode addTodoNode = FocusNode();

enum TodoType {
  todo,
  schedule,
  redo,
}
