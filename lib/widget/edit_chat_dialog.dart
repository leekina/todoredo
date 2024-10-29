import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/providers/schedule_provider.dart';
import 'package:todoredo/providers/todo_provider.dart';
import 'package:todoredo/util/common.dart';

class EditTodoDialog extends HookConsumerWidget {
  final Todo todo;
  const EditTodoDialog(this.todo, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: todo.title);
    return AlertDialog(
      title: const Text('Edit Todo'),
      content: TextField(
        controller: controller,
        autofocus: true,
      ),
      actions: [
        TextButton(
            onPressed: () {
              todo.type == TodoType.schedule.name
                  ? ref
                      .read(crudScheduleProvider.notifier)
                      .deleteSchedule(todo.id)
                  : ref.read(crudTodoProvider.notifier).deleteTodo(todo.id);
              Navigator.pop(context);
            },
            child: const Text('삭제')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('취소')),
        TextButton(
            onPressed: () {
              ref
                  .read(crudTodoProvider.notifier)
                  .editTodoTitle(todo.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('확인')),
      ],
    );
  }
}
