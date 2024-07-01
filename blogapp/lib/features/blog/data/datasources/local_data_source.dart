import '../model/blog_model.dart';
import 'package:hive/hive.dart';

abstract interface class BlogLocalDataSource {
  void uploadLoacalBlogs({required List<BlogModel> blogs});
  List<BlogModel> loadBlogs();
}

class BlogLocalDataSourceImpl implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImpl(this.box);
  @override
  void uploadLoacalBlogs({required List<BlogModel> blogs}) {
    box.clear();
    box.write(
      () {
        for (int i = 0; i < blogs.length; i++) {
          box.put(i.toString(), blogs[i].toMap());
        }
      },
    );
  }

  @override
  List<BlogModel> loadBlogs() {
    List<BlogModel> blogs = [];
    box.read(
      () {
        for (int i = 0; i < box.length; i++) {
          blogs.add(BlogModel.fromMap(box.get(i.toString())));
        }
      },
    );
    return blogs;
  }
}
