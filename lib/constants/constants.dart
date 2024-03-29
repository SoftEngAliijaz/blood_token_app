import 'package:flutter/material.dart';

class AppUtils {
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color redColor = Color(0xFFFF0000);
  static const Color blueColor = Color(0xFF0000FF);

  ///AppUtils.customProgressIndicator
  static Center customProgressIndicator() => const Center(
          child: Center(
        child: CircularProgressIndicator(
          color: AppUtils.redColor,
          backgroundColor: AppUtils.whiteColor,
        ),
      ));
}

enum ThemeModeOption {
  Light,
  Dark,
  System,
}

extension ThemeModeOptionExtension on ThemeModeOption {
  ThemeMode toThemeMode() {
    switch (this) {
      case ThemeModeOption.Light:
        return ThemeMode.light;
      case ThemeModeOption.Dark:
        return ThemeMode.dark;
      case ThemeModeOption.System:
        return ThemeMode.system;
    }
  }
}
