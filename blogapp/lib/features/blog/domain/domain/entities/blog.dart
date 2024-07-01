class Blog {
  final String id;
  final String title;
  final List<String> topic;
  final String content;
  final String imageUrl;
  final String posterId;
  final DateTime updatedAt;

  Blog({
    required this.id,
    required this.title,
    required this.topic,
    required this.content,
    required this.imageUrl,
    required this.posterId,
    required this.updatedAt,
  });
}
