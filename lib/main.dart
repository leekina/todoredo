import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/page/main_page.dart';
import 'package:chattodo/providers/todo_provider.dart';
import 'package:chattodo/repository/todo_repository.dart';
import 'package:chattodo/style/app.theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPreferences = await SharedPreferences.getInstance();
  await Hive.initFlutter();
  await Hive.openBox('todos');

  runApp(
    ProviderScope(
      overrides: [
        todoRepositoryProvider.overrideWithValue(TodoRepository()),
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).scaffoldBackgroundColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    void firstConnetionCheck() async {
      await Future.delayed(
        Duration.zero,
        () {
          final checkFirstConnetion = ref.watch(checkFirstConnectionProvider);
          if (checkFirstConnetion != true) {
            ref.read(todoRepositoryProvider).addTutorial();
            ref.invalidate(crudTodoProvider);
            ref.read(checkFirstConnectionProvider.notifier).state = true;
          }
        },
      );
    }

    firstConnetionCheck();
    return MaterialApp(
      title: 'ChatTodo',
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: ref.watch(mainColorProvider),
                ),
          ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: "Pretendard",
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.light,
          extensions: const [ThemeExtensionX.light]),
      darkTheme: ThemeData(
          appBarTheme: AppBarTheme(
            titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.w700,
                  color: ref.watch(mainColorProvider),
                ),
          ),
          fontFamily: "Pretendard",
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.dark,
          extensions: const [ThemeExtensionX.dark]),
      themeMode: ref.watch(themeModeProvider),
      home: const MainPage(),
    );
  }
}
