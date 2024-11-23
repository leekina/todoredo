import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class ThemeExtensionX extends ThemeExtension<ThemeExtensionX> {
  final Color defaultColor;
  final Color pointColor;

  const ThemeExtensionX({
    required this.defaultColor,
    required this.pointColor,
  });

  static const light = ThemeExtensionX(
    defaultColor: Color(0xff88b04b),
    pointColor: Color(0xFFFF1A8D),
  );
  static const dark = ThemeExtensionX(
    defaultColor: Color(0xff88b04b),
    pointColor: Color(0xFFFF1A8D),
  );

  @override
  ThemeExtensionX copyWith({
    Color? defaultColor,
    Color? pointColor,
  }) {
    return ThemeExtensionX(
      defaultColor: defaultColor ?? this.defaultColor,
      pointColor: pointColor ?? this.pointColor,
    );
  }

  @override
  ThemeExtensionX lerp(
      covariant ThemeExtension<ThemeExtensionX>? other, double t) {
    if (other is! ThemeExtensionX) return this;
    return ThemeExtensionX(
      defaultColor: Color.lerp(defaultColor, other.defaultColor, t)!,
      pointColor: Color.lerp(pointColor, other.pointColor, t)!,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThemeExtensionX &&
            const DeepCollectionEquality()
                .equals(defaultColor, other.defaultColor) &&
            const DeepCollectionEquality()
                .equals(pointColor, other.pointColor));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType.hashCode,
      const DeepCollectionEquality().hash(defaultColor),
      const DeepCollectionEquality().hash(pointColor),
    );
  }
}

// extension BeautyThemeBuildContextProps on BuildContext {
//   ThemeExtensionX get appTheme => Theme.of(this).extension<ThemeExtensionX>()!;
//   Color get mainColor => appTheme.defaultColor;
//   Color get pointColor => appTheme.pointColor;
// }
