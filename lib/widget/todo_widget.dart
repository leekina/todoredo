import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/model/models/common.dart';
import 'package:chattodo/util/custom_motion.dart';
import 'package:chattodo/widget/bottom_widget/state/bottom_widget.state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:chattodo/model/models/todo.model.dart';
import 'package:chattodo/providers/todo/todo_provider.dart';
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
    //채팅 하나의 Row
    return Slidable(
      key: ValueKey(todo.id),
      //siwpe ->
      startActionPane: deleteAction(ref),
      //siwpe <-
      endActionPane: commentAction(ref),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: TodoTile(todo: todo),
      ),
    );
  }

  ActionPane commentAction(WidgetRef ref) {
    return ActionPane(
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
          foregroundColor: ref.watch(mainColorProvider),
          icon: Icons.comment,
        ),
      ],
    );
  }

  ActionPane deleteAction(WidgetRef ref) {
    return ActionPane(
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
    );
  }
}

//채팅의 동작 및 위치를 정의합니다.
class TodoTile extends HookConsumerWidget {
  const TodoTile({
    super.key,
    required this.todo,
  });

  final Todo todo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //if isTodo right else left
    final alignLeft =
        (todo.type == TodoType.redo) || (todo.type == TodoType.duedo);
    return Align(
      alignment: alignLeft ? Alignment.centerLeft : Alignment.centerRight,
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
          //두번누르면 완료
          onDoubleTap: () {
            ref.read(crudTodoProvider.notifier).toggleTodoComplete(todo);
            addTodoNode.unfocus();
          },
          //한번 누르면 강조
          onTap: () {
            todo.complete == true
                ? null
                : ref.read(crudTodoProvider.notifier).toggleTodoImportant(todo);
          },
          child: TodoView(todo: todo, isLeft: alignLeft),
        ),
      ),
    );
  }
}

//채팅의 뷰를 정의합니다.
class TodoView extends ConsumerWidget {
  const TodoView({
    super.key,
    required this.todo,
    required this.isLeft,
  });

  final Todo todo;
  final bool isLeft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColor = ref.watch(mainColorProvider);
    //comment가 있을경우 본문을 작은글씨로
    final smallTextStyle = Theme.of(context).textTheme.bodySmall;
    // has comment ? comment textStyle : title textStyle
    final bodyTextStyle = todo.complete
        ? Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)
        : null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: chatBoxDecoration(mainColor, context),
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
      child: todo.comment == null
          ? Text(todo.title, style: bodyTextStyle)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  todo.title,
                  style: todo.complete
                      ? smallTextStyle!.copyWith(color: Colors.white54)
                      : smallTextStyle!.copyWith(
                          color: smallTextStyle.color!.withOpacity(0.54),
                        ),
                ),
                Text(todo.comment ?? '', style: bodyTextStyle),
              ],
            ),
    );
  }

  BoxDecoration chatBoxDecoration(Color mainColor, BuildContext context) {
    return BoxDecoration(
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
            isLeft ? const Radius.circular(0) : const Radius.circular(8),
        bottomRight:
            isLeft ? const Radius.circular(8) : const Radius.circular(0),
      ),
      color: todo.complete ? mainColor : Theme.of(context).focusColor,
    );
  }
}
