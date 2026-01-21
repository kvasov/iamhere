import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/app/i18n/strings.g.dart';
import 'package:iamhere/shared/bloc/locale/locale_bloc.dart';
import 'package:iamhere/shared/bloc/locale/locale_state.dart';
import 'package:iamhere/shared/bloc/locale/locale_event.dart';
import 'package:iamhere/shared/bloc/theme/theme_bloc.dart';
import 'package:getwidget/getwidget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.etc.section.string_2),
      ),
      body: BlocBuilder<LocaleBloc, LocaleState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              GFCard(
                content: ListTile(
                  title: Text(
                    state.locale.languageCode == 'ru' ? 'Язык' : 'Language',
                  ),
                  subtitle: Text(
                    state.locale.languageCode == 'ru' ? 'Русский' : 'English',
                  ),
                  trailing: GFToggle(
                    value: state.locale.languageCode == 'en',
                    onChanged: (value) {
                      context.read<LocaleBloc>().add(
                        LocaleSetEvent(
                          value! ? const Locale('en') : const Locale('ru'),
                        ),
                      );
                    },
                    duration: const Duration(milliseconds: 120),
                  ),
                ),
                padding: const .all(0),
              ),
              BlocBuilder<ThemeBloc, ThemeState>(
                builder: (context, themeState) {
                  final themeMode = themeState is ThemeLoaded
                      ? themeState.themeMode
                      : ThemeMode.system;

                  String themeText;
                  if (themeMode == ThemeMode.light) {
                    themeText = 'Светлая';
                  } else if (themeMode == ThemeMode.dark) {
                    themeText = 'Тёмная';
                  } else {
                    themeText = 'Системная';
                  }

                  return GFCard(
                    content: ListTile(
                      title: Text('Тема'),
                      subtitle: Text(themeText),
                      trailing: GFToggle(
                        value: themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          if (value != null) {
                            context.read<ThemeBloc>().add(
                              ThemeSetEvent(
                                themeMode: value ? ThemeMode.dark : ThemeMode.light,
                              ),
                            );
                          }
                        },
                        duration: const Duration(milliseconds: 120),
                      ),
                    ),
                    padding: const EdgeInsets.all(0),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

