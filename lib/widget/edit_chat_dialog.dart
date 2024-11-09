import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chattodo/models/todo.model.dart';
import 'package:chattodo/providers/todo_provider.dart';

class EditTodoDialog extends HookConsumerWidget {
  const EditTodoDialog(this.todo, {super.key});

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: todo.title);
    return AlertDialog(
      title: const Text('수정하기'),
      content: TextField(
        controller: controller,
        autofocus: true,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('취소')),
        TextButton(
          onPressed: () {
            ref
                .read(crudTodoProvider.notifier)
                .editTodoTitle(todo, controller.text);
            Navigator.pop(context);
          },
          child: const Text('확인'),
        ),
      ],
    );
  }
}
