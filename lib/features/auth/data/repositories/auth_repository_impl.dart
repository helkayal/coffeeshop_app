import 'package:flutter/foundation.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/helpers/result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<User>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      return Success(userModel);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return const Error(ServerFailure('Unexpected Error'));
    }
  }

  @override
  Future<Result<User>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required String gender,
    String? state,
    String? city,
  }) async {
    try {
      final userModel = await remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
        gender: gender,
        state: state,
        city: city,
      );
      return Success(userModel);
    } on ServerException catch (e) {
      return Error(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return const Error(ServerFailure('Unexpected Error'));
    }
  }

  @override
  Future<Result<void>> logout() async {
    if (kDebugMode) {
      debugPrint('[Auth] logout() stub — session token not cleared');
    }
    return const Success(null);
  }

  @override
  Future<Result<User?>> getCachedUser() async {
    return const Success(null);
  }
}
