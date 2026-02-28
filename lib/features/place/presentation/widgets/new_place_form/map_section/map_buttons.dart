import 'package:flutter/material.dart';
// import 'package:iamhere/shared/utils/geolocator.dart';

class MapButtons extends StatelessWidget {
  const MapButtons({
    super.key,
    required this.modeLocationManually,
    required this.setModeLocationManually,
  });

  final bool modeLocationManually;
  final Function(bool) setModeLocationManually;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 0,
      mainAxisAlignment: .spaceBetween,
      children: [
        TextButton(
          onPressed: () async {
            setModeLocationManually(false);
            // final position = await determinePosition();
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
            backgroundColor: modeLocationManually == false ? Colors.black : Colors.black26,
          ),
        ),
        TextButton(
          onPressed: () {
            setModeLocationManually(true);
          },
          style: TextButton.styleFrom(
            padding: .symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            textStyle: TextStyle(fontSize: 14, fontWeight: .normal),
            foregroundColor: Colors.white,
            backgroundColor: modeLocationManually == true ? Colors.black : Colors.black26,
          ),
          child: Text('Выбрать на карте'),
        ),
      ],
    );
  }
}