import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todoredo/app/state/app.state.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('설정'),
        ),
        body: ListView(
          children: [
            //TODO switch로 변경
            ListTile(
              leading: const Icon(Icons.dark_mode),
              trailing: DropdownButton(
                value: ref.watch(themeModeProvider),
                items: [
                  ...ThemeMode.values.map((themeMode) => DropdownMenuItem(
                        value: themeMode,
                        child: Text(switch (themeMode) {
                          ThemeMode.light => "라이트 모드",
                          ThemeMode.dark => "다크 모드",
                          ThemeMode.system => "시스템 모드",
                        }),
                      ))
                ],
                onChanged: (value) {
                  if (value == null) return;
                  ref.read(themeModeProvider.notifier).state = value;
                },
                underline: const SizedBox(),
              ),
              title: const Text("테마"),
            ),
          ],
        ));
  }
}
