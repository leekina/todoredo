import 'package:chattodo/app/state/app.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chattodo/providers/todo_provider.dart';
import 'package:chattodo/util/common.dart';

class BottomWidget extends HookConsumerWidget {
  const BottomWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: controller,
              focusNode: addTodoNode,
              onFieldSubmitted: (value) {
                if (value == "") return;

                ref.read(crudTodoProvider.notifier).addTodo(
                      chat: value,
                    );
                controller.clear();
                addTodoNode.requestFocus();
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                fillColor: Theme.of(context).focusColor,
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
              if (controller.text == "") return;
              ref
                  .read(crudTodoProvider.notifier)
                  .addTodo(chat: controller.text);
              controller.clear();
              addTodoNode.unfocus();
            },
            child: CircleAvatar(
              backgroundColor: Theme.of(context).focusColor,
              child: const Icon(Icons.send),
            ),
          ),
        ],
      ),
    );
  }
}
