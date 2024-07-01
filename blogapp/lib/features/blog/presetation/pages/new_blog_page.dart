import 'dart:io';

import 'package:blogapp/core/common/entities/widget/loader.dart';
import 'package:blogapp/core/theme/app_pallete.dart';
import 'package:blogapp/core/utills/show_snac_bar.dart';
import 'package:blogapp/features/blog/presetation/bloc/blog_bloc_bloc.dart';
import 'package:blogapp/features/blog/presetation/pages/blog_page.dart';
import 'package:blogapp/features/blog/presetation/widgets/blog_editor.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utills/pick_files.dart';

class NewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const NewBlogPage(),
      );
  const NewBlogPage({super.key});

  @override
  State<NewBlogPage> createState() => _NewBlogPageState();
}

class _NewBlogPageState extends State<NewBlogPage> {
  final TextEditingController blogcontroller = TextEditingController();
  final TextEditingController titlecontroller = TextEditingController();
  List<String> selectedTopic = [];
  final formkey = GlobalKey<FormState>();
  File? image;

  void selectImage() async {
    final pickedImage = await picImage();
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    blogcontroller.dispose();
    titlecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                if (formkey.currentState!.validate() &&
                    selectedTopic.isNotEmpty &&
                    image != null) {
                  context.read<BlogBlocBloc>().add(
                        BlogUpload(
                            postId: '',
                            title: titlecontroller.text,
                            topics: selectedTopic,
                            content: blogcontroller.text,
                            image: image!),
                      );
                }
              },
              icon: const Icon(Icons.done_rounded))
        ],
      ),
      body: BlocConsumer<BlogBlocBloc, BlogBlocState>(
        listener: (context, state) {
          if (state is BlogError) {
            showSnacBar(context, state.error);
          } else if (state is BlogSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: selectImage,
                            child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                          )
                        : GestureDetector(
                            onTap: selectImage,
                            child: DottedBorder(
                                color: AppPallete.borderColor,
                                dashPattern: const [10, 4],
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                strokeCap: StrokeCap.round,
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  child: const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(height: 15),
                                      Text(
                                        'Select your image',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                    const SizedBox(height: 20),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                          children: [
                        'Technology',
                        'Programming',
                        'Business',
                        'Entertaintment',
                      ]
                              .map(
                                (e) => Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      if (selectedTopic.contains(e)) {
                                        selectedTopic.remove(e);
                                      } else {
                                        selectedTopic.add(e);
                                      }
                                      setState(() {});
                                    },
                                    child: Chip(
                                      label: Text(e),
                                      color: selectedTopic.contains(e)
                                          ? const WidgetStatePropertyAll(
                                              AppPallete.gradient1)
                                          : null,
                                      side: const BorderSide(
                                        color: AppPallete.borderColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList()),
                    ),
                    const SizedBox(height: 20),
                    BlogEditor(
                        controller: titlecontroller, hintText: 'Enter title'),
                    const SizedBox(height: 20),
                    BlogEditor(
                        controller: blogcontroller, hintText: 'Enter content'),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
