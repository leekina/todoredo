import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/page/canendar_page.state.dart';
import 'package:chattodo/providers/duedo_provider.dart';
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
    final currentDate = ref.watch(currentDateProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddTodoDialog(context, ref);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            TableCalendar(
              selectedDayPredicate: (day) => isSameDay(day, currentDate),
              onDaySelected: (selectedDay, focusedDay) {
                ref
                    .read(currentDateProvider.notifier)
                    .updateCurrentDate(focusedDay);
              },
              calendarStyle: CalendarStyle(
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
              focusedDay: DateTime.now(),
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
            ),
            Expanded(
              child: Consumer(
                builder: (context, ref, child) {
                  final duedos = ref.watch(crudDuedoProvider);
                  return duedos.when(
                    data: (duedoList) => ListView.builder(
                      itemCount: duedoList.length,
                      itemBuilder: (context, index) {
                        final duedo = duedoList[index];
                        return ListTile(
                          key: ref
                              .read(duedoListKeysProvider.notifier)
                              .getKey(index),
                          title: Text(duedo.title),
                          subtitle: Text(duedo.dueDate.toString()),
                        );
                      },
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, stack) =>
                        Center(child: Text('에러 발생: $error')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddTodoDialog(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    DateTime? selectedDate;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  selectedDate = picked;
                }
              },
              child: const Text('마감일 선택'),
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
                ref.read(crudDuedoProvider.notifier).addDuedo(
                      title: titleController.text,
                      dueDate: selectedDate ?? DateTime.now(),
                    );
                Navigator.pop(context);
              }
            },
            child: const Text('추가'),
          ),
        ],
      ),
    );
  }
}
