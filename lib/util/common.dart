import 'package:chattodo/models/common.dart';
import 'package:chattodo/models/redo.model.dart';
import 'package:flutter/material.dart';

import 'package:chattodo/models/todo.model.dart';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

FocusNode addTodoNode = FocusNode();
// final now = DateTime.now();
// final today = DateFormat('MM. dd').format(DateTime.now());

int dateCompare(a, b) {
  final adate = a.type == TodoType.duedo.name && a.completeDate != null
      ? a.completeDate!
      : a.createDate;
  final bdate = b.type == TodoType.duedo.name && b.completeDate != null
      ? b.completeDate!
      : b.createDate;

  return adate.compareTo(bdate);
}

List<Todo> tutorialTodo = [
  Todo.addTodo(
    todo: "안녕하세요!\nChatTodo는 채팅치듯 간편하게 할일을 관리하는 어플입니다.",
    createDate:
        DateTime.now().subtract(const Duration(days: 1)).copyWith(second: 1),
  ),
  Todo.addTodo(
    todo: "로고를 누르면 설정창으로 이동합니다",
    createDate:
        DateTime.now().subtract(const Duration(days: 1)).copyWith(second: 2),
  ),
  Todo.addTodo(
    todo: "입력된 투두를 한번 클릭하면 강조, 두번 클릭하면 완료됩니다.",
    createDate:
        DateTime.now().subtract(const Duration(days: 1)).copyWith(second: 3),
  ).copyWith(important: true),
  Todo.addTodo(
    todo: "입력된 투두를 화면 오른쪽으로 슬라이드하면 삭제할 수 있습니다.",
    createDate:
        DateTime.now().subtract(const Duration(days: 1)).copyWith(second: 4),
  ),
  Todo.addTodo(
    todo: "입력된 투두를 화면 왼쪽으로 슬라이드하면",
    createDate:
        DateTime.now().subtract(const Duration(days: 1)).copyWith(second: 5),
    comment: "투두에 메모를 남길 수 있습니다",
  ),
  Todo.addTodo(
    todo: "완료되지 않은 투두를 길게 누르면 수정할 수 있습니다.",
    createDate:
        DateTime.now().subtract(const Duration(days: 1)).copyWith(second: 6),
  ),
  Todo.addReTodo(
    todo: "채팅 치는곳의 왼쪽을 누르면 리두페이지로 이동합니다.",
    createDate:
        DateTime.now().subtract(const Duration(days: 1)).copyWith(second: 7),
    redoId: "1",
  ),
  Todo.addReTodo(
    todo: "추가된 리두는 여기에 표시됩니다!",
    createDate:
        DateTime.now().subtract(const Duration(days: 1)).copyWith(second: 8),
    redoId: "0",
  ),
];

final List<Redo> tutorialRedo = [
  Redo.add(
    title: '상단의 + 버튼을 클릭하여 리두를 등록하세요!',
    createDate:
        DateTime.now().subtract(const Duration(days: 1)).copyWith(second: 1),
  ),
  Redo.add(
    title: '리두는 완료한 회차와 마지막 완료 날짜를 기록합니다!',
    createDate:
        DateTime.now().subtract(const Duration(days: 1)).copyWith(second: 2),
  ),
];
