import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/models/duedo.model.dart';
import 'package:chattodo/page/canendar_page.state.dart';
import 'package:chattodo/providers/duedo_provider.dart';

import 'package:chattodo/widget/date_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class ScheduleView extends HookConsumerWidget {
  const ScheduleView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = ref.watch(currentDateProvider);
    final duedos = ref.watch(getDuedoWithDateProvider(date: currentDate));

    return duedos.when(
      data: (duedoList) => ListView.builder(
        itemCount: duedoList.length,
        itemBuilder: (context, index) {
          final duedo = duedoList[index];
          return ScheduleItem(duedo: duedo, index: index);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('에러 발생: $error')),
    );
  }
}

class ScheduleItem extends HookConsumerWidget {
  final int index;
  final Duedo duedo;
  const ScheduleItem({super.key, required this.duedo, required this.index});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateString = DateFormat('MM. dd').format(duedo.createDate);
    final mainColor = ref.watch(mainColorProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minTileHeight: 48,
        tileColor: Theme.of(context).focusColor,
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => EditDuedoDialog.edit(duedo),
          );
        },
        leading: DateView(duedo.dueDate, colorOn: duedo.complete),
        title: Text(duedo.title),
        subtitle: Text('$dateString 등록'),
        trailing: IconButton.filled(
          style: IconButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: duedo.complete
                ? mainColor
                : Theme.of(context).scaffoldBackgroundColor,
          ),
          padding: EdgeInsets.all(8),
          onPressed: () {
            ref
                .read(getDuedoWithDateProvider(date: duedo.dueDate).notifier)
                .toggleDuedoComplete(duedo);
          },
          icon: Icon(
            Icons.check,
            color: duedo.complete
                ? Theme.of(context).scaffoldBackgroundColor
                : Theme.of(context).focusColor,
          ),
        ),
      ),
    );
  }
}

class EditDuedoDialog extends HookConsumerWidget {
  const EditDuedoDialog({
    this.duedo,
    super.key,
  });

  final Duedo? duedo;

  factory EditDuedoDialog.edit(Duedo duedo) => EditDuedoDialog(duedo: duedo);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(text: duedo!.title);
    final mainColor = ref.watch(mainColorProvider);
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text('수정하기'),
      content: TextField(
        minLines: 1,
        maxLines: 4,
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          fillColor: Theme.of(context).focusColor,
          filled: true,
          border: const OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref
                .read(getDuedoWithDateProvider(date: duedo!.dueDate).notifier)
                .deleteDuedo(duedo!);
            Navigator.pop(context);
          },
          child: Text(
            '삭제',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            '취소',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: () {
            ref
                .read(getDuedoWithDateProvider(date: duedo!.dueDate).notifier)
                .editDuedo(entity: duedo!, title: controller.text);

            Navigator.pop(context);
          },
          child: Text(
            '확인',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: mainColor),
          ),
        ),
      ],
    );
  }
}
