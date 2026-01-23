import '../datasources/places_list.dart';
import '../models/place.dart';
import 'package:iamhere/core/result.dart';
import 'package:iamhere/features/profile/data/datasources/local/user_local_datasource.dart';

class PlacesRepository {
  final PlacesListRemoteDataSource placesRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;

  PlacesRepository({
    required this.placesRemoteDataSource,
    required this.userLocalDataSource,
  });

  RequestOperation<List<Place>> getPlaces() async {
    try {
      final token = await userLocalDataSource.getUserToken();
      final response = await placesRemoteDataSource.getPlaces(token);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to get places: $e'));
    }
  }

  RequestOperation<Place> getPlace(String placeId) async {
    try {
      final token = await userLocalDataSource.getUserToken();
      final response = await placesRemoteDataSource.getPlace(token, placeId);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to get place: $e'));
    }
  }
}
