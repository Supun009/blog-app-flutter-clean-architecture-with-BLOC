import 'package:blogapp/core/utills/calculate_reading_time.dart';
import 'package:blogapp/core/utills/format_dat.dart';
import 'package:blogapp/features/blog/domain/domain/entities/blog.dart';
import 'package:flutter/material.dart';

class BlogViewPage extends StatelessWidget {
  final Blog blog;
  static route(Blog blog) => MaterialPageRoute(
        builder: (context) => BlogViewPage(
          blog: blog,
        ),
      );
  const BlogViewPage({
    super.key,
    required this.blog,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatdateBydMMMYYYY(blog.updatedAt)),
                    Text('${calculateReadingtime(blog.content)} mins'),
                  ],
                ),
                const SizedBox(height: 15),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(blog.imageUrl),
                ),
                const SizedBox(height: 15),
                Text(
                  blog.content,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w300, height: 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
