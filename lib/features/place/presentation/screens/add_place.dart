import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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
  late final NewPlaceBloc _bloc = di.sl<NewPlaceBloc>();

  @override
  void dispose() {
    _bloc.close();
    _isMapInteracting.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<NewPlaceBloc>.value(
      value: _bloc,
      child: Scaffold(
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
          child: BlocConsumer<NewPlaceBloc, NewPlaceState>(
            listener: (context, state) {
              if (state is NewPlaceSuccess) {
                Future.delayed(const Duration(seconds: 3), () {
                  if (context.mounted) {
                    context.go('/place/${state.placeData['id']}');
                  }
                });
              }
              if (state is NewPlaceFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(state.message),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is NewPlaceSuccess) {
                return const Center(child: Text('Place added successfully\n Redirecting to place in 3 seconds...'));
              }
              if (state is NewPlaceLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              return PlaceForm(
                mapInteractionNotifier: _isMapInteracting,
                state: state,
              );
            },
          ),
        ),
      ),
    );
  }
}