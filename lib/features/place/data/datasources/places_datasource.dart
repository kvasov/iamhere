import 'package:dio/dio.dart';
import 'package:iamhere/core/di/injection_container.dart';
import 'package:iamhere/features/place/data/models/place_dto.dart';
import 'package:iamhere/features/place/domain/entities/place.dart';

abstract class PlacesRemoteDataSource {
  Future<List<PlaceModel>> getPlaces(String? token);
  Future<PlaceModel> getPlace(String? token, String placeId);
  Future<Map<String, dynamic>> createPlace(
    String? token,
    String name,
    String description,
    String country,
    String address,
    double latitude,
    double longitude,
    List<String> photos,
  );
}

class PlacesRemoteDataSourceImpl implements PlacesRemoteDataSource {
  @override
  Future<List<PlaceModel>> getPlaces(String? token) async {
    final Dio dio = sl<Dio>();
    final response = await dio.get(
      '/api/places',
      options: Options(headers: {'Authorization': 'Bearer $token'})
    );

    final List<dynamic> responseData = response.data as List<dynamic>;

    // Преобразуем JSON ответ в структурированный объект
    final responseDataPlaces = GetListPlacesResponse.fromJson(responseData);

    // return responseDataPlaces.data;

    // Маппим DTO объекты в доменные модели и возвращаем результат
    return PlacesListMapper.fromDto(responseDataPlaces.data);
  }

  @override
  Future<PlaceModel> getPlace(String? token, String placeId) async {
    // await Future.delayed(const Duration(milliseconds: 500));
    final Dio dio = sl<Dio>();
    final response = await dio.get(
      '/api/places/$placeId',
      options: Options(headers: {'Authorization': 'Bearer $token'})
    );

    return PlaceModel.fromDto(PlaceDTO.fromJson(response.data as Map<String, dynamic>));
  }

  @override
  Future<Map<String, dynamic>> createPlace(
    String? token,
    String name,
    String description,
    String country,
    String address,
    double latitude,
    double longitude,
    List<String> photos,
  ) async {
    final Dio dio = sl<Dio>();
    final formData = FormData.fromMap({
      'name': name,
      'description': description,
      'country': country,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
    });

    for (final String photoPath in photos) {
      formData.files.add(
        MapEntry(
          'photos',
          await MultipartFile.fromFile(photoPath),
        ),
      );
    }

    final response = await dio.post(
      '/api/places',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token'
        }
      ),
      data: formData,
    );

    return response.data;
  }
}

// Класс для десериализации JSON ответа от API
class GetListPlacesResponse {
  final List<PlaceDTO> data;

  const GetListPlacesResponse({required this.data});

  factory GetListPlacesResponse.fromJson(List<dynamic> json) {
    return GetListPlacesResponse(
      // Преобразуем массив data в список PlaceDTO объектов
      data: json
          .map((e) => PlaceDTO.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class PlacesListMapper {
  static List<PlaceModel> fromDto(List<PlaceDTO> dto) {
    return dto.map((e) => PlaceModel.fromDto(e)).toList();
  }
}