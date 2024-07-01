import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/features/auth/data/models/user_model.dart';
import 'package:blogapp/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<UserModel, UserSignUpParams> {
  final AuthRepository authRepository;

  UserSignUp(this.authRepository);
  @override
  Future<Either<AppFailure, UserModel>> call(UserSignUpParams params) async {
    return await authRepository.signUpWithEmailPassword(
      name: params.name,
      email: params.email,
      password: params.password,
    );
  }
}

class UserSignUpParams {
  final String email;
  final String name;
  final String password;

  UserSignUpParams({
    required this.email,
    required this.name,
    required this.password,
  });
}
