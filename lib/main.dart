import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoredo/app/state/app.state.dart';
import 'package:todoredo/page/main_page.dart';
import 'package:todoredo/repository/todo_repository.dart';
import 'package:todoredo/style/app.theme.dart';

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
    ref.read(mainColorProvider);

    return MaterialApp(
      title: 'ChatTodo',
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          fontFamily: "Paperlogy",
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.light,
          extensions: const [ThemeExtensionX.light]),
      darkTheme: ThemeData(
          fontFamily: "Paperlogy",
          useMaterial3: true,
          colorSchemeSeed: Colors.blue,
          brightness: Brightness.dark,
          extensions: const [ThemeExtensionX.dark]),
      themeMode: ref.watch(themeModeProvider),
      home: const MainPage(),
    );
  }
}
