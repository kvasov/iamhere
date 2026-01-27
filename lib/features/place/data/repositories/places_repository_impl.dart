import '../datasources/places_list_datasource.dart';


import 'package:iamhere/core/result.dart';
import 'package:iamhere/features/profile/data/datasources/local/user_local_datasource.dart';
import 'package:iamhere/features/place/domain/entities/place.dart';
import 'package:iamhere/features/place/data/models/place_dto.dart';

class PlacesRepository {
  final PlacesListRemoteDataSource placesRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;

  PlacesRepository({
    required this.placesRemoteDataSource,
    required this.userLocalDataSource,
  });

  RequestOperation<List<PlaceDTO>> getPlaces() async {
    try {
      final token = await userLocalDataSource.getUserToken();
      final response = await placesRemoteDataSource.getPlaces(token);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to get places: $e'));
    }
  }

  RequestOperation<PlaceModel> getPlace(String placeId) async {
    try {
      final token = await userLocalDataSource.getUserToken();
      final response = await placesRemoteDataSource.getPlace(token, placeId);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to get place: $e'));
    }
  }
}
