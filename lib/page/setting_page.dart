import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:chattodo/app/state/app.state.dart';
import 'package:chattodo/style/app_color.dart';

class SettingPage extends HookConsumerWidget {
  const SettingPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          foregroundColor: ref.watch(mainColorProvider),
          title: const Text('설정'),
        ),
        body: ListView(
          children: [
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
            //Color를 재대로 인식하지 못해서 Color.value 값을 이용해서 리스트 생성
            ListTile(
              leading: const Icon(Icons.color_lens),
              trailing: DropdownButton<int>(
                value: ref.watch(mainColorProvider).value,
                items: [
                  ...ThemeColor.values.map((color) => DropdownMenuItem(
                        value: color.color.value,
                        child: Row(
                          children: [
                            Icon(Icons.colorize, color: color.color),
                            const SizedBox(width: 4),
                            Text(color.name),
                          ],
                        ),
                      ))
                ],
                onChanged: (value) {
                  if (value == null) return;
                  ref.read(mainColorProvider.notifier).state = Color(value);
                },
                underline: const SizedBox(),
              ),
              title: const Text("컬러"),
            ),
          ],
        ));
  }
}
