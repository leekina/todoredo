import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/page/canendar_page.state.dart';
import 'package:chattodo/page/schedule_view.dart';
import 'package:chattodo/providers/duedo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends HookConsumerWidget {
  const CalendarPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final calendarFormat = useState(CalendarFormat.month);
    final mainColor = ref.watch(mainColorProvider);
    final currentDate = ref.watch(currentDateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
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
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              availableGestures: AvailableGestures.horizontalSwipe,
              sixWeekMonthsEnforced: true,
              selectedDayPredicate: (day) => isSameDay(day, currentDate),
              onDaySelected: (selectedDay, _) {
                ref
                    .read(currentDateProvider.notifier)
                    .updateCurrentDate(selectedDay);
              },
              onPageChanged: (focusedDay) {
                ref
                    .read(currentDateProvider.notifier)
                    .updateCurrentDate(focusedDay);
              },
              calendarStyle: CalendarStyle(
                cellAlignment: Alignment.topCenter,
                todayTextStyle: TextStyle(color: mainColor),
                todayDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: mainColor),
                ),
                selectedDecoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: mainColor,
                ),
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
              focusedDay: currentDate,
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) => _Marker(day),
              ),
            ),
            //TODO : 리스트 정렬 및 날짜, 주차별 정리 위젯 설정 or syncfusion_schadule 추가
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
    final events = ref.watch(crudDuedoProvider(date: date));
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: events.maybeWhen(
        data: (events) => Wrap(
          children: events
              .map((e) => Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red,
                    ),
                  ))
              .toList(),
        ),
        orElse: () => const SizedBox(),
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
                  .read(crudDuedoProvider(date: selectedDate.value).notifier)
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
