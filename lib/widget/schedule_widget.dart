import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/providers/schedule_provider.dart';
import 'package:todoredo/providers/todo_provider.dart';
import 'package:todoredo/util/common.dart';
import 'package:todoredo/widget/edit_chat_dialog.dart';
import 'package:todoredo/widget/todo_view.dart';

class ScheduleWidget extends HookConsumerWidget {
  final Todo schedule;
  const ScheduleWidget({
    super.key,
    required this.schedule,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Dismissible(
        key: ValueKey(schedule.id),
        onDismissed: (direction) {
          //디스미스
          if (direction == DismissDirection.startToEnd) {
            ref
                .read(crudTodoProvider.notifier)
                .addTodo(chat: schedule.title, date: schedule.createDate);
          }
          ref.read(crudScheduleProvider.notifier).deleteSchedule(schedule.id);
        },
        child: GestureDetector(
          //길게 누르면 수정
          onLongPress: () {
            if (!schedule.complete) {
              showDialog(
                context: context,
                builder: (context) {
                  return EditTodoDialog(schedule);
                },
              );
            }
          },
          onTap: () {
            //완료
            //투두에 추가하고 스케쥴에서는 제거
            ref.read(crudTodoProvider.notifier).addTodoFromSchedule(schedule);
            ref.read(crudScheduleProvider.notifier).deleteSchedule(schedule.id);

            //언포커스
            addTodoNode.unfocus();
          },
          child: TodoView(
            todo: schedule,
          ),
        ),
      ),
    );
  }
}
