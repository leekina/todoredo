import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
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
                  ? Theme.of(context).secondaryHeaderColor
                  : Theme.of(context).focusColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$date ${weekdayConvertor(todoDate.weekday)}',
              style: date == today
                  ? Theme.of(context).textTheme.titleSmall
                  : Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
      ],
    );
  }
}
