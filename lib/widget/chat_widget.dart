import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/page/main_page.dart';
import 'package:todoredo/providers/providers.dart';
import 'package:todoredo/widget/edit_chat_dialog.dart';

class ChatWidget extends HookConsumerWidget {
  final Todo todo;

  const ChatWidget({
    super.key,
    required this.todo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Stack(
        children: [
          if (todo.complete) ChatView(todo: todo),
          Dismissible(
            key: ValueKey(todo.id),
            onDismissed: (direction) {
              //완료면 복사
              if (todo.date.isBefore(DateTime.now())) {
                if (direction == DismissDirection.endToStart) {
                  ref.read(chatProvider.notifier).addchat(
                        chat: todo.title,
                        re: true,
                        date: DateTime.now().add(const Duration(days: 1)),
                      );
                  if (!todo.complete) {
                    ref.read(chatProvider.notifier).deleteChat(todo.id);
                  }
                } else {
                  ref.read(chatProvider.notifier).deleteChat(todo.id);
                }

                //아니아니면 미루기
              }
            },
            child: GestureDetector(
              onLongPress: () {
                if (!todo.complete) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return EditChatDialog(todo);
                    },
                  );
                }
              },
              onTap: () {
                //오늘이전꺼만 컴플리트 가능
                if (todo.date.isBefore(DateTime.now())) {
                  ref.read(chatProvider.notifier).completeChat(todo.id);
                }

                //언포커스
                textFocus.unfocus();
              },
              child: ChatView(todo: todo),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatView extends HookConsumerWidget {
  final Todo todo;
  const ChatView({
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
