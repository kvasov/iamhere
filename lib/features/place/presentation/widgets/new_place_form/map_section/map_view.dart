import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'package:iamhere/features/place/domain/entities/map_point.dart';

class MapView extends StatefulWidget {
  const MapView({super.key, this.showUserLayer = true, this.onCoordinatesSelected});

  /// Показывать ли слой местоположения пользователя (true = «Моё местоположение»)
  final bool showUserLayer;

  /// Вызывается при выборе координат (тап по карте или получение геолокации)
  final void Function(double? latitude, double? longitude)? onCoordinatesSelected;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  /// Контроллер для управления картами
  YandexMapController? _mapController;

  /// Данные о местоположении пользователя
  CameraPosition? _userLocation;

  /// Точка, установленная пользователем по тапу
  Point? _tappedPoint;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.showUserLayer != widget.showUserLayer) {
      _updateUserLayerVisibility();
    }
  }

  Future<void> _updateUserLayerVisibility() async {
    final controller = _mapController;
    if (controller != null) {
      await controller.toggleUserLayer(visible: widget.showUserLayer);
      if (widget.showUserLayer) {
        setState(() {
          _tappedPoint = null;
        });
        _setUserLocationCoordinates();
      } else {
        widget.onCoordinatesSelected?.call(null, null);
      }
    }
  }

  void _setUserLocationCoordinates() {
    widget.onCoordinatesSelected?.call(
      _userLocation!.target.latitude,
      _userLocation!.target.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: YandexMap(
        onMapCreated: (controller) async {
          _mapController = controller;
          if (mounted) await _initLocationLayer();
          await controller.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: Point(latitude: 0, longitude: 0),
                zoom: 10,
              ),
            ),
          );
        },
        onMapTap: (Point point) {
          setState(() {
            _tappedPoint = point;
          });
          widget.onCoordinatesSelected?.call(point.latitude, point.longitude);
        },

        mapObjects: _tappedPoint != null
            ? [_getPlacemarkObject(MapPoint(latitude: _tappedPoint!.latitude, longitude: _tappedPoint!.longitude))]
            : [],

        onUserLocationAdded: (view) async {
          // получаем местоположение пользователя
          final controller = _mapController;
          if (controller == null) return view;
          _userLocation = await controller.getUserCameraPosition();
          if (_userLocation != null) {
            _setUserLocationCoordinates();
          }
          // если местоположение найдено, центрируем карту относительно этой точки
          if (_userLocation != null) {
            await controller.moveCamera(
              CameraUpdate.newCameraPosition(
                _userLocation!.copyWith(zoom: 14),
              ),
              animation: const MapAnimation(
                type: MapAnimationType.linear,
                duration: 0.3,
              ),
            );
          }
          // меняем внешний вид маркера - делаем его непрозрачным
          return view.copyWith(
            pin: view.pin.copyWith(
              opacity: 1,
            ),
          );
        },
      ),
    );
  }

  /// Метод, который включает/выключает слой местоположения пользователя на карте
  /// Выполняется проверка на доступ к местоположению, в случае отсутствия
  /// разрешения - выводит сообщение
  Future<void> _initLocationLayer() async {
    final locationPermissionIsGranted =
        await Permission.location.request().isGranted;

    if (locationPermissionIsGranted) {
      await _mapController?.toggleUserLayer(visible: widget.showUserLayer);

    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Нет доступа к местоположению пользователя'),
          ),
        );
      });
    }
  }
}

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
