import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iamhere/features/place/presentation/bloc/places_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PlacesListWidget extends StatefulWidget {
  const PlacesListWidget({super.key});

  @override
  State<PlacesListWidget> createState() => _PlacesListWidgetState();
}

class _PlacesListWidgetState extends State<PlacesListWidget> {
  @override
  void initState() {
    super.initState();
    // Загружаем данные при инициализации виджета
    // context.read<ListBloc>().add(ListLoadEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: .center,
          children: [
            GFButton(
              color: Colors.red,
              onPressed: () {
                context.read<PlacesBloc>().add(PlacesClearEvent());
              },
              text: 'Clear this list',

            ),
            const SizedBox(width: 16),
            GFButton(
              color: Colors.blue,
              onPressed: () {
                context.read<PlacesBloc>().add(PlacesLoadEvent());
              },
              text: 'Load places',
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: BlocBuilder<PlacesBloc, PlacesState>(
            builder: (context, state) {
              if (state is PlacesLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is PlacesError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: ${state.message}'),
                      const SizedBox(height: 16),
                      GFButton(
                        text: 'Retry',
                        onPressed: () {
                          context.read<PlacesBloc>().add(PlacesLoadEvent());
                        },
                      ),
                    ],
                  ),
                );
              }

              if (state is PlacesLoaded) {
                if (state.items.isEmpty) {
                  return const Center(child: Text('No items found'));
                }

                return ListView.builder(
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final place = state.items[index];
                    return GestureDetector(
                      onTap: () {
                        context.pushNamed('place', pathParameters: {'placeId': place.id.toString()});
                      },
                      child: GFCard(
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              title: Text(place.name),
                              subtitle: Text('ID: ${place.id}'),
                              trailing: Text(
                                place.country == 'Russia'
                                  ? "🇷🇺"
                                  : "🇪🇬"
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(place.author?.name ?? ''),
                            ),
                            place.imageUrl != null
                              ? Image.network('http://0.0.0.0:8080/${place.imageUrl}')
                              : Image.asset('assets/images/placeholder.jpg'),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }
}