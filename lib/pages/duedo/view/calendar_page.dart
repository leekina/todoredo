import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/model/models/duedo.model.dart';
import 'package:chattodo/pages/duedo/state/canendar_page.state.dart';
import 'package:chattodo/pages/duedo/view/schedule_view.dart';
import 'package:chattodo/providers/duedo/duedo_provider.dart';
import 'package:chattodo/style/calendar_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColor = ref.watch(mainColorProvider);
    final currentDate = ref.watch(currentDateProvider);
    final calendarFormat = ref.watch(currentCalendarFormatProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: GestureDetector(
          onTap: () {
            ref
                .read(currentDateProvider.notifier)
                .updateCurrentDate(DateTime.now());
          },
          child: Text(
            DateFormat('yyyy년 MM월').format(currentDate),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const AddTodoDialog(),
              );
            },
          ),
          IconButton(
            onPressed: () {
              ref
                  .read(currentCalendarFormatProvider.notifier)
                  .updateCalendarFormat(
                    calendarFormat == CalendarFormat.week
                        ? CalendarFormat.month
                        : CalendarFormat.week,
                  );
            },
            icon: Icon(
              calendarFormat == CalendarFormat.week
                  ? Icons.arrow_downward
                  : Icons.arrow_upward,
            ),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              headerVisible: false,
              availableGestures: AvailableGestures.horizontalSwipe,
              // sixWeekMonthsEnforced: true,
              daysOfWeekHeight: 18,
              rowHeight: 80,

              selectedDayPredicate: (day) => isSameDay(day, currentDate),
              onDaySelected: (selectedDay, _) {
                DateTime date = DateTime(
                    selectedDay.year, selectedDay.month, selectedDay.day);

                ref.read(currentDateProvider.notifier).updateCurrentDate(date);
              },
              onPageChanged: (focusedDay) {
                DateTime date =
                    DateTime(focusedDay.year, focusedDay.month, focusedDay.day);
                ref.read(currentDateProvider.notifier).updateCurrentDate(date);
              },
              calendarStyle: getCalendarStyle(mainColor),
              locale: 'ko_KR',
              calendarFormat: calendarFormat,

              focusedDay: currentDate,
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              calendarBuilders:
                  CalendarBuilders(markerBuilder: (context, day, events) {
                DateTime date = DateTime(day.year, day.month, day.day);
                return _Marker(date);
              }),
            ),
            Divider(color: ref.watch(mainColorProvider)),
            Expanded(
              child: ScheduleView(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Marker extends ConsumerWidget {
  final DateTime date;
  const _Marker(this.date);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(getDuedoWithDateProvider(date: date));
    final maincolor = ref.watch(mainColorProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 22, 0, 4),
      child: events.maybeWhen(
        data: (events) {
          if (events.length < 4) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: events
                  .map(
                    (e) => dayCellText(maincolor, e, context),
                  )
                  .toList(),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                dayCellText(maincolor, events[0], context),
                dayCellText(maincolor, events[1], context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '+ ${events.length - 2}개',
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall!
                        .copyWith(color: Colors.grey.shade600),
                  ),
                ),
              ],
            );
          }
        },
        orElse: () => const SizedBox(),
      ),
    );
  }

  Container dayCellText(Color maincolor, Duedo e, BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(4, 0, 4, 2),
      padding: EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: maincolor.withOpacity(0.7),
      ),
      child: Text(
        e.title,
        style: Theme.of(context).textTheme.bodySmall,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.fade,
      ),
    );
  }
}

class AddTodoDialog extends HookConsumerWidget {
  const AddTodoDialog({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleController = useTextEditingController();
    final selectedDate = useState(ref.read(currentDateProvider));
    return AlertDialog(
      title: const Text('할 일 추가'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: '할 일',
              hintText: '할 일을 입력하세요',
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate.value,
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now().add(const Duration(days: 365)),
              );
              if (picked != null) {
                selectedDate.value = picked;
              }
            },
            child: Text(DateFormat('yyyy-MM-dd').format(selectedDate.value)),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            if (titleController.text.isNotEmpty) {
              ref
                  .read(getDuedoWithDateProvider(date: selectedDate.value)
                      .notifier)
                  .addDuedo(
                    title: titleController.text,
                    dueDate: selectedDate.value,
                  );
              Navigator.pop(context);
            }
          },
          child: const Text('추가'),
        ),
      ],
    );
  }
}
