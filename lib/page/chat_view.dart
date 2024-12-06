import 'package:chattodo/page/chat_view.state.dart';
import 'package:chattodo/util/common.dart';
import 'package:chattodo/widget/todo_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: todos.maybeWhen(
        data: (todoList) {
          return CustomScrollView(
            reverse: true,
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: List.generate(
                    todoList.length,
                    (index) {
                      final todo = todoList[index];
                      final dateforamt = getDateToStringFormat(todo.createDate);
                      final isTodayAndNoTodo =
                          (todoList.length - 1 == index && dateforamt != today);

                      //그날 처음에 DateWidget추가
                      return Column(
                        children: [
                          if (index == 0)
                            DateWidget(todo.createDate)
                          else if (dateforamt !=
                              getDateToStringFormat(
                                  todoList[index - 1].createDate))
                            DateWidget(todo.createDate),
                          TodoWidget(todo: todo),
                          if (isTodayAndNoTodo) DateWidget(DateTime.now()),
                        ],
                      );
                    },
                  ),
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
