import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:todoredo/models/schedule.model.dart';
import 'package:todoredo/page/main_page.dart';
import 'package:todoredo/providers/schedule_providers.dart';
import 'package:todoredo/providers/todo_providers.dart';

class ScheduleList extends HookConsumerWidget {
  const ScheduleList({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(crudScheduleProvider);
    return schedules.maybeWhen(
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
  final Schedule schedule;
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
          ref.read(crudScheduleProvider.notifier).deleteSchedule(schedule.id);
        },
        child: GestureDetector(
          //길게 누르면 수정
          onLongPress: () {
            if (!schedule.complete) {
              showDialog(
                context: context,
                builder: (context) {
                  return EditScheduleDialog(schedule);
                },
              );
            }
          },
          onTap: () {
            //오늘이전꺼만 컴플리트 가능
            if (schedule.date.isBefore(DateTime.now())) {
              ref
                  .read(crudScheduleProvider.notifier)
                  .completeSchedule(schedule.id);
            }

            //언포커스
            textFocus.unfocus();
          },
          child: ScheduleView(
            schedule: schedule,
          ),
        ),
      ),
    );
  }
}

class ScheduleView extends HookConsumerWidget {
  final Schedule schedule;
  const ScheduleView({
    super.key,
    required this.schedule,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final time = DateFormat('hh:mm').format(schedule.date);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: schedule.complete
                  ? Colors.green.withOpacity(0.8)
                  : Colors.white),
          child: Text(
            schedule.title,
            style: TextStyle(
              color: schedule.date.isBefore(DateTime.now())
                  ? schedule.complete
                      ? Colors.white
                      : Colors.black
                  : Colors.grey,
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          time,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

class EditScheduleDialog extends HookConsumerWidget {
  final Schedule schedule;
  const EditScheduleDialog(this.schedule, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: schedule.title);
    return AlertDialog(
      title: const Text('Edit Todo'),
      content: TextField(
        controller: controller,
        autofocus: true,
      ),
      actions: [
        TextButton(
            onPressed: () {
              ref
                  .read(crudScheduleProvider.notifier)
                  .deleteSchedule(schedule.id);
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
                  .read(crudScheduleProvider.notifier)
                  .editSchedule(schedule.id, controller.text);
              Navigator.pop(context);
            },
            child: const Text('확인')),
      ],
    );
  }
}
