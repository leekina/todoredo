import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/models/todo.model.dart';
import 'package:chattodo/util/common.dart';

class TodoView extends HookConsumerWidget {
  const TodoView({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSchedule = todo.type == TodoType.schedule.name;
    final time = DateFormat('hh:mm').format(todo.createDate);
    return Padding(
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.6),
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
                    bottomRight: Radius.circular(0)),
                color: todo.complete
                    ? ref.watch(mainColorProvider)
                    : Theme.of(context).focusColor),
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
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
