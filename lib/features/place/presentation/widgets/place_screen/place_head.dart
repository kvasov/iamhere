import 'package:flutter/material.dart';
import 'package:iamhere/features/place/domain/entities/place.dart';
import 'package:iamhere/core/constants/host.dart';
import 'package:go_router/go_router.dart';

class PlaceHead extends StatelessWidget {
  final PlaceModel place;
  const PlaceHead({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return SliverLayoutBuilder(
      builder: (context, constraints) {
        const expandedHeight = 200.0;
        const toolbarHeight = 40.0;
        const bottomMinHeight = 40.0;
        const bottomMaxHeight = 50.0;
        final collapsedHeight = toolbarHeight + bottomMinHeight;

        final currentHeight = expandedHeight - constraints.scrollOffset;
        // Вычисляем t на основе scroll offset
        final t = ((currentHeight - collapsedHeight) / (expandedHeight - collapsedHeight)).clamp(0.0, 1.0);

        final bottomHeight = bottomMinHeight + (bottomMaxHeight - bottomMinHeight) * t;

        final titlePaddingLeft = 64 - 55 * t;

        return SliverAppBar(
          expandedHeight: expandedHeight,
          toolbarHeight: toolbarHeight,
          automaticallyImplyLeading: false,
          pinned: true,
          backgroundColor: Color.fromARGB(255, 35, 73, 145),
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                Transform.scale(
                  scale: 1 + t * 0.1,
                  child: Image.network(
                    'http://${host}/${place.photos?.first.path}',
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
                    padding: .only(top: 16.0, right: 16.0),
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
                // Positioned(
                //   left: 0 - (500 * t) / 2 + 100 * t,
                //   top: constraints.maxHeight * 0.5 - (200 * t) / 2,
                //   width: 500 * t,
                //   height: 500 * t,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Color.fromARGB(76, 21, 117, 155),
                //       borderRadius: BorderRadius.circular(200),
                //     ),
                //   ),
                // ),
                // Positioned(
                //   right: 0 - (500 * t) / 2 ,
                //   top: constraints.maxHeight * 0.3 - (700 * t) / 2,
                //   width: 500 * t,
                //   height: 500 * t,
                //   child: Container(
                //     decoration: BoxDecoration(
                //       color: Color.fromARGB(77, 48, 145, 43),
                //       borderRadius: BorderRadius.circular(200),
                //     ),
                //   ),
                // ),
              ],
            ),
            title: Stack(
              children: [
                Positioned(
                  left: 16,
                  bottom: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB((255 * (1 - t)).toInt(), 255, 255, 255),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        context.pop();
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Color.fromARGB((255 * (1 - t)).toInt(), 35, 73, 145),
                        size: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: .only(left: titlePaddingLeft, top: 20, bottom: 4),
                  child: Text(
                    place.name,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            centerTitle: false,
            titlePadding: .only(bottom: 48.0),
            expandedTitleScale: 1.5,
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(bottomHeight),
            child: Container(
              height: bottomHeight,
              color: Colors.blueGrey.shade800,
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
            ),
          ),
        );
      },
    );
  }
}


class _NavLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _NavLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

