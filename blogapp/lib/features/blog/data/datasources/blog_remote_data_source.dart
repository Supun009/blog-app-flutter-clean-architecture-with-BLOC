import 'dart:convert';
import 'dart:io';

import 'package:blogapp/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

import '../model/blog_model.dart';
import 'package:http/http.dart' as http;

abstract interface class BlogRemoteDataSource {
  Future<Either<AppFailure, BlogModel>> uploadBlog(
    BlogModel blog,
    File imageFile,
    String token,
  );

  Future<Either<AppFailure, List<BlogModel>>> getAllBlogs(
    String token,
  );
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final String baseUrl;

  BlogRemoteDataSourceImpl({required this.baseUrl});
  @override
  Future<Either<AppFailure, BlogModel>> uploadBlog(
    BlogModel blog,
    File imageFile,
    String token,
  ) async {
    try {
      final request =
          http.MultipartRequest('POST', Uri.parse('$baseUrl/api/upload'));
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
      ));

      request.fields['title'] = blog.title;
      request.fields['content'] = blog.content;
      request.fields['topic'] = blog.topic.join(',');

      // Add headers here
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        "x-auth-token": token, // Example header
      });

      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);

      final resbody = jsonDecode(res.body) as Map<String, dynamic>;

      if (res.statusCode != 200) {
        return Left(AppFailure(resbody['msg']));
      }
      return Right(BlogModel.fromMap(resbody['savedBlog']));
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<BlogModel>>> getAllBlogs(
    String token,
  ) async {
    try {
      final res = await http.get(
        Uri.parse('$baseUrl/list'),
        headers: {
          "Content-Type": "Application/json",
          "x-auth-token": token,
        },
      );

      if (res.statusCode != 200) {
        return Left(AppFailure("Cant get blogs"));
      }
      var blogs = jsonDecode(res.body) as List;

      List<BlogModel> blogList = [];
      for (final blog in blogs) {
        blogList.add(BlogModel.fromMap(blog));
      }

      return Right(blogList);
    } catch (e) {
      return Left(AppFailure(e.toString()));
    }
  }
}
