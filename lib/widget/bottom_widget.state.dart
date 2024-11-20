import 'package:chattodo/models/todo.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  }

  void initTodo() {
    state = null;
  }
}
