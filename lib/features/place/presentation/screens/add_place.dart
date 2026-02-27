import 'package:flutter/material.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/place_form.dart';

class AddPlaceScreen extends StatelessWidget {
  const AddPlaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: Icon(Icons.arrow_back),
        title: Text('Add Place'),
      ),
      body: Column(
        children: [
          PlaceForm(),
        ],
      ),
    );
  }
}