import 'dart:io';
import 'package:blogapp/features/blog/domain/domain/usecase/get_all_blogs.dart';
import 'package:blogapp/features/blog/domain/domain/usecase/upload-blog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/domain/entities/blog.dart';
part 'blog_bloc_event.dart';
part 'blog_bloc_state.dart';

class BlogBlocBloc extends Bloc<BlogBlocEvent, BlogBlocState> {
  final UploadBlog uploadBlog;
  final GetAllBlogs getAllBlogs;
  BlogBlocBloc({
    required this.uploadBlog,
    required this.getAllBlogs,
  }) : super(BlogBlocInitial()) {
    on<BlogBlocEvent>((event, emit) {
      emit(BlogLoading());
    });
    on<BlogUpload>(_blogUpload);
    on<GetallBlog>(_getAllBlogs);
  }

  void _blogUpload(BlogUpload event, Emitter<BlogBlocState> emit) async {
    final res = await uploadBlog.call(UploadBlogParams(
      postId: event.postId,
      title: event.title,
      topics: event.topics,
      content: event.content,
      image: event.image,
    ));

    res.fold(
        (l) => emit(BlogError(l.toString())),
        (r) => emit(
              BlogSuccess(),
            ));
  }

  void _getAllBlogs(
    GetallBlog event,
    Emitter<BlogBlocState> emit,
  ) async {
    final res = await getAllBlogs.call(NoParamas());
    res.fold((l) => emit(BlogError(l.message)),
        (r) => emit(BlogDisplayeSuccess(blogs: r)));
  }
}
