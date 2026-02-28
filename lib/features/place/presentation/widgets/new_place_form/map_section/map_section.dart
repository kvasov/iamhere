import 'package:flutter/material.dart';
import 'package:iamhere/shared/extensions/widget_animate_extensions.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/map_section/map_view.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/map_section/map_buttons.dart';

class MapSection extends StatefulWidget {
  const MapSection({
    super.key,
    required this.mapInteractionNotifier,
    this.onCoordinatesSelected,
  });
  final ValueNotifier<bool> mapInteractionNotifier;
  final void Function(double? latitude, double? longitude)? onCoordinatesSelected;

  @override
  State<MapSection> createState() => _MapSectionState();
}

class _MapSectionState extends State<MapSection> {
  bool modeLocationManually = false;

  void setModeLocationManually(bool value) {
    setState(() {
      modeLocationManually = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        Text('Coordinates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
        SizedBox(height: 8),
        MapButtons(modeLocationManually: modeLocationManually, setModeLocationManually: setModeLocationManually),
        Listener(
          onPointerDown: (_) => widget.mapInteractionNotifier.value = true,
          onPointerUp: (_) => widget.mapInteractionNotifier.value = false,
          onPointerCancel: (_) => widget.mapInteractionNotifier.value = false,
          child: MapView(
            showUserLayer: !modeLocationManually,
            onCoordinatesSelected: widget.onCoordinatesSelected,
          ),
        )
      ]
    ).formFieldAnimate(staggerIndex: 4);
  }
}