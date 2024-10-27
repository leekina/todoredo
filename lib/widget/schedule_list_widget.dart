import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoredo/models/todo.model.dart';
import 'package:todoredo/providers/todo_providers.dart';
import 'package:todoredo/util/common.dart';
import 'package:todoredo/widget/edit_chat_dialog.dart';
import 'package:todoredo/widget/todo_widget.dart';

//TODO : 이 파일 확인 필요 임시 작성임
class ScheduleListWidget extends HookConsumerWidget {
  const ScheduleListWidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleListNotCompleted = ref.watch(getScheduleNotCompletedProvider);
    return scheduleListNotCompleted.maybeWhen(
      data: (scheduleList) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: scheduleList.length,
          itemBuilder: (context, index) {
            final schedule = scheduleList[index];

            return ScheduleWidget(schedule: schedule);
          },
        );
      },
      orElse: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

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
            ref.read(crudTodoProvider.notifier).addTodo(chat: schedule.title);
          }
          ref.read(crudTodoProvider.notifier).deleteTodo(schedule.id);
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
            //오늘이전꺼만 컴플리트 가능
            if (schedule.createDate.isBefore(DateTime.now())) {
              ref
                  .read(crudTodoProvider.notifier)
                  .toogleTodoComplete(schedule.id);
            }

            //언포커스
            addTodoNode.unfocus();
          },
          child: TodoWidget(
            todo: schedule,
          ),
        ),
      ),
    );
  }
}
