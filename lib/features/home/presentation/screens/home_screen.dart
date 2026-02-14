import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iamhere/app/i18n/strings.g.dart';
import 'package:go_router/go_router.dart';
import 'package:iamhere/features/place/presentation/bloc/places_bloc.dart';
import 'package:iamhere/features/place/presentation/widgets/places_list_screen.dart';
import 'package:iamhere/core/di/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  final analytics = FirebaseAnalytics.instance;

  Future<void> showPromoTrigger() async {
    print('🔔 showPromoTrigger');
    await analytics.logEvent(
      name: 'app_launch',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlacesBloc>(
      create: (_) => di.sl<PlacesBloc>(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final t = Translations.of(context);

    return Scaffold(
      // extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(t.etc.section.string_1),
        backgroundColor: Colors.white,
        elevation: 0,
        forceMaterialTransparency: true,
        leading: Icon(Icons.menu),
        actions: [
          Icon(Icons.search),
          Icon(Icons.person),
        ],
        foregroundColor: Colors.blueGrey,
        toolbarHeight: 30,
        actionsPadding: .only(right: 16),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GFButton(
              text: 'Profile',
              icon: const Icon(Icons.person, size: 16, color: Colors.white),
              onPressed: () {
                context.push('/profile');
              },
            ),
            GFButton(
              text: 'Экран без BNB',
              icon: const Icon(Icons.import_export_sharp, size: 16, color: Colors.white),
              onPressed: () {
                context.push('/extra');
              }
            ),
            GFButton(
              text: 'Show Promo',
              icon: const Icon(Icons.local_offer, size: 16, color: Colors.white),
              onPressed: () {
                debugPrint('🔔 show promo!!!');
                FirebaseAnalytics.instance.logEvent(
                  name: 'promo_trigger',
                );
              }
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: PlacesListWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GFButton(
                text: t.etc.section.string_2,
                icon: const Icon(Icons.settings, size: 16, color: Colors.white),
                onPressed: () {
                  context.push('/settings');
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: .center,
                children: [
                  GFButton(
                    text: "Get all secure",
                    icon: const Icon(Icons.settings, size: 16, color: Colors.white),
                    onPressed: () {
                      final secureStorage = di.sl<FlutterSecureStorage>();
                      secureStorage.readAll().then((value) {
                        print('🔔 all secure storage: $value');
                      });
                    },
                  ),
                  SizedBox(width: 16),
                  GFButton(
                    text: "Delete all secure",
                    icon: const Icon(Icons.settings, size: 16, color: Colors.white),
                    onPressed: () {
                      final secureStorage = di.sl<FlutterSecureStorage>();
                      secureStorage.deleteAll().then((_) {
                        print('🔔 all secure storage deleted');
                      });
                    },
                  ),
                ],
              ),
            ),

            Image.asset('assets/images/1.jpg', fit: BoxFit.cover),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  return Text('isAuth: ${state.isAuth}, login: ${state.login}, name: ${state.name}, userId: ${state.userId}');
                }
                return const Text('State is not loaded');
              },
            ),
          ],
        ),
      ),
    );
  }
}
