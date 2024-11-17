import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/models/redo.model.dart';
import 'package:chattodo/providers/redo_provider.dart';
import 'package:chattodo/providers/todo_provider.dart';
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
        surfaceTintColor: Colors.transparent,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        centerTitle: true,
        title: const Text('Redo List'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close_rounded, color: ref.read(mainColorProvider)),
        ),
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
                  onTap: () {
                    ref
                        .read(crudTodoProvider.notifier)
                        .addReTodo(chat: redo.title, redoId: redo.id);
                    Navigator.pop(context);
                  },
                  title: Text(redo.title),
                  subtitle: Row(
                    children: [
                      Expanded(
                        child: Text(
                            'Start: ${DateFormat('MM. dd').format(redo.createDate)}'),
                      ),
                      Consumer(
                        builder: (context, ref, child) {
                          if (redo.retodoList.isNotEmpty) {
                            final resentCompleteTodo = ref
                                .watch(getTodoProvider(redo.retodoList.last));

                            return resentCompleteTodo.maybeWhen(
                              data: (resentTodo) {
                                final date = resentTodo != null
                                    ? DateFormat('MM. dd')
                                        .format(resentTodo.completeDate!)
                                    : "Nope";
                                return Expanded(
                                  child: Text('Recent: $date'),
                                );
                              },
                              orElse: () {
                                return const Expanded(
                                  child: Text('Recent: Nope'),
                                );
                              },
                            );
                          } else {
                            return const Expanded(
                              child: Text('Recent: Nope'),
                            );
                          }
                        },
                      ),
                      Expanded(
                          child: Text('Count:  ${redo.retodoList.length}')),
                    ],
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        ref.read(crudRedoProvider.notifier).deleteRedo(redo);
                      },
                      icon: const Icon(Icons.close_rounded)),
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