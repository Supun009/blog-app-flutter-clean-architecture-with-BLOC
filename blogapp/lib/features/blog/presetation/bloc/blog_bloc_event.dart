part of 'blog_bloc_bloc.dart';

@immutable
sealed class BlogBlocEvent {}

final class BlogUpload extends BlogBlocEvent {
  final String postId;
  final String title;
  final List<String> topics;
  final String content;
  final File image;

  BlogUpload({
    required this.postId,
    required this.title,
    required this.topics,
    required this.content,
    required this.image,
  });
}

final class GetallBlog extends BlogBlocEvent {}
