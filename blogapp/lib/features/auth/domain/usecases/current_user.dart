// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:blogapp/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/features/auth/domain/repository/auth_repository.dart';

class CurrentUser implements UseCase<UserModel, CurrenUserParams> {
  final AuthRepository authRepository;
  CurrentUser(this.authRepository);
  @override
  Future<Either<AppFailure, UserModel>> call(CurrenUserParams params) async {
    return await authRepository.getCurrentUser();
  }
}

class CurrenUserParams {}
