import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme();

  static ThemeData buildLightTheme(Color seedColor) {
    final scheme = ColorScheme.fromSeed(brightness: Brightness.light, seedColor: seedColor);

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.light,
      extensions: <ThemeExtension<dynamic>>[

      ],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface, // цвет фона AppBar
        foregroundColor: scheme.onSurface, // цвет текста и иконок AppBar
        elevation: 0, // тень AppBar
        centerTitle: true, // выравнивание заголовка по центру (iOS-стиль)
      ),
      scaffoldBackgroundColor: scheme.surface, // фон основных экранов (Scaffold)
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh, // фон чипов по умолчанию
        side: BorderSide(color: scheme.outlineVariant), // рамка чипов
        selectedColor: scheme.primaryContainer, // фон чипов в выбранном состоянии
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return scheme.primaryContainer; // фон выбранного сегмента
            return scheme.surfaceContainer; // фон невыбранного сегмента
          }),
          foregroundColor: WidgetStatePropertyAll(scheme.onSurface), // цвет текста/иконок сегментов
        ),
      ),
    );
  }

  static ThemeData buildDarkTheme(Color seedColor) {
    final scheme = ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: seedColor);


    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
      extensions: <ThemeExtension<dynamic>>[

      ],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),
      scaffoldBackgroundColor: scheme.background,
      chipTheme: ChipThemeData(
        backgroundColor: scheme.surfaceContainerHigh,
        side: BorderSide(color: scheme.outlineVariant),
        selectedColor: scheme.primaryContainer,
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) return scheme.primaryContainer;
            return scheme.surfaceContainer;
          }),
          foregroundColor: WidgetStatePropertyAll(scheme.onSurface),
        ),
      ),
    );
  }
}


