import 'package:chattodo/page/canendar_page.state.dart';
import 'package:chattodo/providers/duedo_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ScheduleView extends HookConsumerWidget {
  const ScheduleView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentDate = ref.watch(currentDateProvider);
    final duedos = ref.watch(crudDuedoProvider(date: currentDate));

    return duedos.when(
      data: (duedoList) => ListView.builder(
        itemCount: duedoList.length,
        itemBuilder: (context, index) {
          final duedo = duedoList[index];
          return ListTile(
            key: ref.read(duedoListKeysProvider.notifier).getKey(index),
            title: Text(duedo.title),
            subtitle: Text(duedo.dueDate.toString()),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('에러 발생: $error')),
    );
  }
}
