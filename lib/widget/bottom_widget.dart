import 'package:chattodo/page/redo_list_page.dart';
import 'package:chattodo/widget/bottom_widget.state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chattodo/providers/todo_provider.dart';
import 'package:chattodo/util/common.dart';
import 'package:page_transition/page_transition.dart';

class BottomWidget extends HookConsumerWidget {
  const BottomWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentTodo = ref.watch(commentTodoProvider);
    final controller = ref.watch(todoTextfieldControllerProvider);
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
                  if (commentTodo == null) {
                    ref
                        .read(crudTodoProvider.notifier)
                        .addTodo(chat: controller.text);
                  } else {
                    ref
                        .read(crudTodoProvider.notifier)
                        .editTodoComment(commentTodo, controller.text);
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
