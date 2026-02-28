import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/core/di/injection_container.dart' as di;
import 'package:iamhere/features/place/presentation/bloc/new_place_form/new_place_bloc.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/place_form.dart';

class AddPlaceScreen extends StatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final ValueNotifier<bool> _isMapInteracting = ValueNotifier(false);

  @override
  void dispose() {
    _isMapInteracting.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.arrow_back),
        title: Text('Add Place'),
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: _isMapInteracting,
        builder: (context, isInteracting, child) {
          return SingleChildScrollView(
            physics: isInteracting ? const NeverScrollableScrollPhysics() : null,
            child: child,
          );
        },
        child: BlocProvider<NewPlaceBloc>(
          create: (_) => di.sl<NewPlaceBloc>(),
          child: PlaceForm(
            mapInteractionNotifier: _isMapInteracting,
          ),
        ),
      ),
    );
  }
}