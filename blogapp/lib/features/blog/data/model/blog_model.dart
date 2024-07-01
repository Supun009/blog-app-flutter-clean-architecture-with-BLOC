import 'package:blogapp/features/blog/domain/domain/entities/blog.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.title,
    required super.topic,
    required super.content,
    required super.imageUrl,
    required super.posterId,
    required super.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'topic': topic,
      'content': content,
      'imageUrl': imageUrl,
      'posterId': posterId,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    List<String> topics =
        (map['topics'] as List).map((item) => item as String).toList();
    return BlogModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      topic: topics,
      content: map['content'] ?? '',
      imageUrl: map['ImageUrl'] ?? '',
      posterId: map['posterId'] ?? '',
      updatedAt: map['updatedAt'] == null
          ? DateTime.now()
          : DateTime.parse(map['updatedAt']),
    );
  }
}
