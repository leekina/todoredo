import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/util/common.dart';

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
    final time = DateFormat('hh:mm').format(todo.createDate);
    return Row(
      mainAxisAlignment:
          isSchedule ? MainAxisAlignment.start : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        isSchedule
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  time,
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.all(12),
          constraints:
              BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
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
            ? Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Text(
                  "created\n$date",
                  style: const TextStyle(color: Colors.grey),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
