import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/models/common.dart';
import 'package:chattodo/util/custom_motion.dart';
import 'package:chattodo/widget/bottom_widget.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:chattodo/models/todo.model.dart';
import 'package:chattodo/providers/todo_provider.dart';
import 'package:chattodo/util/common.dart';
import 'package:chattodo/widget/edit_chat_dialog.dart';

class TodoWidget extends HookConsumerWidget {
  const TodoWidget({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNotTodo =
        (todo.type == TodoType.redo) || (todo.type == TodoType.duedo);
    final mainColor = ref.watch(mainColorProvider);

    //ChatLine
    return Slidable(
      key: ValueKey(todo.id),
      startActionPane: ActionPane(
        openThreshold: 0.3,
        closeThreshold: 0.4,
        extentRatio: 0.2,
        motion: BehindMotion(),
        dismissible: DismissiblePane(
          dismissThreshold: 0.6,
          onDismissed: () {
            ref.read(crudTodoProvider.notifier).deleteTodo(todo);
          },
        ),
        children: [
          SlidableAction(
            padding: EdgeInsets.all(0),
            onPressed: (context) {
              ref.read(crudTodoProvider.notifier).deleteTodo(todo);
            },
            foregroundColor: Colors.red,
            icon: Icons.delete,
          ),
        ],
      ),
      endActionPane: ActionPane(
        dragDismissible: false,
        extentRatio: 0.1,
        motion: CustomMotion(
            onOpen: (context) async {
              ref.read(commentTodoProvider.notifier).setTodo(todo);
              addTodoNode.requestFocus();
            },
            motionWidget: BehindMotion()),
        children: [
          SlidableAction(
            padding: EdgeInsets.all(0),
            onPressed: (context) {
              Slidable.of(context)?.close();
            },
            autoClose: false,
            backgroundColor: Colors.transparent,
            foregroundColor: mainColor,
            icon: Icons.comment,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: TodoTile(isRedo: isNotTodo, todo: todo),
      ),
    );
  }
}

class TodoTile extends HookConsumerWidget {
  const TodoTile({
    super.key,
    required this.isRedo,
    required this.todo,
  });

  final bool isRedo;
  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Align(
      alignment: isRedo ? Alignment.centerLeft : Alignment.centerRight,
      child: Material(
        child: InkWell(
          //길게 누르면 수정
          onLongPress: () {
            if (!todo.complete) {
              showDialog(
                context: context,
                builder: (context) => EditTodoDialog(todo),
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
                  ref.read(crudTodoProvider.notifier).toggleTodoImportant(todo);
                },
          child: todo.comment == null
              ? TodoView(todo: todo, isRedo: isRedo)
              : TodoViewWithComment(todo: todo, isRedo: isRedo),
        ),
      ),
    );
  }
}

class TodoView extends ConsumerWidget {
  const TodoView({
    super.key,
    required this.todo,
    required this.isRedo,
  });

  final Todo todo;
  final bool isRedo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColor = ref.watch(mainColorProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          border: todo.complete
              ? Border.all(
                  color: mainColor,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside)
              : Border.all(
                  color: todo.important == true
                      ? mainColor
                      : Theme.of(context).focusColor,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(8),
            topRight: const Radius.circular(8),
            bottomLeft:
                isRedo ? const Radius.circular(0) : const Radius.circular(8),
            bottomRight:
                isRedo ? const Radius.circular(8) : const Radius.circular(0),
          ),
          color: todo.complete ? mainColor : Theme.of(context).focusColor),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      child: Text(
        todo.title,
        style: todo.complete
            ? Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.white)
            : null,
      ),
    );
  }
}

class TodoViewWithComment extends ConsumerWidget {
  const TodoViewWithComment({
    super.key,
    required this.todo,
    required this.isRedo,
  });

  final Todo todo;
  final bool isRedo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColor = ref.watch(mainColorProvider);
    final todoTextstyle = Theme.of(context).textTheme.bodySmall;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
          border: todo.complete
              ? Border.all(
                  color: mainColor,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside)
              : Border.all(
                  color: todo.important == true
                      ? mainColor
                      : Theme.of(context).focusColor,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(8),
            topRight: const Radius.circular(8),
            bottomLeft:
                isRedo ? const Radius.circular(0) : const Radius.circular(8),
            bottomRight:
                isRedo ? const Radius.circular(8) : const Radius.circular(0),
          ),
          color: todo.complete ? mainColor : Theme.of(context).focusColor),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            todo.title,
            style: todo.complete
                ? todoTextstyle!.copyWith(color: Colors.white54)
                : todoTextstyle!.copyWith(
                    color: todoTextstyle.color!.withOpacity(0.54),
                  ),
          ),
          Text(
            todo.comment ?? '',
            style: todo.complete
                ? Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white)
                : null,
          ),
        ],
      ),
    );
  }
}
