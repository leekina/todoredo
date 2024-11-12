import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:chattodo/models/todo.model.dart';

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

List<Todo> tutorial = [
  Todo.addTodo(
    todo: "안녕하세요!",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 1),
  ),
  Todo.addTodo(
    todo: "ChatTodo는 채팅치듯 간편하게 할일을 관리하는 어플입니다.",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 2),
  ),
  Todo.addTodo(
    todo: "입력된 투두를 한번 클릭하면 강조됩니다.",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 3),
  ).copyWith(important: true),
  Todo.addTodo(
    todo: "입력된 투두를 두번 클릭하면 완료됩니다.",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 4),
  ).copyWith(complete: true, completeDate: now),
  Todo.addTodo(
    todo: "입력된 투두를 화면 오른쪽으로 슬라이드하면 삭제할 수 있습니다.",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 5),
  ),
  Todo.addTodo(
    todo: "완료되지 않은 투두를 1초이상 누르면 수정할 수 있습니다.",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 5),
  ),
];
