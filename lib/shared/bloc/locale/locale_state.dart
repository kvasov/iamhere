import 'package:flutter/material.dart';

/// Состояние LocaleBloc
class LocaleState {
  final Locale locale;

  LocaleState(this.locale);

  LocaleState copyWith({Locale? locale}) {
    return LocaleState(locale ?? this.locale);
  }
}
