import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoredo/models/todo.model.dart';

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

    useEffect(() {
      ref.listen(
        crudTodoProvider,
        (previous, next) async {
          // if init
          if (previous?.value == null) {
            await Future.delayed(Duration.zero, () {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            });
          }
          //if add todo scroll down until bottom
          if (previous?.hasValue ?? false) {
            if (next.value!.length > previous!.value!.length) {
              await Future.delayed(const Duration(milliseconds: 100), () {
                scrollController.animateTo(
                    scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut);
              });
            }
          }
        },
      );
      return;
    }, [todos]);

    String getDateFormat(Todo todo) {
      return todo.type == TodoType.schedule.name
          ? DateFormat('MM. dd').format(todo.completeDate!)
          : DateFormat('MM. dd').format(todo.createDate);
    }

    DateTime getDate(Todo todo) {
      return todo.type == TodoType.schedule.name
          ? todo.completeDate!
          : todo.createDate;
    }

    return ColoredBox(
      color: const Color(0xffeeeeee),
      child: todos.maybeWhen(
        data: (todoList) {
          return CustomScrollView(
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
                            if (isTodayAndNoTodo) DateView(now),
                            // if (todoList.length - 1 == index) const SizedBox(height: 40),
                          ],
                        );
                      },
                    ),
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
