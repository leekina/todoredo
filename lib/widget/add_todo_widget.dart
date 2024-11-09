import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/providers/todo_provider.dart';
import 'package:chattodo/util/common.dart';

class AddTodoWidget extends HookConsumerWidget {
  const AddTodoWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColor = ref.watch(mainColorProvider);
    return Container(
      decoration: BoxDecoration(
        color: mainColor.withOpacity(0.3),
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              focusNode: addTodoNode,
              onFieldSubmitted: (value) {
                ref.read(crudTodoProvider.notifier).addTodo(
                      chat: value,
                    );
                controller.clear();
                addTodoNode.requestFocus();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                fillColor: Theme.of(context).canvasColor,
                filled: true,
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              ref
                  .read(crudTodoProvider.notifier)
                  .addTodo(chat: controller.text);
              controller.clear();
              addTodoNode.unfocus();
            },
            child: CircleAvatar(
              backgroundColor: Theme.of(context).cardColor,
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
