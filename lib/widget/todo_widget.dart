import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/page/main_page.dart';
import 'package:todoredo/providers/schedule_providers.dart';
import 'package:todoredo/providers/todo_providers.dart';
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
        onDismissed: (direction) {
          //디스미스
          if (direction == DismissDirection.endToStart) {
            ref
                .read(crudScheduleProvider.notifier)
                .addSchedule(chat: todo.title, re: false);
            //스케쥴로 전환
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
            //오늘이전꺼만 컴플리트 가능
            if (todo.date.isBefore(DateTime.now())) {
              ref.read(crudTodoProvider.notifier).completeTodo(todo.id);
            }

            //언포커스
            textFocus.unfocus();
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
    final time = DateFormat('hh:mm').format(todo.date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          time,
          style: const TextStyle(color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:
                  todo.complete ? Colors.green.withOpacity(0.8) : Colors.white),
          child: Text(
            todo.title,
            style: TextStyle(
              color: todo.date.isBefore(DateTime.now())
                  ? todo.complete
                      ? Colors.white
                      : Colors.black
                  : Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
