import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/providers/schedule_provider.dart';
import 'package:todoredo/providers/todo_provider.dart';
import 'package:todoredo/util/common.dart';
import 'package:todoredo/widget/edit_chat_dialog.dart';

class TodoWidget extends HookConsumerWidget {
  final Todo todo;

  const TodoWidget({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Dismissible(
        key: ValueKey(todo.id),
        direction: todo.complete
            ? todo.type == TodoType.todo.name
                ? DismissDirection.startToEnd
                : DismissDirection.endToStart
            : DismissDirection.horizontal,
        onDismissed: (direction) {
          //스케쥴 추가후 삭제
          if (direction == DismissDirection.endToStart &&
              todo.type == TodoType.todo.name) {
            ref.read(crudScheduleProvider.notifier).addSchedule(
                  chat: todo.title,
                  createDate: todo.createDate,
                );
          }
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
          onTap: () {
            ref.read(crudTodoProvider.notifier).toogleTodoComplete(todo);
            //언포커스
            addTodoNode.unfocus();
          },
          child: TodoView(todo: todo),
        ),
      ),
    );
  }
}

class TodoView extends HookConsumerWidget {
  final Todo todo;
  const TodoView({
    super.key,
    required this.todo,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSchedule = todo.type == TodoType.schedule.name;
    final date = DateFormat('MM.dd').format(todo.createDate);
    return Row(
      mainAxisAlignment:
          isSchedule ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: todo.complete
                  ? Colors.green.shade900.withOpacity(0.8)
                  : Colors.white),
          child: Text(
            todo.title,
            style:
                TextStyle(color: todo.complete ? Colors.white : Colors.black),
          ),
        ),
        const SizedBox(width: 4),
        isSchedule
            ? Text(
                "created\n$date",
                style: const TextStyle(color: Colors.grey),
              )
            : const SizedBox(),
      ],
    );
  }
}
