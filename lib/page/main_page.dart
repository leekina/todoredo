import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoredo/main.dart';
import 'package:todoredo/models/todo.model.dart';

import 'package:todoredo/providers/todo_providers.dart';
import 'package:todoredo/util/weekday_convertor.dart';
import 'package:todoredo/widget/schedule_list.dart';
import 'package:todoredo/widget/todo_widget.dart';

FocusNode textFocus = FocusNode();

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(crudTodoProvider);
    final controller = useTextEditingController();
    final scrollController = useScrollController();

    ref.listen(
      crudTodoProvider,
      (previous, next) {
        //if add todo scroll down until bottom

        if (!previous!.isLoading) {
          if (next.value!.length > previous.value!.length) {
            Future.delayed(
              const Duration(milliseconds: 10),
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

    return GestureDetector(
      onTap: () => textFocus.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffeeeeee),
        appBar: AppBar(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: const Text('logo'),
          centerTitle: false,
          actions: const [],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: todos.maybeWhen(
                  data: (todoList) {
                    todoList.sort(
                      (a, b) {
                        return a.date.compareTo(b.date);
                      },
                    );
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: todoList.length,
                      itemBuilder: (context, index) {
                        final todo = todoList[index];
                        final date = DateFormat('MM. dd').format(todo.date);
                        final today =
                            DateFormat('MM. dd').format(DateTime.now());
                        final isTodayAndNoTodo =
                            (todoList.length - 1 == index && date != today);

                        return Column(
                          children: [
                            if (index == 0)
                              DateView(todo.date)
                            else if (date !=
                                DateFormat('MM. dd')
                                    .format(todoList[index - 1].date))
                              DateView(todo.date),
                            TodoWidget(todo: todo),
                            if (isTodayAndNoTodo) DateView(DateTime.now())
                          ],
                        );
                      },
                    );
                  },
                  orElse: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              BottomWidget(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

class DateView extends HookConsumerWidget {
  final DateTime todoDate;
  const DateView(this.todoDate, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateFormat('MM. dd').format(todoDate);
    final today = DateFormat('MM. dd').format(DateTime.now());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: date == today
                  ? Colors.lightGreenAccent.withOpacity(0.7)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('$date ${weekdayConvertor(todoDate.weekday)}'),
          ),
        ),
        if (today == date) const ScheduleList(),
      ],
    );
  }
}
