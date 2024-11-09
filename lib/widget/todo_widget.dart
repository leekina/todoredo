import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:chattodo/models/todo.model.dart';
import 'package:chattodo/providers/todo_provider.dart';
import 'package:chattodo/util/common.dart';
import 'package:chattodo/widget/edit_chat_dialog.dart';
import 'package:chattodo/widget/todo_view.dart';

class TodoWidget extends HookConsumerWidget {
  const TodoWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      background: const ColoredBox(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            Text(
              'delete',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      key: ValueKey(todo.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        ref.read(crudTodoProvider.notifier).deleteTodo(todo.id);
      },
      child: GestureDetector(
        //길게 누르면 수정
        onLongPress: () {
          if (!todo.complete) {
            showDialog(
              context: context,
              builder: (context) {
                return EditTodoDialog(todo);
              },
            );
          }
        },
        onDoubleTap: () {
          ref.read(crudTodoProvider.notifier).toggleTodoComplete(todo);
          //언포커스
          addTodoNode.unfocus();
        },
        onTap: todo.complete == true
            ? null
            : () {
                ref.read(crudTodoProvider.notifier).toggleTodoImportant(todo);
              },
        child: TodoView(todo: todo),
      ),
    );
  }
}
