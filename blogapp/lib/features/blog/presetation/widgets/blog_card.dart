import 'package:blogapp/core/utills/calculate_reading_time.dart';
import 'package:blogapp/features/blog/domain/domain/entities/blog.dart';
import 'package:blogapp/features/blog/presetation/pages/blog_view_page.dart';
import 'package:flutter/material.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewPage.route(blog));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: blog.topic
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Chip(label: Text(e)),
                            ),
                          )
                          .toList()),
                ),
                Text(
                  blog.title,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Text('${calculateReadingtime(blog.content)} min'),
          ],
        ),
      ),
    );
  }
}
