import 'package:chattodo/page/main_page.dart';
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
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentTodo = ref.watch(commentTodoProvider);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: Column(
        children: [
          Container(
            color: Colors.green,
            height: commentTodo == null ? 0 : 60,
            child: Text('data'),
          ),
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () {
                  addTodoNode.unfocus();
                  Navigator.of(context).push(
                    PageTransition(
                        child: const RedoListPage(),
                        childCurrent: const MainPage(),
                        type: PageTransitionType.leftToRightJoined,
                        fullscreenDialog: true),
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
                  if (controller.text == "") return;
                  ref
                      .read(crudTodoProvider.notifier)
                      .addTodo(chat: controller.text);

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
