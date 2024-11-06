import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((_) => throw UnimplementedError());

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  ref.listenSelf((previous, next) {
    ref.read(sharedPreferencesProvider).setString("themeMode", next.name);
  });
  final themeModeName =
      ref.read(sharedPreferencesProvider).getString("themeMode");
  return ThemeMode.values.asNameMap()[themeModeName] ?? ThemeMode.system;
});
