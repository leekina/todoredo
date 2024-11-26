import 'package:chattodo/models/todo.model.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bottom_widget.state.g.dart';

@riverpod
class CommentTodo extends _$CommentTodo {
  @override
  Todo? build() {
    return null;
  }

  void setTodo(Todo todo) {
    state = todo;
    if (todo.comment != null) {
      ref.read(todoTextfieldControllerProvider).text = todo.comment!;
    }
  }

  void initTodo() {
    state = null;
  }
}

@riverpod
class TodoTextfieldController extends _$TodoTextfieldController {
  @override
  TextEditingController build() {
    return TextEditingController();
  }
}
