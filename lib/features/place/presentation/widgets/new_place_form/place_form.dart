import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iamhere/shared/extensions/widget_animate_extensions.dart';
import 'package:iamhere/features/profile/presentation/widgets/profile/text_field_widget.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/map_section/map_section.dart';
import 'package:iamhere/features/place/presentation/bloc/new_place_form/new_place_bloc.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/photos_section/photos_section.dart';

class PlaceForm extends StatefulWidget {
  const PlaceForm({
    super.key,
    required this.mapInteractionNotifier,
    required this.state,
  });
  final ValueNotifier<bool> mapInteractionNotifier;
  final NewPlaceState state;

  @override
  State<PlaceForm> createState() => _PlaceFormState();
}

class _PlaceFormState extends State<PlaceForm> {
  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController placeDescriptionController =
      TextEditingController();
  final TextEditingController placeCountryController = TextEditingController();
  final TextEditingController placeAddressController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    placeNameController.dispose();
    placeDescriptionController.dispose();
    placeCountryController.dispose();
    placeAddressController.dispose();
    super.dispose();
  }

  void _validateAndScroll() {
    // validateGranularly возвращает Set<FormFieldState> с полями, где есть ошибки
    final invalidFields = _formKey.currentState?.validateGranularly();

    if (invalidFields != null && invalidFields.isNotEmpty) {
      // Берем первое поле с ошибкой и прокручиваем к нему
      Scrollable.ensureVisible(
        invalidFields.first.context,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.01,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<NewPlaceBloc>();

    final isLoading = widget.state is NewPlaceLoading;

    return Form(
      key: _formKey,
      child: Padding(
        padding: const .only(left: 16, right: 16, top: 16),
        child: Column(
          children: [
            TextFieldWidget(
              hintText: 'Place Name',
              prefixIcon: Icons.account_balance_sharp,
              controller: placeNameController,
              staggerIndex: 0,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Place Name is required';
                }
                return null;
              },
              onChanged: (value) =>
                  bloc.add(NewPlaceNameChanged(value)),
            ),
            TextFieldWidget(
              hintText: 'Place Description',
              prefixIcon: Icons.description,
              controller: placeDescriptionController,
              staggerIndex: 1,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Place Description is required';
                }
                return null;
              },
              onChanged: (value) =>
                  bloc.add(NewPlaceDescriptionChanged(value)),
            ),
            TextFieldWidget(
              hintText: 'Place Country',
              prefixIcon: Icons.public,
              controller: placeCountryController,
              staggerIndex: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Place Country is required';
                }
                return null;
              },
              onChanged: (value) =>
                  bloc.add(NewPlaceCountryChanged(value)),
            ),
            TextFieldWidget(
              hintText: 'Place Address',
              prefixIcon: Icons.location_city,
              controller: placeAddressController,
              staggerIndex: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Place Address is required';
                }
                return null;
              },
              onChanged: (value) =>
                  bloc.add(NewPlaceAddressChanged(value)),
            ),
            MapSection(
              mapInteractionNotifier: widget.mapInteractionNotifier,
              onCoordinatesSelected: (lat, lon) => bloc.add(
                NewPlaceCoordinatesChanged(
                  latitude: lat,
                  longitude: lon,
                ),
              ),
            ),
            const SizedBox(height: 16),
            PhotosSection(state: widget.state),
            TextButton(
              onPressed: () {
                _validateAndScroll();
                if (_formKey.currentState?.validate() ?? false) {
                  bloc.add(NewPlaceSubmitted());
                }
              },
              style: TextButton.styleFrom(
                padding: .symmetric(horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                textStyle: TextStyle(fontSize: 14, fontWeight: .normal),
                foregroundColor: Colors.white,
                backgroundColor: isLoading ? Colors.black26 : Colors.blue,
              ),
              child: Text(isLoading ? 'Creating...' : 'Create Place'),
            ).formFieldAnimate(staggerIndex: 5),
            SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
