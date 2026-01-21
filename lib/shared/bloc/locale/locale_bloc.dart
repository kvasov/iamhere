import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/app/i18n/strings.g.dart';
import 'package:iamhere/shared/bloc/locale/locale_state.dart';
import 'package:iamhere/shared/bloc/locale/locale_event.dart';

/// BLoC для управления локалью приложения
class LocaleBloc extends Bloc<LocaleEvent, LocaleState> {
  LocaleBloc() : super(LocaleState(const Locale('ru'))) {
    on<LocaleInitEvent>(_onInit);
    on<LocaleToggleEvent>(_onToggle);
    on<LocaleSetEvent>(_onSet);
  }

  /// Инициализация локали из настроек
  Future<void> _onInit(LocaleInitEvent event, Emitter<LocaleState> emit) async {
    final languageCode = event.languageCode ?? 'ru';
    final locale = Locale(languageCode);
    final appLocale = languageCode == 'ru' ? AppLocale.ru : AppLocale.en;

    await LocaleSettings.setLocale(appLocale);
    emit(LocaleState(locale));
  }

  /// Переключение языка
  Future<void> _onToggle(LocaleToggleEvent event, Emitter<LocaleState> emit) async {
    final newLanguageCode = state.locale.languageCode == 'ru' ? 'en' : 'ru';
    final newLocale = Locale(newLanguageCode);
    final appLocale = newLanguageCode == 'ru' ? AppLocale.ru : AppLocale.en;

    await LocaleSettings.setLocale(appLocale);
    emit(LocaleState(newLocale));
  }

  /// Установка конкретной локали
  Future<void> _onSet(LocaleSetEvent event, Emitter<LocaleState> emit) async {
    final appLocale = event.locale.languageCode == 'ru' ? AppLocale.ru : AppLocale.en;

    await LocaleSettings.setLocale(appLocale);
    emit(LocaleState(event.locale));
  }
}

