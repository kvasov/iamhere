import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iamhere/shared/widgets/blur_gradient.dart';

/// Scaffold с bottom app bar, который остается на месте при переходах
/// Извлекает AppBar и body из дочернего Scaffold и создает новый Scaffold с bottomAppBar
class ScaffoldWithBottomAppBar extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const ScaffoldWithBottomAppBar({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  int _getCurrentIndex(String location) {
    switch (location) {
      case '/home':
        return 0;
      case '/profile':
        return 1;
      case '/settings':
        return 2;
      default:
        return 0;
    }
  }

  void _onItemTapped(BuildContext context, int index) {
    final targetPath = switch (index) {
      0 => '/home',
      1 => '/profile',
      2 => '/settings',
      _ => '/home',
    };
    if (currentLocation == targetPath) return;
    context.push(targetPath);
  }

  Widget _buildBottomAppBar(BuildContext context) {
    final currentIndex = _getCurrentIndex(currentLocation);

    return Stack(
      children: [
        BlurGradientWidget(height: 60, sigma: 10, opacity: 0.0),
        SafeArea(
          child: BottomAppBar(
            shape: IslandSmoothBezierNotchedShape(
              horizontalMargin: 16,
              borderRadius: 20,
              notchMargin: 8,
              // shoulderWidth: bottomBarShoulderWidth,
            ),
            // shape: CircularNotchedRectangle(),
            notchMargin: 6,
            height: 48,
            padding: EdgeInsets.only(top: 0, bottom: 0),
            color: Color.fromARGB(255, 35, 73, 145),
            elevation: 0,
            child: Padding(
              padding: const .symmetric(horizontal: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Элементы слева от центра (где будет FloatingActionButton)
                  _buildNavItem(
                    context,
                    icon: Icons.home,
                    index: 0,
                    isSelected: currentIndex == 0,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.person,
                    index: 1,
                    isSelected: currentIndex == 1,
                  ),
                  // Spacer для создания пространства под FloatingActionButton
                  const SizedBox(width: 56), // Ширина FloatingActionButton
                  // Элементы справа от центра
                  _buildNavItem(
                    context,
                    icon: Icons.settings,
                    index: 2,
                    isSelected: currentIndex == 2,
                  ),
                  _buildNavItem(
                    context,
                    icon: Icons.settings,
                    index: 2,
                    isSelected: currentIndex == 2,
                  ),
                ],
              ),
            ),
          ),
        )
      ]
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => _onItemTapped(context, index),
      child: SizedBox(
        width: 48,
        height: 48,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white70,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Если child - это Scaffold, извлекаем его свойства и создаем новый Scaffold с bottomAppBar
    // Важно: НЕ копируем bottomNavigationBar из оригинального Scaffold, заменяем его нашим BottomAppBar
    if (child is Scaffold) {
      final scaffold = child as Scaffold;
      return Scaffold(
        extendBody: true,
        appBar: scaffold.appBar,
        body: scaffold.body,
        backgroundColor: scaffold.backgroundColor,
        resizeToAvoidBottomInset: scaffold.resizeToAvoidBottomInset,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.go('/add-place');
            debugPrint('🔔 show add place!!!');
          },
          shape: CircleBorder(),
          elevation: 0,
          backgroundColor: Color.fromRGBO(152, 182, 237, 1),
          child: const Icon(Icons.add),
        ),
        // Используем BottomAppBar виджет внутри bottomNavigationBar
        bottomNavigationBar: _buildBottomAppBar(context),
      );
    }
    // Если это не Scaffold, просто оборачиваем в Scaffold с BottomAppBar
    return Scaffold(
      body: child,
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }
}




// class IslandSmoothBezierNotchedShape extends NotchedShape {
//   final double horizontalMargin;
//   final double borderRadius;
//   final double notchMargin;
//   final double shoulderWidth;

//   const IslandSmoothBezierNotchedShape({
//     this.horizontalMargin = 16,
//     this.borderRadius = 20,
//     this.notchMargin = 8,
//     this.shoulderWidth = 16,
//   });

//   @override
//   Path getOuterPath(Rect host, Rect? guest) {
//     final Rect island = Rect.fromLTWH(
//       host.left + horizontalMargin,
//       host.top,
//       host.width - horizontalMargin * 2,
//       host.height,
//     );

//     if (guest == null) {
//       return Path()
//         ..addRRect(
//           RRect.fromRectAndRadius(
//             island,
//             Radius.circular(borderRadius),
//           ),
//         );
//     }

//     final Offset c = guest.center;
//     final double fabRadius = guest.width / 2;
//     final double R = fabRadius + notchMargin;

//     final double topY = island.top;
//     final double bottomY = island.bottom;

//     final double dy = c.dy - topY;
//     if (dy >= R) {
//       return Path()
//         ..addRRect(
//           RRect.fromRectAndRadius(
//             island,
//             Radius.circular(borderRadius),
//           ),
//         );
//     }

//     final double x0 = 90.0;
//     final double x1 = 30.0;
//     final double x2 = 35.0;

//     final Offset p0 = Offset(c.dx - x0, topY);
//     final Offset p1 = Offset(c.dx - x1, topY);
//     final Offset p2 = Offset(c.dx - x2, topY + R);
//     final Offset p3 = Offset(c.dx, topY + R);

//     final Offset p4 = Offset(c.dx + x2, topY + R);
//     final Offset p5 = Offset(c.dx + x1, topY);
//     final Offset p6 = Offset(c.dx + x0, topY);


//     final Path path = Path();

//     // ─── Верх ─────────────────────────────────────
//     path.moveTo(island.left + borderRadius, topY);
//     path.lineTo(p0.dx, p0.dy);

//     path.cubicTo(
//       p1.dx,
//       p1.dy,
//       p2.dx,
//       p2.dy,
//       p3.dx,
//       p3.dy,
//     );

//     path.cubicTo(
//       p4.dx,
//       p4.dy,
//       p5.dx,
//       p5.dy,
//       p6.dx,
//       p6.dy,
//     );





//     // ─── Дальше обычный island ────────────────────
//     path.lineTo(island.right - borderRadius, topY);

//     path.arcToPoint(
//       Offset(island.right, topY + borderRadius),
//       radius: Radius.circular(borderRadius),
//     );
//     path.lineTo(island.right, bottomY - borderRadius);
//     path.arcToPoint(
//       Offset(island.right - borderRadius, bottomY),
//       radius: Radius.circular(borderRadius),
//     );
//     path.lineTo(island.left + borderRadius, bottomY);
//     path.arcToPoint(
//       Offset(island.left, bottomY - borderRadius),
//       radius: Radius.circular(borderRadius),
//     );
//     path.lineTo(island.left, topY + borderRadius);
//     path.arcToPoint(
//       Offset(island.left + borderRadius, topY),
//       radius: Radius.circular(borderRadius),
//     );

//     path.close();
//     return path;
//   }
// }

class IslandSmoothBezierNotchedShape extends NotchedShape {
  final double horizontalMargin;
  final double borderRadius;
  final double notchMargin;

  const IslandSmoothBezierNotchedShape({
    this.horizontalMargin = 16,
    this.borderRadius = 20,
    this.notchMargin = 8,
  });

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) {
      return Path()..addRect(host);
    }
    final double r = guest.width / 2.0;
    final Radius notchRadius = Radius.circular(r);

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double a = -r - s2;
    final double b = host.top - guest.center.dy;

    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    final List<Offset> p = List<Offset>.filled(6, Offset.zero);

    // p0, p1, and p2 are the control points for segment A.
    p[0] = Offset(a - s1, b);
    p[1] = Offset(a, b);
    final double cmp = b < 0 ? -1.0 : 1.0;
    p[2] = cmp * p2yA > cmp * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    // p3, p4, and p5 are the control points for segment B, which is a mirror
    // of segment A around the y axis.
    p[3] = Offset(-1.0 * p[2].dx, p[2].dy);
    p[4] = Offset(-1.0 * p[1].dx, p[1].dy);
    p[5] = Offset(-1.0 * p[0].dx, p[0].dy);

    // translate all points back to the absolute coordinate system.
    for (int i = 0; i < p.length; i += 1) {
      p[i] += guest.center;
    }

    // Use the calculated points to draw out a path object.
    final Path path = Path();
    path
      ..moveTo(host.left + horizontalMargin + borderRadius, host.top)
      ..lineTo(p[0].dx, p[0].dy)
      ..quadraticBezierTo(p[1].dx, p[1].dy, p[2].dx, p[2].dy)
      ..arcToPoint(p[3], radius: notchRadius, clockwise: false)
      ..quadraticBezierTo(p[4].dx, p[4].dy, p[5].dx, p[5].dy)
      ..lineTo(host.right - horizontalMargin - borderRadius, host.top)
      ..arcToPoint(
        Offset(host.right - horizontalMargin, host.top + borderRadius),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(host.right - horizontalMargin, host.bottom - borderRadius)
      ..arcToPoint(
        Offset(host.right - horizontalMargin - borderRadius, host.bottom),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(host.left + horizontalMargin + borderRadius, host.bottom)
      ..arcToPoint(
        Offset(host.left + horizontalMargin, host.bottom - borderRadius),
        radius: Radius.circular(borderRadius),
      )
      ..lineTo(host.left + horizontalMargin, host.top + borderRadius)
      ..arcToPoint(
        Offset(host.left + horizontalMargin + borderRadius, host.top),
        radius: Radius.circular(borderRadius),
      );

    return path..close();
  }
}