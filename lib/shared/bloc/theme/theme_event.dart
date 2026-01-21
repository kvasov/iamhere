part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

/// Событие для установки конкретного режима темы
class ThemeSetEvent extends ThemeEvent {
  final ThemeMode themeMode;

  ThemeSetEvent({required this.themeMode});
}

/// Событие для переключения между светлой и темной темой
class ThemeToggleEvent extends ThemeEvent {}

/// Событие для инициализации темы (загрузка из настроек)
class ThemeInitEvent extends ThemeEvent {}