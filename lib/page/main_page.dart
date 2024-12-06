import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/page/chat_view.dart';
import 'package:chattodo/page/setting_page.dart';

import 'package:chattodo/util/common.dart';
import 'package:chattodo/widget/bottom_widget.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mainColor = ref.watch(mainColorProvider);

    return GestureDetector(
      onTap: () => addTodoNode.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingPage(),
                ),
              );
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Chat Todo'),
                Icon(Icons.arrow_forward_ios, color: mainColor),
              ],
            ),
          ),
          centerTitle: false,
        ),
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const Expanded(child: ChatView()),
              BottomWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
