import 'package:chattodo/page/calendar_page.dart';
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
    final date = DateFormat('MM. dd').format(todoDate);
    final today = DateFormat('MM. dd').format(DateTime.now());
    final mainColor = ref.watch(mainColorProvider);
    final isToday = date == today;
    final todayTextstyle =
        Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.white);
    final todayTextstylesub =
        Theme.of(context).textTheme.bodySmall!.copyWith(color: Colors.white);

    return isToday
        ? ListTile(
            horizontalTitleGap: 0,
            contentPadding: EdgeInsets.symmetric(horizontal: 4),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            tileColor: mainColor,
            minTileHeight: 48,
            leading: DateView(todoDate),
            title: Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '듀두 개발 마무리하기 ~ 11.30',
                    style: todayTextstyle,
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const CalendarPage(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Text('W : 3', style: todayTextstylesub),
                      Text('M : 10', style: todayTextstylesub),
                    ],
                  ),
                ),
              ],
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
          )
        : DateView(todoDate);
  }
}

class DateView extends HookConsumerWidget {
  final DateTime date;
  final bool isToday;
  const DateView(this.date, {super.key, this.isToday = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateString = DateFormat('MM. dd').format(date);
    final maincolor = ref.watch(mainColorProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isToday == true ? maincolor : Theme.of(context).focusColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          '$dateString ${weekdayConvertor(date.weekday)}',
          style: Theme.of(context).textTheme.bodyMedium!,
        ),
      ),
    );
  }
}
