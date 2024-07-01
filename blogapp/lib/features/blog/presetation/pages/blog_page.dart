import 'package:blogapp/core/common/entities/widget/loader.dart';
import 'package:blogapp/core/theme/app_pallete.dart';
import 'package:blogapp/core/utills/show_snac_bar.dart';
import 'package:blogapp/features/blog/presetation/bloc/blog_bloc_bloc.dart';
import 'package:blogapp/features/blog/presetation/pages/new_blog_page.dart';
import 'package:blogapp/features/blog/presetation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const BlogPage(),
      );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    super.initState();
    context.read<BlogBlocBloc>().add(GetallBlog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, NewBlogPage.route());
              },
              icon: const Icon(CupertinoIcons.add_circled))
        ],
      ),
      body: Column(
        children: [
          BlocConsumer<BlogBlocBloc, BlogBlocState>(
            listener: (context, state) {
              if (state is BlogError) {
                showSnacBar(context, state.error);
              }
            },
            builder: (context, state) {
              if (state is BlogLoading) {
                return const Loader();
              }
              if (state is BlogDisplayeSuccess) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.blogs.length,
                    itemBuilder: (context, index) {
                      final blog = state.blogs[index];
                      return BlogCard(
                        blog: blog,
                        color: index % 3 == 0
                            ? AppPallete.gradient1
                            : index % 3 == 1
                                ? AppPallete.gradient2
                                : AppPallete.gradient3,
                      );
                    },
                  ),
                );
              }

              return const SizedBox();
            },
          )
        ],
      ),
    );
  }
}
