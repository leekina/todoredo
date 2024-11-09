import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:chattodo/style/app.theme.dart';

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

final mainColorProvider = StateProvider<Color>(
  (ref) {
    ref.listenSelf((previous, next) {
      ref
          .read(sharedPreferencesProvider)
          .setString("mainColor", next.value.toString());
    });
    final mainColor =
        ref.read(sharedPreferencesProvider).getString("mainColor");

    return mainColor != null
        ? Color(int.parse(mainColor))
        : ThemeExtensionX.light.defaultColor;
  },
);

final checkFirstConnectionProvider = StateProvider<bool>(
  (ref) {
    ref.listenSelf((previous, next) async {
      await ref
          .read(sharedPreferencesProvider)
          .setBool("checkFirstConnection", next);
    });
    final checkFirstConnection =
        ref.read(sharedPreferencesProvider).getBool("checkFirstConnection");

    return checkFirstConnection == true ? true : false;
  },
);
