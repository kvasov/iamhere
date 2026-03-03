import 'package:flutter/material.dart';
import '../datasources/places_datasource.dart';
import 'package:iamhere/core/result.dart';
import 'package:iamhere/shared/data/user/datasources/local/user_local_datasource.dart';
import 'package:iamhere/features/place/domain/entities/place.dart';

class PlacesRepository {
  final PlacesRemoteDataSource placesRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;

  PlacesRepository({
    required this.placesRemoteDataSource,
    required this.userLocalDataSource,
  });

  RequestOperation<List<PlaceModel>> getPlaces() async {
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
      debugPrint('error 💚🤍: $e');
      return Result.error(Failure(description: 'Failed to get place: $e'));
    }
  }

  RequestOperation<Map<String, dynamic>> createPlace(
    {
      required String name,
      required String description,
      required String country,
      required String address,
      required double latitude,
      required double longitude,
      required List<String> photos,
    }
  ) async {
    try {
      final token = await userLocalDataSource.getUserToken();
      final response = await placesRemoteDataSource.createPlace(
        token,
        name,
        description,
        country,
        address,
        latitude,
        longitude,
        photos,
      );
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to create place: $e'));
    }
  }
}
