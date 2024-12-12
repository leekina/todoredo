import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:chattodo/style/app.theme.dart';

//앱 전반적으로 이용하는 상태를 정의합니다.
//sharedPreferences를 이용
//TODO : SharedPreference에서 가져오는 파트 분리

final sharedPreferencesProvider =
    Provider<SharedPreferences>((_) => throw UnimplementedError());

final themeModeProvider = StateProvider<ThemeMode>((ref) {
  final themeModeName =
      ref.read(sharedPreferencesProvider).getString("themeMode");
  return ThemeMode.values.asNameMap()[themeModeName] ?? ThemeMode.system;
});

final mainColorProvider = StateProvider<Color>(
  (ref) {
    final mainColor =
        ref.read(sharedPreferencesProvider).getString("mainColor");

    return mainColor != null
        ? Color(int.parse(mainColor))
        : ThemeExtensionX.light.defaultColor;
  },
);

final checkFirstConnectionProvider = StateProvider<bool>(
  (ref) {
    final checkFirstConnection =
        ref.read(sharedPreferencesProvider).getBool("checkFirstConnection");

    return checkFirstConnection == true ? true : false;
  },
);
