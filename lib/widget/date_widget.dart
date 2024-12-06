import 'package:chattodo/page/calendar_page.dart';
import 'package:chattodo/providers/duedo_provider.dart';
import 'package:chattodo/util/common.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/util/weekday_convertor.dart';

class DateWidget extends HookConsumerWidget {
  const DateWidget(this.todoDate, {super.key});

  final DateTime todoDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = getDateToStringFormat(todoDate);
    final today = getDateToStringFormat(DateTime.now());
    final isToday = date == today;

    return isToday ? TodayDateWidget(todoDate: todoDate) : DateView(todoDate);
  }
}

class TodayDateWidget extends HookConsumerWidget {
  const TodayDateWidget({
    super.key,
    required this.todoDate,
  });

  final DateTime todoDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColor = ref.watch(mainColorProvider);
    final todayTextstyle =
        Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white);

    return ListTile(
      horizontalTitleGap: 0,
      contentPadding: EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: mainColor.withOpacity(0.8),
      minTileHeight: 48,
      leading: DateView(todoDate, colorOn: true),
      title: Consumer(
        builder: (context, ref, child) {
          final currentDateDuedo = ref.watch(getCurrentDateDuedoProvider);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: currentDateDuedo.maybeWhen(
              data: (duedo) => duedo == null
                  ? Text('예정된 일정이 없습니다.', style: todayTextstyle)
                  : Text(
                      '${duedo.title} ~ ${getDateToStringFormat(duedo.dueDate)}',
                      style: todayTextstyle,
                    ),
              orElse: () => const Text(''),
            ),
          );
        },
      ),
      trailing: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const CalendarPage(),
            ),
          );
        },
        child: Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

class DateView extends HookConsumerWidget {
  final DateTime date;
  final bool colorOn;
  final bool paddingOn;
  const DateView(this.date,
      {super.key, this.colorOn = false, this.paddingOn = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateString = DateFormat('MM. dd').format(date);
    final maincolor = ref.watch(mainColorProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: paddingOn
            ? const EdgeInsets.symmetric(horizontal: 12, vertical: 8)
            : EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: colorOn == true ? maincolor : Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$dateString ${weekdayConvertor(date.weekday)}',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
