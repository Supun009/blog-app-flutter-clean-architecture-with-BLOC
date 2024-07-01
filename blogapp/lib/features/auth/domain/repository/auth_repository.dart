import 'package:blogapp/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';

abstract interface class AuthRepository {
  Future<Either<AppFailure, UserModel>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<AppFailure, UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<AppFailure, UserModel>> getCurrentUser();
}
