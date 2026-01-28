import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/features/place/presentation/bloc/places_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iamhere/core/di/injection_container.dart' as di;
import 'package:iamhere/features/place/presentation/widgets/place_screen/place_appbar_1.dart';
import 'package:iamhere/features/place/presentation/widgets/place_screen/place_appbar_2.dart';

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
                PlaceAppbar1(),
                PlaceAppbar2(place: state.place),
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
                        Text('Image URL: ${state.place.imageUrl}'),
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