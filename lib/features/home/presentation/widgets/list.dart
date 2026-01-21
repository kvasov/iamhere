import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iamhere/features/home/presentation/bloc/places_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
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
                    return GFCard(
                      content: ListTile(
                        title: Text(place.name),
                        subtitle: Text('ID: ${place.id}'),
                        trailing: Text(
                          place.country == 'Russia'
                            ? "🇷🇺"
                            : "🇪🇬"
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