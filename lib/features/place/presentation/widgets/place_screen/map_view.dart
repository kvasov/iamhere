import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:iamhere/features/place/domain/entities/map_point.dart';
import 'package:iamhere/features/place/presentation/widgets/place_screen/clusterized_icon_painter.dart';
import 'package:iamhere/features/place/domain/entities/place.dart';

class MapView extends StatefulWidget {
  final PlaceModel place;

  const MapView({super.key, required this.place});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  /// Контроллер для управления картами
  late final YandexMapController _mapController;

  /// Значение текущего масштаба карты
  var _mapZoom = 0.0;

  /// Данные о местоположении пользователя
  CameraPosition? _userLocation;

  /// Точка, установленная пользователем по тапу
  Point? _tappedPoint;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: YandexMap(
        onMapCreated: (controller) async {
          _mapController = controller;
          // await _initLocationLayer();
          await _mapController.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: Point(latitude: widget.place.latitude, longitude: widget.place.longitude),
                zoom: 10,
              ),
            ),
          );
        },
        onCameraPositionChanged: (cameraPosition, _, __) {
          setState(() {
            _mapZoom = cameraPosition.zoom;
          });
        },
        onMapTap: (Point point) {
          debugPrint('Тап по карте: lat=${point.latitude}, lon=${point.longitude}');
          setState(() {
            _tappedPoint = point;
          });
        },

        mapObjects: [_getPlacemarkObject(MapPoint.fromPlace(widget.place))],
        // mapObjects: [
        //   _getClusterizedCollection(
        //     placemarks: _getPlacemarkObjects(context),
        //   ),
        //   if (_tappedPoint != null)
        //     PlacemarkMapObject(
        //       mapId: const MapObjectId('tapped-point'),
        //       point: _tappedPoint!,
        //       opacity: 1,
        //       icon: PlacemarkIcon.single(
        //         PlacemarkIconStyle(
        //           image: BitmapDescriptor.fromAssetImage('assets/images/pin.png'),
        //           scale: 2,
        //         ),
        //       ),
        //     ),
        // ],
        // onUserLocationAdded: (view) async {
        //   // получаем местоположение пользователя
        //   _userLocation = await _mapController.getUserCameraPosition();
        //   // если местоположение найдено, центрируем карту относительно этой точки
        //   if (_userLocation != null) {
        //     await _mapController.moveCamera(
        //       CameraUpdate.newCameraPosition(
        //         _userLocation!.copyWith(zoom: 10),
        //       ),
        //       animation: const MapAnimation(
        //         type: MapAnimationType.linear,
        //         duration: 0.3,
        //       ),
        //     );
        //   }
        //   // меняем внешний вид маркера - делаем его непрозрачным
        //   return view.copyWith(
        //     pin: view.pin.copyWith(
        //       opacity: 1,
        //     ),
        //   );
        // },
      ),
    );
  }

  /// Метод для получения коллекции кластеризованных маркеров
  ClusterizedPlacemarkCollection _getClusterizedCollection({
    required List<PlacemarkMapObject> placemarks,
  }) {
    return ClusterizedPlacemarkCollection(
        mapId: const MapObjectId('clusterized-1'),
        placemarks: placemarks,
        radius: 50,
        minZoom: 15,
        onClusterAdded: (self, cluster) async {
          return cluster.copyWith(
            appearance: cluster.appearance.copyWith(
              opacity: 1.0,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromBytes(
                    await ClusterIconPainter(cluster.size)
                        .getClusterIconBytes(),
                  ),
                ),
              ),
            ),
          );
        },
        onClusterTap: (self, cluster) async {
          await _mapController.moveCamera(
            animation: const MapAnimation(
                type: MapAnimationType.linear, duration: 0.3),
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: cluster.placemarks.first.point,
                zoom: _mapZoom + 1,
              ),
            ),
          );
        });
  }

  /// Метод, который включает слой местоположения пользователя на карте
  /// Выполняется проверка на доступ к местоположению, в случае отсутствия
  /// разрешения - выводит сообщение
  // Future<void> _initLocationLayer() async {
  //   final locationPermissionIsGranted =
  //       await Permission.location.request().isGranted;

  //   if (locationPermissionIsGranted) {
  //     await _mapController.toggleUserLayer(visible: true);
  //   } else {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //           content: Text('Нет доступа к местоположению пользователя'),
  //         ),
  //       );
  //     });
  //   }
  // }
}

/// Метод для генерации точек на карте
// List<MapPoint> _getMapPoints() {
//   return const [
//     MapPoint(name: 'Москва', latitude: 55.755864, longitude: 37.617698),
//     MapPoint(name: 'Лондон', latitude: 51.507351, longitude: -0.127696),
//     MapPoint(name: 'Рим', latitude: 41.887064, longitude: 12.504809),
//     MapPoint(name: 'Париж', latitude: 48.856663, longitude: 2.351556),
//     MapPoint(name: 'Стокгольм', latitude: 59.347360, longitude: 18.341573),
//   ];
// }

/// Метод для генерации маркера для отображения на карте
PlacemarkMapObject _getPlacemarkObject(MapPoint point) {
  return PlacemarkMapObject(
    mapId: MapObjectId('MapObject $point'),
    point: Point(latitude: point.latitude, longitude: point.longitude),
    opacity: 1,
    icon: PlacemarkIcon.single(
      PlacemarkIconStyle(
        image: BitmapDescriptor.fromAssetImage(
          'assets/images/pin.png',
        ),
        scale: 3,
      ),
    ),
  );
}

/// Метод для генерации объектов маркеров для отображения на карте
// List<PlacemarkMapObject> _getPlacemarkObjects(BuildContext context) {
//   return _getMapPoints()
//       .map(
//         (point) => PlacemarkMapObject(
//           mapId: MapObjectId('MapObject $point'),
//           point: Point(latitude: point.latitude, longitude: point.longitude),
//           opacity: 1,
//           icon: PlacemarkIcon.single(
//             PlacemarkIconStyle(
//               image: BitmapDescriptor.fromAssetImage(
//                 'assets/images/pin.png',
//               ),
//               scale: 2,
//             ),
//           ),
//           onTap: (_, __) => showModalBottomSheet(
//             context: context,
//             builder: (context) => _ModalBodyView(
//               point: point,
//             ),
//           ),
//         ),
//       )
//       .toList();
// }