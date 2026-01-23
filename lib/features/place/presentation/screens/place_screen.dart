import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/place/presentation/bloc/places_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iamhere/core/di/injection_container.dart' as di;

class PlaceScreen extends StatefulWidget {
  const PlaceScreen({super.key});

  @override
  State<PlaceScreen> createState() => _PlaceScreenState();
}

class _PlaceScreenState extends State<PlaceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<PlacesBloc>(
      create: (_) => di.sl<PlacesBloc>(),
      child: PlaceView(),
    );
  }
}

class PlaceView extends StatefulWidget {
  const PlaceView({super.key});

  @override
  State<PlaceView> createState() => _PlaceViewState();
}

class _PlaceViewState extends State<PlaceView> {
  String? _loadedPlaceId;

  @override
  Widget build(BuildContext context) {
    final placeId = GoRouterState.of(context).pathParameters['placeId'];

    // Отправляем событие загрузки только один раз при первом рендере
    if (placeId != null && _loadedPlaceId != placeId) {
      _loadedPlaceId = placeId;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<PlacesBloc>().add(PlaceLoadEvent(placeId: placeId));
        }
      });
    }

    return BlocBuilder<PlacesBloc, PlacesState>(
      builder: (context, state) {
        if (state is PlaceLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PlaceError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        if (state is PlaceLoaded) {
          return Scaffold(
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
                            Image.asset(
                              'assets/images/1.jpg',
                              fit: BoxFit.cover,
                            ),
                            // Градиент для лучшей читаемости текста
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            // Текст поверх изображения
                            Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 32.0),
                                child: Text(
                                  state.place.name,
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
                            Positioned(
                              left: 0 - (500 * t) / 2 + 100 * t,
                              top: constraints.maxHeight * 0.5 - (200 * t) / 2,
                              width: 500 * t,
                              height: 500 * t,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(141, 21, 117, 155),
                                  borderRadius: BorderRadius.circular(200),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0 - (500 * t) / 2 ,
                              top: constraints.maxHeight * 0.3 - (700 * t) / 2,
                              width: 500 * t,
                              height: 500 * t,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(141, 48, 145, 43),
                                  borderRadius: BorderRadius.circular(200),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    title: Text(
                      state.place.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                      )
                    ),
                    centerTitle: false,
                    titlePadding: EdgeInsets.only(left: 16.0, bottom: 16.0),
                    expandedTitleScale: 1.5,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text('Nmae: ${state.place.name}'),
                        Text('Latitude: ${state.place.latitude}'),
                        Text('Longitude: ${state.place.longitude}'),
                        Text('Country: ${state.place.country}'),
                        Text('Address: ${state.place.address}'),
                      ],
                    ),
                  ),
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text('Nmae: ${state.place.name}'),
                      ],
                    ),
                  ),

                ),
                // Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text('Nmae: ${state.place.name}'),
                //       Text('Latitude: ${state.place.latitude}'),
                //       Text('Longitude: ${state.place.longitude}'),
                //       Text('Country: ${state.place.country}'),
                //       Text('Address: ${state.place.address}'),
                //     ],
                //   ),
                // )
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       onPressed: () {
    //         context.pop();
    //       },
    //       icon: const Icon(Icons.arrow_back),
    //     ),
    //     title: Text('Place'),
    //   ),
    //   body: BlocBuilder<PlacesBloc, PlacesState>(
    //     builder: (context, state) {
    //       if (state is PlaceLoading) {
    //         return const Center(child: CircularProgressIndicator());
    //       }
    //       if (state is PlaceError) {
    //         return Center(child: Text('Error: ${state.message}'));
    //       }
    //       if (state is PlaceLoaded) {
    //         return Padding(
    //           padding: const EdgeInsets.all(16.0),
    //           child: Column(
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text('Nmae: ${state.place.name}'),
    //               Text('Latitude: ${state.place.latitude}'),
    //               Text('Longitude: ${state.place.longitude}'),
    //               Text('Country: ${state.place.country}'),
    //               Text('Address: ${state.place.address}'),
    //             ],
    //           ),
    //         );
    //       }
    //       return const SizedBox.shrink();
    //     },
    //   ),
    // );
  }
}