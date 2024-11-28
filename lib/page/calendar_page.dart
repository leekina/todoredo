import 'package:chattodo/app/state/app.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarFormat = useState(CalendarFormat.month);
    final mainColor = ref.watch(mainColorProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              calendarStyle: CalendarStyle(
                todayDecoration:
                    BoxDecoration(shape: BoxShape.circle, color: mainColor),
              ),
              headerStyle: HeaderStyle(
                leftChevronVisible: false,
                rightChevronVisible: false,
                headerPadding: EdgeInsets.symmetric(horizontal: 16),
                formatButtonPadding: EdgeInsets.all(8),
                formatButtonDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).focusColor,
                ),
                formatButtonTextStyle: Theme.of(context).textTheme.bodyMedium!,
              ),
              locale: 'ko_KR',
              calendarFormat: calendarFormat.value,
              onFormatChanged: (format) {
                calendarFormat.value = format;
              },
              focusedDay: DateTime.now(),
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
            ),
          ],
        ),
      ),
    );
  }
}
