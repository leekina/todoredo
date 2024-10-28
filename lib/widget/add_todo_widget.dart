import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoredo/providers/todo_provider.dart';
import 'package:todoredo/util/common.dart';

class AddTodoWidget extends HookConsumerWidget {
  const AddTodoWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextFormField(
        controller: controller,
        focusNode: addTodoNode,
        onFieldSubmitted: (value) {
          ref.read(crudTodoProvider.notifier).addTodo(
                chat: value,
              );
          controller.clear();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              ref
                  .read(crudTodoProvider.notifier)
                  .addTodo(chat: controller.text);
              controller.clear();
            },
            child: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}
