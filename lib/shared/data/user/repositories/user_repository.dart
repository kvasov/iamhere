import 'package:flutter/foundation.dart';

import '../datasources/local/user_local_datasource.dart';
import '../datasources/remote/user_remote_datasource.dart';
import 'package:iamhere/shared/data/fcm/fcm_local_datasource.dart';
import 'package:iamhere/core/result.dart';

class UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;
  final FcmLocalDataSource fcmLocalDataSource;

  UserRepository({
    required this.userRemoteDataSource,
    required this.userLocalDataSource,
    required this.fcmLocalDataSource,
  });

  RequestOperation<Map<String, dynamic>> signIn({
    required String login,
    required String password,
  }) async {
    // final isConnected = await networkInfo.isConnected;
    // if (!isConnected) {
    //   return Result.error(Failure(description: 'No internet connection'));
    // }
    try {
      final response = await userRemoteDataSource.signIn(login, password);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to sign in: $e'));
    }
  }

  RequestOperation<Map<String, dynamic>> signUp({
    required String name,
    required String login,
    required String email,
    required String password,
    required String photoPath,
  }) async {
    // final isConnected = await networkInfo.isConnected;
    // if (!isConnected) {
    //   return Result.error(Failure(description: 'No internet connection'));
    // }
    try {
      final response = await userRemoteDataSource.signUp(name, login, email, password, photoPath);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to sign up: $e'));
    }
  }

  RequestOperation<bool> saveUserToken({
    required String token,
  }) async {
    try {
      await userLocalDataSource.saveUserToken(token);
      return Result.ok(true);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to save token: $e'));
    }
  }

  RequestOperation<bool> signOut() async {
    try {
      final token = await userLocalDataSource.getUserToken();
      await userLocalDataSource.deleteUserToken();
      if (token == null) {
        return Result.error(Failure(description: 'No token found'));
      }
      await userRemoteDataSource.signOut(token);
      return Result.ok(true);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to sign out: $e'));
    }
  }

  Future<String?> getUserToken() async {
    try {
      return await userLocalDataSource.getUserToken();
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserInfo() async {
    try {
      final token = await userLocalDataSource.getUserToken();
      if (token == null) {
        return null;
      }
      final response = await userRemoteDataSource.getUserInfo(token);
      // debugPrint('🤍‼️ UserRepository getUserInfo - response: $response');
      return response;
    } catch (e) {

      return {"error": e.toString()};
    }
  }

  Future<void> deleteToken() async {
    try {
      final token = await userLocalDataSource.getUserToken();
      await userLocalDataSource.deleteUserToken();
      if (token == null) {
        throw Exception('No token found');
      }
      await userRemoteDataSource.signOut(token);
    } catch (e) {
      throw Exception('Failed to delete token: $e');
    }
  }

  RequestOperation<Map<String, dynamic>> updateUserInfo({
    required String userId,
    required String name,
    required String password,
    required String passwordConfirm,
    String? photoPath,
  }) async {
    final token = await userLocalDataSource.getUserToken();
    if (token == null) {
      return Result.error(Failure(description: 'No token found'));
    }
    try {
      final response = await userRemoteDataSource.updateUserInfo(token, userId, name, password, passwordConfirm, photoPath: photoPath);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to update user info: $e'));
    }
  }

  RequestOperation<Map<String, dynamic>> getUserInfoById({
    required int userId,
  }) async {
    try {
      final token = await userLocalDataSource.getUserToken();
      if (token == null) {
        return Result.error(Failure(description: 'No token found'));
      }
      final response = await userRemoteDataSource.getUserInfoById(token, userId);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to get user info by id: $e'));
    }
  }

  RequestOperation<Map<String, dynamic>> subscribeToUser({
    required int userId,
  }) async {
    final token = await userLocalDataSource.getUserToken();
    if (token == null) {
      return Result.error(Failure(description: 'No token found'));
    }
    try {
      final response = await userRemoteDataSource.subscribeToUser(token, userId);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: e.toString()));
    }
  }

  RequestOperation<Map<String, dynamic>> unSubscribeFromUser({
    required int userId,
  }) async {
    debugPrint('🤍‼️ UserRepository unSubscribeFromUser - userId: $userId');
    final token = await userLocalDataSource.getUserToken();
    if (token == null) {
      return Result.error(Failure(description: 'No token found'));
    }
    try {
      final response = await userRemoteDataSource.unSubscribeFromUser(token, userId);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: e.toString()));
    }
  }

  RequestOperation<Map<String, dynamic>> checkSubscription({
    required int followedId,
  }) async {
    final token = await userLocalDataSource.getUserToken();
    if (token == null) {
      return Result.error(Failure(description: 'No token found'));
    }
    try {
      final response = await userRemoteDataSource.checkSubscription(token, followedId);
      return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: e.toString()));
    }
  }

  RequestOperation<Map<String, dynamic>> updateUserFcmToken() async {
    final fcmToken = await fcmLocalDataSource.getFcmToken();
    if (fcmToken == null) {
      return Result.error(Failure(description: 'No fcm token found'));
    }
    final token = await userLocalDataSource.getUserToken();
    if (token == null) {
      return Result.error(Failure(description: 'No token found'));
    }
    try {
      final response = await userRemoteDataSource.updateUserFcmToken(token, fcmToken);
        return Result.ok(response);
    } catch (e) {
      return Result.error(Failure(description: 'Failed to update user fcm token: $e'));
    }
  }

  // @override
  // Future<Either<Failure, bool>> isAuthenticated() async {
  //   try {
  //     final token = await authLocalDataSource.getCachedToken();
  //     return Right(token != null);
  //   } catch (e) {
  //     return Left(CacheFailure());
  //   }
  // }

  // @override
  // Future<Either<Failure, UserEntity>> login({
  //   required String email,
  //   required String password,
  // }) async {
  //   try {
  //     final user = await authRemoteDataSource.login(email, password);
  //     await authLocalDataSource.cacheToken('mock_token_${user.id}');
  //     await authLocalDataSource.cacheUser(user);
  //     return Right(user);
  //   } on InvalidCredentialsException {
  //     return Left(InvalidCredentialsFailure());
  //   } on ServerException {
  //     return Left(ServerFailure());
  //   } catch (e) {
  //     return Left(ServerFailure());
  //   }
  // }

  // @override
  // Future<Either<Failure, void>> logout() async {
  //   try {
  //     await authRemoteDataSource.logout();
  //     await authLocalDataSource.clearToken();
  //     return Right(null);
  //   } catch (e) {
  //     return Left(ServerFailure());
  //   }
  // }
}
