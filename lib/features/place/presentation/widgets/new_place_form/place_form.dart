import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iamhere/shared/extensions/widget_animate_extensions.dart';
import 'package:iamhere/features/profile/presentation/widgets/profile/text_field_widget.dart';
import 'package:iamhere/features/place/presentation/widgets/new_place_form/map_section/map_section.dart';
import 'package:iamhere/features/place/presentation/bloc/new_place_form/new_place_bloc.dart';

class PlaceForm extends StatefulWidget {
  const PlaceForm({super.key, required this.mapInteractionNotifier});
  final ValueNotifier<bool> mapInteractionNotifier;

  @override
  State<PlaceForm> createState() => _PlaceFormState();
}

class _PlaceFormState extends State<PlaceForm> {
  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController placeDescriptionController =
      TextEditingController();
  final TextEditingController placeCountryController = TextEditingController();
  final TextEditingController placeAddressController = TextEditingController();

  @override
  void dispose() {
    placeNameController.dispose();
    placeDescriptionController.dispose();
    placeCountryController.dispose();
    placeAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final bloc = context.read<NewPlaceBloc>();

    return BlocConsumer<NewPlaceBloc, NewPlaceState>(
      listener: (context, state) {
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
        return Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 200),
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
                GFButton(
                  text: state is NewPlaceLoading ? 'Создание...' : 'Create Place',
                  color: GFColors.PRIMARY,
                  onPressed: state is NewPlaceLoading
                      ? null
                      : () {
                          if (formKey.currentState?.validate() ?? false) {
                            bloc.add(NewPlaceSubmitted());
                          }
                        },
                ).formFieldAnimate(staggerIndex: 5),
              ],
            ),
          ),
        );
      },
    );
  }
}
