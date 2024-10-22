import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoredo/main.dart';
import 'package:todoredo/models/todo.model.dart';

import 'package:todoredo/providers/providers.dart';
import 'package:todoredo/util/weekday_convertor.dart';
import 'package:todoredo/widget/chat_widget.dart';

FocusNode textFocus = FocusNode();

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chat = ref.watch(chatProvider);
    final controller = useTextEditingController();
    final scrollController = useScrollController();

    ref.listen(
      chatProvider,
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
                child: chat.maybeWhen(
                  data: (data) {
                    data.sort(
                      (a, b) {
                        return a.date.compareTo(b.date);
                      },
                    );
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final todo = data[index];
                        final date = DateFormat('MM. dd').format(todo.date);
                        final today =
                            DateFormat('MM. dd').format(DateTime.now());

                        return Column(
                          children: [
                            if (index == 0)
                              DateView(todo)
                            else if (date !=
                                DateFormat('MM. dd')
                                    .format(data[index - 1].date))
                              DateView(todo),
                            if (date == today &&
                                date !=
                                    DateFormat('MM. dd')
                                        .format(data[index - 1].date))
                              const ScheduleWidget(),
                            ChatWidget(todo: todo),
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
  final Todo todo;
  const DateView(this.todo, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateFormat('MM. dd').format(todo.date);
    final today = DateFormat('MM. dd').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: date == today
              ? Colors.lightGreenAccent.withOpacity(0.7)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text('$date ${weekdayConvertor(todo.date.weekday)}'),
      ),
    );
  }
}

class ScheduleWidget extends HookConsumerWidget {
  const ScheduleWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Text('Schedule');
  }
}
