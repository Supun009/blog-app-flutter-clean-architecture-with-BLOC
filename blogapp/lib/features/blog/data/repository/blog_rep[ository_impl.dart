import 'dart:io';
import 'package:blogapp/core/network/connection_checker.dart';
import 'package:blogapp/features/blog/data/datasources/local_data_source.dart';
import 'package:fpdart/fpdart.dart';
import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blogapp/features/blog/data/model/blog_model.dart';
import 'package:blogapp/features/blog/domain/domain/entities/blog.dart';
import 'package:blogapp/features/blog/domain/domain/repository/blog_repository.dart';
import '../../../auth/data/datasourses/auth_local_data_source.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final AuthLcalDataSource authLcalDataSource;
  final BlogLocalDataSource blogLocalDataSource;
  final Connectionchecker connectionchecker;

  BlogRepositoryImpl({
    required this.blogRemoteDataSource,
    required this.authLcalDataSource,
    required this.blogLocalDataSource,
    required this.connectionchecker,
  });
  @override
  Future<Either<AppFailure, Blog>> uploadBlog({
    required List<String> topics,
    required String title,
    required String content,
    required String posterId,
    required File image,
  }) async {
    try {
      if (!await (connectionchecker.isconnected)) {
        return Left(AppFailure("No internet connection"));
      }
      final token = authLcalDataSource.getToken();

      if (token == null) {
        return Left(AppFailure("No token found"));
      }
      BlogModel blogModel = BlogModel(
          id: '',
          title: title,
          topic: topics,
          content: content,
          imageUrl: '',
          posterId: posterId,
          updatedAt: DateTime.now());

      return await blogRemoteDataSource.uploadBlog(blogModel, image, token);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<Blog>>> getAllBlog() async {
    try {
      if (!await (connectionchecker.isconnected)) {
        final blogs = blogLocalDataSource.loadBlogs();
        return right(blogs);
      }
      final token = authLcalDataSource.getToken();
      if (token == null) {
        return Left(AppFailure("No token found"));
      }
      final blogs = await blogRemoteDataSource.getAllBlogs(token);
      blogs.fold((l) => AppFailure(l.message),
          (r) => blogLocalDataSource.uploadLoacalBlogs(blogs: r));
      return blogs;
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
