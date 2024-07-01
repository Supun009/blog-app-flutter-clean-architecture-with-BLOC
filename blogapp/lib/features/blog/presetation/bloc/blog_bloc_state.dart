part of 'blog_bloc_bloc.dart';

@immutable
sealed class BlogBlocState {}

final class BlogBlocInitial extends BlogBlocState {}

final class BlogLoading extends BlogBlocState {}

final class BlogDisplayeSuccess extends BlogBlocState {
  final List<Blog> blogs;

  BlogDisplayeSuccess({
    required this.blogs,
  });
}

final class BlogSuccess extends BlogBlocState {}

final class BlogError extends BlogBlocState {
  final String error;
  BlogError(this.error);
}
