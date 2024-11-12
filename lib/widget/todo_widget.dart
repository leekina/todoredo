import 'package:chattodo/app/state/app.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:chattodo/models/todo.model.dart';
import 'package:chattodo/providers/todo_provider.dart';
import 'package:chattodo/util/common.dart';
import 'package:chattodo/widget/edit_chat_dialog.dart';

import 'package:intl/intl.dart';

class TodoWidget extends HookConsumerWidget {
  const TodoWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSchedule = todo.type == TodoType.schedule.name;
    final time = DateFormat('HH:mm').format(todo.createDate);
    //ChatLine
    return Dismissible(
      background: const ColoredBox(
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 20),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            SizedBox(width: 4),
            Text(
              'delete',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
      key: ValueKey(todo.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        ref.read(crudTodoProvider.notifier).deleteTodo(todo);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment:
              isSchedule ? MainAxisAlignment.start : MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text(
                time,
              ),
            ),
            const SizedBox(width: 8),
            //ChatView
            Material(
              child: InkWell(
                //길게 누르면 수정
                onLongPress: () {
                  if (!todo.complete) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EditTodoDialog(todo);
                      },
                    );
                  }
                },
                onDoubleTap: () {
                  ref.read(crudTodoProvider.notifier).toggleTodoComplete(todo);
                  //언포커스
                  addTodoNode.unfocus();
                },
                onTap: todo.complete == true
                    ? null
                    : () {
                        ref
                            .read(crudTodoProvider.notifier)
                            .toggleTodoImportant(todo);
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      border: todo.complete
                          ? Border.all(
                              color: ref.watch(mainColorProvider),
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside)
                          : Border.all(
                              color: todo.important == true
                                  ? ref.watch(mainColorProvider)
                                  : Theme.of(context).focusColor,
                              width: 2,
                              strokeAlign: BorderSide.strokeAlignOutside),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                      color: todo.complete
                          ? ref.watch(mainColorProvider)
                          : Theme.of(context).focusColor),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6),
                  child: Text(
                    todo.title,
                    style: todo.complete
                        ? Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: Colors.white)
                        : null,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
