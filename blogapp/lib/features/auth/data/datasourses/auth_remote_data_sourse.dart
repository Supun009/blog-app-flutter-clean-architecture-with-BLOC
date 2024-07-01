import 'dart:convert';
import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/features/auth/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthRemoteDataSourse {
  Future<Either<AppFailure, UserModel>> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<AppFailure, UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  });

  Future<Either<AppFailure, UserModel>> getUSerData({
    required String token,
  });
}

class AuthRemoteDataSourseImpl implements AuthRemoteDataSourse {
  final String baseUrl;

  AuthRemoteDataSourseImpl(
    this.baseUrl,
  );
  @override
  Future<Either<AppFailure, UserModel>> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/login'),
        body: jsonEncode(
          {
            'email': email,
            'password': password,
          },
        ),
        headers: {'Content-Type': 'application/json'},
      );

      final resbody = jsonDecode(res.body) as Map<String, dynamic>;
      SharedPreferences pref = await SharedPreferences.getInstance();

      await pref.setString('x-auth-token', resbody['token']);

      if (res.statusCode != 200) {
        return Left(AppFailure(resbody['msg']));
      }
      return Right(UserModel.fromjson(resbody));
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
      final res = await http.post(
        Uri.parse('$baseUrl/api/signup'),
        body: jsonEncode(
          {
            'name': name,
            'email': email,
            'password': password,
          },
        ),
        headers: {'Content-Type': 'application/json'},
      );

      final resbody = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode != 200) {
        return Left(AppFailure(resbody['msg']));
      }
      return Right(UserModel.fromjson(resbody));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, UserModel>> getUSerData(
      {required String token}) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );
      final resBody = jsonDecode(res.body) as Map<String, dynamic>;
      if (res.statusCode != 200) {
        return Left(AppFailure(resBody['msg']));
      }

      return Right(UserModel.fromjson(resBody));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
