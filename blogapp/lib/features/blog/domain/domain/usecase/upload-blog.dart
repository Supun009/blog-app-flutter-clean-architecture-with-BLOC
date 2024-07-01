import 'dart:io';
import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/features/blog/domain/domain/entities/blog.dart';
import 'package:blogapp/features/blog/domain/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog({
    required this.blogRepository,
  });
  @override
  Future<Either<AppFailure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      topics: params.topics,
      title: params.title,
      content: params.content,
      posterId: params.postId,
      image: params.image,
    );
  }
}

class UploadBlogParams {
  final String postId;
  final String title;
  final List<String> topics;
  final String content;
  final File image;

  UploadBlogParams({
    required this.postId,
    required this.title,
    required this.topics,
    required this.content,
    required this.image,
  });
}
