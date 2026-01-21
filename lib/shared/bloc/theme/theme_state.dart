part of 'theme_bloc.dart';

@immutable
sealed class ThemeState {}

/// Начальное состояние темы
final class ThemeInitial extends ThemeState {
  final ThemeMode themeMode;

  ThemeInitial({this.themeMode = ThemeMode.system});
}

/// Состояние с установленной темой
final class ThemeLoaded extends ThemeState {
  final ThemeMode themeMode;

  ThemeLoaded({required this.themeMode});
}
