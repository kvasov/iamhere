import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:iamhere/core/di/injection_container.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {

  ThemeBloc() : super(ThemeInitial()) {
    on<ThemeInitEvent>(_onInit);
    on<ThemeSetEvent>(_onSet);
    on<ThemeToggleEvent>(_onToggle);
  }

  /// Инициализация темы
  Future<void> _onInit(ThemeInitEvent event, Emitter<ThemeState> emit) async {
    // Загружаем тему из Secure Storage
    final settingsRepository = sl<SettingsRepository>();
    final result = await settingsRepository.getThemeMode();

    emit(ThemeLoaded(themeMode: result.data ?? ThemeMode.system));
  }

  /// Установка конкретного режима темы
  Future<void> _onSet(ThemeSetEvent event, Emitter<ThemeState> emit) async {
    final settingsRepository = sl<SettingsRepository>();

    final result = await settingsRepository.saveThemeMode(event.themeMode);

    if (result.isSuccess) {
      emit(ThemeLoaded(themeMode: event.themeMode));
    } else {
      emit(ThemeLoaded(themeMode: ThemeMode.system));
    }
  }

  /// Переключение между светлой и темной темой
  Future<void> _onToggle(ThemeToggleEvent event, Emitter<ThemeState> emit) async {
    final currentThemeMode = state is ThemeLoaded
        ? (state as ThemeLoaded).themeMode
        : ThemeMode.system;

    final newThemeMode = currentThemeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;

    emit(ThemeLoaded(themeMode: newThemeMode));
  }
}
