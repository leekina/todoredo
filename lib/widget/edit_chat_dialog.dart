import 'package:chattodo/app/state/app.state.dart';
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
    final mainColor = ref.watch(mainColorProvider);
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: const Text('수정하기'),
      content: TextField(
        minLines: 1,
        maxLines: 4,
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          fillColor: Theme.of(context).focusColor,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            '취소',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            ref
                .read(crudTodoProvider.notifier)
                .editTodoTitle(todo, controller.text);
            Navigator.pop(context);
          },
          child: Text(
            '확인',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: mainColor),
          ),
        ),
      ],
    );
  }
}
