import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:iamhere/core/di/injection_container.dart' as di;
import 'package:introduction_screen/introduction_screen.dart';
import 'package:iamhere/features/profile/presentation/bloc/profile/profile_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(BuildContext context) async {
    final prefs = di.sl<SharedPreferences>();
    await prefs.setBool('splash_has_been_shown', true);
    if (context.mounted) context.go('/home');
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      allowImplicitScrolling: true,
      pages: [
        PageViewModel(
          title: "Fractional shares",
          body:
              "Instead of having to buy an entire share, invest any amount you want.",
          image: Image.asset('assets/images/1.jpg', width: 100, height: 100),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Learn as you go",
          body:
              "Download the Stockpile app and master the market with our mini-lesson.",
          image: Image.asset('assets/images/1.jpg', width: 100, height: 100),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Kids and teens",
          body:
              "Kids and teens can track their stocks 24/7 and place trades that you approve.",
          image: Image.asset('assets/images/1.jpg', width: 100, height: 100),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Full Screen Page",
          body:
              "Pages can be full screen as well.\n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc id euismod lectus, non tempor felis. Nam rutrum rhoncus est ac venenatis.",
          backgroundImage: 'assets/images/1.jpg',
          decoration: pageDecoration.copyWith(
            contentMargin: const EdgeInsets.symmetric(horizontal: 16),
            bodyFlex: 2,
            imageFlex: 3,
            safeArea: 100,
          ),
        ),
      ],
      onDone: () => _onIntroEnd(context),
      onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: true,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: false,
      back: const Icon(Icons.arrow_back),
      skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      next: const Icon(Icons.arrow_forward),
      done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color.fromARGB(255, 150, 230, 232),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
        ),
      ),
    );
  }




  // @override
  // Widget build(BuildContext context) {
  //   return BlocBuilder<ProfileBloc, ProfileState>(
  //     builder: (context, state) {
  //       return Scaffold(
  //         body:
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               Center(
  //                 child: Text('Splash'),
  //               ),
  //               GFButton(
  //                 text: 'Home',
  //                 color: GFColors.PRIMARY,
  //                 onPressed: () {
  //                   context.go('/home');
  //                 },
  //               ),
  //               Text(state.toString()),
  //               Row(
  //                 mainAxisAlignment: .center,
  //                 children: [
  //                   GFButton(
  //                     text: "Get all secure",
  //                     icon: const Icon(Icons.settings, size: 16, color: Colors.white),
  //                     onPressed: () {
  //                       final secureStorage = di.sl<FlutterSecureStorage>();
  //                       secureStorage.readAll().then((value) {
  //                         print('🔔 all secure storage: $value');
  //                       });
  //                     },
  //                   ),
  //                   SizedBox(width: 16),
  //                   GFButton(
  //                     text: "Delete all secure",
  //                     icon: const Icon(Icons.settings, size: 16, color: Colors.white),
  //                     onPressed: () {
  //                       final secureStorage = di.sl<FlutterSecureStorage>();
  //                       secureStorage.deleteAll().then((_) {
  //                         print('🔔 all secure storage deleted');
  //                       });
  //                     },
  //                   ),
  //                 ],
  //               )
  //             ],
  //           )
  //       );
  //     },
  //   );
  // }
}