import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/page/redo_list_page.dart';
import 'package:chattodo/providers/duedo_provider.dart';
import 'package:chattodo/style/calendar_style.dart';
import 'package:chattodo/widget/bottom_widget.state.dart';
import 'package:chattodo/widget/date_widget.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chattodo/providers/todo_provider.dart';
import 'package:chattodo/util/common.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:table_calendar/table_calendar.dart';

class BottomWidget extends HookConsumerWidget {
  const BottomWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(todoTextfieldControllerProvider);
    final commentTodo = ref.watch(commentTodoProvider);
    final selectedDate = ref.watch(selectedDateProvider);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        children: [
          CommentTodoWidget(controller: controller),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  addTodoNode.unfocus();
                  Navigator.of(context).push(
                    PageTransition(
                      child: const RedoListPage(),
                      type: PageTransitionType.leftToRight,
                      duration: Duration(milliseconds: 160),
                      reverseDuration: Duration(milliseconds: 160),
                      fullscreenDialog: true,
                      isIos: true,
                    ),
                  );
                },
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(Icons.list_alt_rounded),
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  if (selectedDate.selectedDate != null &&
                      selectedDate.datePickerOn == false) {
                    ref.read(selectedDateProvider.notifier).deleteDate();
                  } else {
                    selectedDate.datePickerOn
                        ? ref
                            .read(selectedDateProvider.notifier)
                            .setDatePickerOn(false)
                        : ref.read(selectedDateProvider.notifier).initDate();
                    addTodoNode.unfocus();
                  }
                },
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: selectedDate.selectedDate != null &&
                          selectedDate.datePickerOn == false
                      ? Icon(Icons.close)
                      : Icon(Icons.edit_calendar),
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: controller,
                  focusNode: addTodoNode,
                  onFieldSubmitted: (value) {
                    if (value == "") return;

                    ref.read(crudTodoProvider.notifier).addTodo(
                          chat: value,
                        );

                    //init state
                    controller.clear();
                    addTodoNode.requestFocus();
                    ref.read(commentTodoProvider.notifier).initTodo();
                  },
                  decoration: InputDecoration(
                    prefixIcon: selectedDate.selectedDate == null
                        ? null
                        : Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: DateView(
                              selectedDate.selectedDate!,
                              paddingOn: false,
                            ),
                          ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    fillColor: Theme.of(context).focusColor,
                    filled: true,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  //confirm
                  if (controller.text == "") return;

                  //work
                  if (commentTodo != null) {
                    ref
                        .read(crudTodoProvider.notifier)
                        .editTodoComment(commentTodo, controller.text);
                  } else if (selectedDate.selectedDate != null) {
                    ref.read(crudDuedoProvider.notifier).addDuedo(
                        title: controller.text,
                        dueDate: selectedDate.selectedDate!);
                  } else {
                    ref
                        .read(crudTodoProvider.notifier)
                        .addTodo(chat: controller.text);
                  }

                  //init state
                  controller.clear();
                  addTodoNode.unfocus();
                  ref.read(commentTodoProvider.notifier).initTodo();
                },
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).focusColor,
                  child: const Icon(Icons.send),
                ),
              ),
            ],
          ),
          DateSelectWidget(controller: controller),
        ],
      ),
    );
  }
}

class CommentTodoWidget extends HookConsumerWidget {
  const CommentTodoWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentTodo = ref.watch(commentTodoProvider);

    if (commentTodo == null) return SizedBox();
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      leading: Icon(Icons.arrow_circle_right_rounded),
      title: Text(commentTodo.title),
      trailing: Wrap(
        children: [
          IconButton(
            onPressed: () {
              ref
                  .read(crudTodoProvider.notifier)
                  .editTodoComment(commentTodo, null);
              ref.read(commentTodoProvider.notifier).initTodo();

              //init state
              controller.clear();
              addTodoNode.unfocus();
            },
            icon: Icon(Icons.comments_disabled),
          ),
          IconButton(
            onPressed: () {
              ref.read(commentTodoProvider.notifier).initTodo();

              //init state
              controller.clear();
              addTodoNode.unfocus();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}

class DateSelectWidget extends HookConsumerWidget {
  const DateSelectWidget({super.key, required this.controller});
  final TextEditingController controller;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);

    return AnimatedContainer(
      height: selectedDate.datePickerOn ? 332 : 0,
      duration: Duration(milliseconds: 160),
      child: selectedDate.datePickerOn
          ? SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: TableCalendar(
                sixWeekMonthsEnforced: true,
                rowHeight: 42,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextFormatter: (DateTime date, locale) {
                    return DateFormat('yyyy년 MM월 dd일').format(date);
                  },
                ),
                focusedDay: selectedDate.selectedDate ?? DateTime.now(),
                firstDay: DateTime.now().subtract(Duration(days: 365)),
                lastDay: DateTime.now().add(Duration(days: 365)),
                selectedDayPredicate: (day) =>
                    isSameDay(day, selectedDate.selectedDate),
                onDaySelected: (selectedDay, _) {
                  DateTime date = DateTime(
                      selectedDay.year, selectedDay.month, selectedDay.day);
                  ref.read(selectedDateProvider.notifier).setDate(date);
                  addTodoNode.requestFocus();
                },
                onPageChanged: (focusedDay) {},
                calendarFormat: CalendarFormat.month,
                availableCalendarFormats: const {CalendarFormat.month: 'Month'},
                calendarStyle: getCalendarStyle(ref.watch(mainColorProvider)),
              ),
            )
          : SizedBox(),
    );
  }
}
