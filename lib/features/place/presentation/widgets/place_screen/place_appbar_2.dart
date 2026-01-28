import 'package:flutter/material.dart';
import 'package:iamhere/features/place/domain/entities/place.dart';

class PlaceAppbar2 extends StatelessWidget {
  final PlaceModel place;
  const PlaceAppbar2({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
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
                Image.network(
                  'http://0.0.0.0:8080/${place.photos?.first.path}',
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
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const .only(top: 16.0, right: 16.0),
                    child: Text(
                      place.country,
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
                      color: Color.fromARGB(76, 21, 117, 155),
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
                      color: Color.fromARGB(77, 48, 145, 43),
                      borderRadius: BorderRadius.circular(200),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        title: Text(
          place.name,
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
    );
  }
}