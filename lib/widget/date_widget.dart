import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todoredo/page/schedule_list.dart';
import 'package:todoredo/util/common.dart';
import 'package:todoredo/util/weekday_convertor.dart';

class DateView extends HookConsumerWidget {
  const DateView(this.todoDate, {super.key});

  final DateTime todoDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateFormat('MM. dd').format(todoDate);
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
