import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoredo/providers/schedule_provider.dart';
import 'package:todoredo/widget/schedule_widget.dart';

class ScheduleList extends HookConsumerWidget {
  const ScheduleList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduleListNotCompleted = ref.watch(crudScheduleProvider);
    return scheduleListNotCompleted.maybeWhen(
      data: (scheduleList) {
        scheduleList.sort(
          (a, b) {
            return a.createDate.compareTo(b.createDate);
          },
        );
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
