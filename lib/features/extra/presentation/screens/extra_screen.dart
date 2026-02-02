import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/place/presentation/bloc/places_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iamhere/core/di/injection_container.dart' as di;

class ExtraScreen extends StatefulWidget {
  const ExtraScreen({super.key});

  @override
  State<ExtraScreen> createState() => _ExtraScreenState();
}

class _ExtraScreenState extends State<ExtraScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlacesBloc>(
      create: (_) => di.sl<PlacesBloc>(),
      child: ExtraView(),
    );
  }
}

class ExtraView extends StatefulWidget {
  const ExtraView({super.key});

  @override
  State<ExtraView> createState() => _ExtraViewState();
}

class _ExtraViewState extends State<ExtraView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // backgroundColor: Colors.blueGrey,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              toolbarHeight: 50,
              automaticallyImplyLeading: false,
              // floating: true,
              // pinned: true,
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  color: Color.fromARGB(255, 35, 73, 145),
                  child: SafeArea(
                    child: Padding(
                      padding: const .symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: .center,
                        mainAxisAlignment: .spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              context.pop();
                            },
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                          ),
                          Column(
                            children: [
                              Text('Hello', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                              Text('World', style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverAppBar(
              expandedHeight: 140,
              toolbarHeight: 40,
              automaticallyImplyLeading: false,
              pinned: true,
              backgroundColor: Color.fromARGB(255, 35, 73, 145),
              flexibleSpace: FlexibleSpaceBar(
                background: LayoutBuilder(
                  builder: (context, constraints) {
                    final settings =
                        context.dependOnInheritedWidgetOfExactType<
                            FlexibleSpaceBarSettings>()!;

                    final max = settings.maxExtent;
                    final min = settings.minExtent;
                    final current = settings.currentExtent;

                    final t = ((current - min) / (max - min)).clamp(0.0, 1.0);

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        Transform.scale(
                          scale: 1 + t * 0.2,
                          child: Image.network(
                            'https://i.ytimg.com/vi/jPjkOVISpUU/maxresdefault.jpg',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset('assets/images/placeholder.jpg');
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Padding(
                            padding: const .only(top: 16.0, right: 16.0),
                            child: Text(
                              'Country',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(0, 1),
                                    blurRadius: 3,
                                    color: Colors.black.withValues(alpha: 0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                title: Text(
                  'Extra',
                ),
                centerTitle: false,
                titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                expandedTitleScale: 1.5,
              ),
            ),
            PlaceLinks(),

            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(0),
                margin: const EdgeInsets.all(0),
                color: Colors.redAccent,
                child: Column(
                  children: [
                    Text('Description'),
                    Text('Description'),
                    Text('Description'),
                    Text('Description'),
                    Text('Description'),
                    Text('Description'),
                    Text('Description'),
                    Text('Description'),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Text('Extra'),
                    SizedBox(height: 100),
                    Text('Extra'),
                    SizedBox(height: 100),
                    Text('Extra'),
                    SizedBox(height: 100),
                    Text('Extra'),
                    SizedBox(height: 100),
                    Text('Extra'),
                    SizedBox(height: 100),
                    Text('Extra'),
                    SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}



class PlaceLinks extends StatelessWidget {
  const PlaceLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: _NavHeaderDelegate(),
    );
  }
}

class _NavHeaderDelegate extends SliverPersistentHeaderDelegate {
  @override
  double get minExtent => 40;

  @override
  double get maxExtent => 100;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final currentExtent = (maxExtent - shrinkOffset).clamp(minExtent, maxExtent);
    return SizedBox(
      height: currentExtent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavLink(text: 'Описание', onTap: () {
            debugPrint('scroll to section 1');
          }),
          _NavLink(text: 'Отзывы', onTap: () {
            debugPrint('scroll to section 2');
          }),
          _NavLink(text: 'Контакты', onTap: () {
              debugPrint('scroll to section 3');
            }),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_) => true;
}

class _NavLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _NavLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onTap, child: Text(text));
  }
}

