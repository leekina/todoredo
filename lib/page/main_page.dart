import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoredo/page/chat_view.dart';
import 'package:todoredo/page/setting_page.dart';

import 'package:todoredo/util/common.dart';
import 'package:todoredo/widget/add_todo_widget.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController();

    return GestureDetector(
      onTap: () => addTodoNode.unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).secondaryHeaderColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).secondaryHeaderColor,
          surfaceTintColor: Theme.of(context).secondaryHeaderColor,
          title: const Text('ChatTodo'),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ));
              },
              icon: const Icon(Icons.settings),
            ),
            const SizedBox(width: 8)
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              const Expanded(child: ChatView()),
              AddTodoWidget(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}
