import 'package:blogapp/core/error/failure.dart';
import 'package:blogapp/core/usecase/usecase.dart';
import 'package:blogapp/features/blog/domain/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/blog_repository.dart';

class GetAllBlogs implements UseCase<List<Blog>, NoParamas> {
  final BlogRepository blogRepository;

  GetAllBlogs({
    required this.blogRepository,
  });
  @override
  Future<Either<AppFailure, List<Blog>>> call(NoParamas params) async {
    return await blogRepository.getAllBlog();
  }
}

class NoParamas {}
