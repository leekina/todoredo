import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoredo/models/todo.model.dart';

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

enum ThemeColor {
  blue("블루", Colors.blue),
  purple("퍼플", Colors.purple),
  pink("핑크", Colors.pink),
  orange("오렌지", Colors.orange),
  brown("브라운", Colors.brown),
  green("그린", Colors.green),
  ;

  final String name;
  final Color color;

  const ThemeColor(this.name, this.color);
}

List<Todo> tutorial = [
  Todo.add(
    todo: "안녕하세요!",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 1),
    type: TodoType.todo,
  ),
  Todo.add(
    todo: "ChatTodo는 채팅치듯 간편하게 할일을 관리하는 어플입니다.",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 2),
    type: TodoType.todo,
  ),
  Todo.add(
    todo: "입력된 투두를 한번 클릭하면 강조됩니다.",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 3),
    type: TodoType.todo,
  ).copyWith(important: true),
  Todo.add(
    todo: "입력된 투두를 두번 클릭하면 완료됩니다.",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 4),
    type: TodoType.todo,
  ).copyWith(complete: true, completeDate: now),
  Todo.add(
    todo: "입력된 투두를 화면 오른쪽으로 슬라이드하면 삭제할 수 있습니다.",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 5),
    type: TodoType.todo,
  ),
  Todo.add(
    todo: "컬러 및 모드는 오른쪽 위 설정 페이지에서 설정가능합니다.",
    createDate: now.subtract(const Duration(days: 1)).copyWith(second: 6),
    type: TodoType.todo,
  ),
];
