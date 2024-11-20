import 'package:chattodo/page/chat_view.state.dart';
import 'package:chattodo/widget/todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chattodo/models/todo.model.dart';

import 'package:chattodo/providers/todo_provider.dart';
import 'package:chattodo/widget/date_widget.dart';

class ChatView extends HookConsumerWidget {
  const ChatView({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(crudTodoProvider);
    final scrollController = ref.watch(myScrollControllerProvider);
    final today = DateFormat('MM. dd').format(DateTime.now());

    String getDateFormat(Todo todo) {
      return DateFormat('MM. dd').format(todo.createDate);
    }

    DateTime getDate(Todo todo) {
      return todo.createDate;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: todos.maybeWhen(
        data: (todoList) {
          return CustomScrollView(
            reverse: true,
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ...List.generate(
                      todoList.length,
                      (index) {
                        final todo = todoList[index];
                        final date = getDate(todo);
                        final dateforamt = getDateFormat(todo);
                        final isTodayAndNoTodo =
                            (todoList.length - 1 == index &&
                                dateforamt != today);
                        return Column(
                          children: [
                            if (index == 0)
                              DateView(date)
                            else if (dateforamt !=
                                getDateFormat(todoList[index - 1]))
                              DateView(date),
                            TodoWidget(todo: todo),
                            if (isTodayAndNoTodo) DateView(DateTime.now()),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          );
        },
        orElse: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
