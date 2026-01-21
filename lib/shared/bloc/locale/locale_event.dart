import 'package:flutter/material.dart';

/// События для LocaleBloc
abstract class LocaleEvent {}

/// Событие для переключения языка
class LocaleToggleEvent extends LocaleEvent {}

/// Событие для установки конкретной локали
class LocaleSetEvent extends LocaleEvent {
  final Locale locale;

  LocaleSetEvent(this.locale);
}

/// Событие для инициализации локали из настроек
class LocaleInitEvent extends LocaleEvent {
  final String? languageCode;

  LocaleInitEvent(this.languageCode);
}