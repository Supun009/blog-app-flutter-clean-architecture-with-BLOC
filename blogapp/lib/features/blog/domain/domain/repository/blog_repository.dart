import 'dart:io';
import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/features/blog/domain/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<AppFailure, Blog>> uploadBlog({
    required List<String> topics,
    required String title,
    required String content,
    required String posterId,
    required File image,
  });

  Future<Either<AppFailure, List<Blog>>> getAllBlog();
}
