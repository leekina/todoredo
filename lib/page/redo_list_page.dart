import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/models/redo.model.dart';
import 'package:chattodo/providers/redo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

class RedoListPage extends HookConsumerWidget {
  const RedoListPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColor = ref.watch(mainColorProvider);
    final redos = ref.watch(crudRedoProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Redo List'),
        leadingWidth: 0,
        leading: const SizedBox(),
        actions: [
          IconButton(
            onPressed: () async {
              showDialog(
                context: context,
                builder: (context) {
                  return EditRedoDialog.add();
                },
              );
            },
            icon: Icon(Icons.add, color: mainColor),
          ),
          const SizedBox(width: 8)
        ],
      ),
      body: redos.maybeWhen(
        data: (redoList) {
          return ListView(
            children: redoList.map(
              (redo) {
                return ListTile(
                  title: Text(redo.title),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                            'Start: ${DateFormat('MM. dd').format(redo.createDate)}'),
                      ),
                      Expanded(
                        child: Text(
                            'Resent:  ${redo.lastCompleteDate != null ? DateFormat('MM. dd').format(redo.lastCompleteDate!) : "Nope"}'),
                      ),
                      Expanded(child: Text('Count:  ${redo.completeCount}')),
                    ],
                  ),
                );
              },
            ).toList(),
          );
        },
        orElse: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class EditRedoDialog extends HookConsumerWidget {
  const EditRedoDialog({
    this.redo,
    super.key,
  });

  final Redo? redo;

  factory EditRedoDialog.add() => const EditRedoDialog();
  factory EditRedoDialog.edit(Redo redo) => EditRedoDialog(redo: redo);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isEdit = redo != null;
    final controller =
        useTextEditingController(text: isEdit ? redo!.title : '');
    final mainColor = ref.watch(mainColorProvider);
    return AlertDialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      title: Text(isEdit ? '수정하기' : '등록하기'),
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
            ref.read(crudRedoProvider.notifier).addRedo(title: controller.text);
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
