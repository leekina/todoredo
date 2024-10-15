import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoredo/page/main_page.dart';
import 'package:todoredo/providers/providers.dart';
import 'package:todoredo/repository/todo_repository.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('todos');
  runApp(
    ProviderScope(
      overrides: [
        todosRepositoryProvider.overrideWithValue(HiveTodoRepository()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const MainPage(),
    );
  }
}

class BottomWidget extends HookConsumerWidget {
  const BottomWidget({
    super.key,
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectRe = useState(false);
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: TextFormField(
        controller: controller,
        focusNode: textFocus,
        onFieldSubmitted: (value) {
          ref
              .read(chatProvider.notifier)
              .addchat(chat: value, re: selectRe.value);
          controller.clear();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              selectRe.value = !selectRe.value;
              controller.clear();
            },
            child: Icon(
              Icons.restart_alt,
              color: selectRe.value ? Colors.red : Colors.grey,
            ),
          ),
          suffixIcon: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              ref
                  .read(chatProvider.notifier)
                  .addchat(chat: controller.text, re: selectRe.value);
              controller.clear();
            },
            child: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}
