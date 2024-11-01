import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoredo/providers/todo_provider.dart';
import 'package:todoredo/util/common.dart';
import 'package:todoredo/widget/date_widget.dart';
import 'package:todoredo/widget/todo_widget.dart';

class ChatView extends HookConsumerWidget {
  const ChatView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(crudTodoProvider);
    final scrollController = useScrollController();

    ref.listen(
      crudTodoProvider,
      (previous, next) {
        //if add todo scroll down until bottom
        if (!previous!.isLoading) {
          if (next.value!.length > previous.value!.length) {
            Future.delayed(
              Duration.zero,
              () {
                scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut);
              },
            );
          }
        }
      },
    );

    return ColoredBox(
      color: const Color(0xffeeeeee),
      child: todos.maybeWhen(
        data: (todoList) {
          return ListView.builder(
            controller: scrollController,
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              final todo = todoList[index];
              final date = DateFormat('MM. dd').format(todo.createDate);
              final isTodayAndNoTodo =
                  (todoList.length - 1 == index && date != today);

              return Column(
                children: [
                  if (index == 0)
                    DateView(todo.createDate)
                  else if (date !=
                      DateFormat('MM. dd')
                          .format(todoList[index - 1].createDate))
                    DateView(todo.createDate),
                  TodoWidget(todo: todo),
                  if (isTodayAndNoTodo) DateView(now)
                ],
              );
            },
          );
        },
        orElse: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
