import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/core/network/connection_checker.dart';
import 'package:blogapp/features/auth/data/datasourses/auth_local_data_source.dart';
import 'package:blogapp/features/auth/data/datasourses/auth_remote_data_sourse.dart';
import 'package:blogapp/features/auth/data/models/user_model.dart';
import 'package:blogapp/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSourse authRemoteDataSourse;
  final AuthLcalDataSource authLcalDataSource;
  final Connectionchecker connectionchecker;
  AuthRepositoryImpl({
    required this.authRemoteDataSourse,
    required this.authLcalDataSource,
    required this.connectionchecker,
  });
  @override
  Future<Either<AppFailure, UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await (connectionchecker.isconnected)) {
        return Left(AppFailure('No internet connection'));
      }
      return authRemoteDataSourse.loginWithEmailPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, UserModel>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      return await authRemoteDataSourse.signUpWithEmailPassword(
        name: name,
        email: email,
        password: password,
      );
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, UserModel>> getCurrentUser() async {
    try {
      if (!await (connectionchecker.isconnected)) {
        return Left(AppFailure('No internet connection'));
      }
      final token = authLcalDataSource.getToken();

      if (token == null) {
        return Left(AppFailure("No token found"));
      }
      return await authRemoteDataSourse.getUSerData(token: token);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
