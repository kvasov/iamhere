
import '../datasources/local/user_local_datasource.dart';
import '../datasources/remote/user_remote_datasource.dart';
import 'package:iamhere/core/result.dart';

class UserRepository {
  final UserRemoteDataSource userRemoteDataSource;
  final UserLocalDataSource userLocalDataSource;

  UserRepository({
    required this.userRemoteDataSource,
    required this.userLocalDataSource,
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
  }) async {
    // final isConnected = await networkInfo.isConnected;
    // if (!isConnected) {
    //   return Result.error(Failure(description: 'No internet connection'));
    // }
    try {
      final response = await userRemoteDataSource.signUp(name, login, email, password);
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
      await userLocalDataSource.removeUserToken();
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
      return response;
    } catch (e) {
      return null;
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
