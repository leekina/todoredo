import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/page/main_page.dart';
import 'package:todoredo/providers/providers.dart';

class ChatWidget extends HookConsumerWidget {
  final Todo todo;

  const ChatWidget({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = DateFormat('hh:mm').format(todo.date);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Dismissible(
        key: ValueKey(todo.id),
        onDismissed: (direction) {
          //반복이라면 내일 추가
          if (todo.redo) {
            ref.read(chatProvider.notifier).addchat(
                  chat: todo.title,
                  re: true,
                  date: DateTime.now().add(const Duration(days: 1)),
                );
          }
          ref.read(chatProvider.notifier).deleteChat(todo.id);
        },
        child: InkWell(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) {
                return EditChatDialog(todo);
              },
            );
          },
          onTap: () {
            //오늘이전꺼만 컴플리트 가능
            if (todo.date.isBefore(DateTime.now())) {
              ref.read(chatProvider.notifier).completeChat(todo.id);
            }

            //언포커스
            textFocus.unfocus();
          },
          child: Row(
            mainAxisAlignment:
                todo.redo ? MainAxisAlignment.start : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (!todo.redo)
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey),
                ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: todo.complete
                        ? Colors.green.withOpacity(0.8)
                        : Colors.white),
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
              if (todo.redo)
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditChatDialog extends HookConsumerWidget {
  final Todo todo;
  const EditChatDialog(this.todo, {super.key});
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
              ref.read(chatProvider.notifier).deleteChat(todo.id);
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
                  .read(chatProvider.notifier)
                  .editChat(todo.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('확인')),
      ],
    );
  }
}
