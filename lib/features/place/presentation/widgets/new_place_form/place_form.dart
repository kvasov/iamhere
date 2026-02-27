import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:iamhere/shared/extensions/widget_animate_extensions.dart';
import 'package:iamhere/features/profile/presentation/widgets/profile/text_field_widget.dart';
import 'package:iamhere/shared/utils/geolocator.dart';
import 'package:iamhere/shared/data/geo/datasources/remote/geo_remote_datasource.dart';

class PlaceForm extends StatefulWidget {
  const PlaceForm({super.key});

  @override
  State<PlaceForm> createState() => _PlaceFormState();
}

class _PlaceFormState extends State<PlaceForm> {
  final TextEditingController placeNameController = TextEditingController();
  final TextEditingController placeDescriptionController = TextEditingController();
  final TextEditingController placeCountryController = TextEditingController();
  final TextEditingController placeAddressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
            ),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text('Coordinates', style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
                SizedBox(height: 8),
                Row(
                  spacing: 0,
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () async {
                        debugPrint('Моё местоположение');
                        final position = await determinePosition();
                        debugPrint('📍📍📍 Position: $position');
                        // final address = await GeoRemoteDataSourceImpl().getAddressByCoordinates(position.latitude.toString(), position.longitude.toString());
                        // debugPrint('Address: ${address['response']['GeoObjectCollection']['featureMember'][0]['GeoObject']['metaDataProperty']['GeocoderMetaData']['text']}');
                      },
                      child: Text('Моё местоположение'),
                      style: TextButton.styleFrom(
                        padding: .symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: TextStyle(fontSize: 14, fontWeight: .normal),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                      debugPrint('Выбрать на карте');
                      },
                      child: Text('Выбрать на карте'),
                      style: TextButton.styleFrom(
                        padding: .symmetric(horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        textStyle: TextStyle(fontSize: 14, fontWeight: .normal),
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                  ],
                )
              ]
            ).formFieldAnimate(staggerIndex: 4),
            SizedBox(height: 16),
            GFButton(
              text: 'Create Place',
              color: GFColors.PRIMARY,
              onPressed: () {
                debugPrint('Create Place');
              },
            ).formFieldAnimate(staggerIndex: 5),
          ],
        ),
      ),
    );
  }
}