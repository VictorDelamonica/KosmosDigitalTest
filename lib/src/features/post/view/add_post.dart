// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosmos_digital_test/src/core/components/custom_button.dart';
import 'package:kosmos_digital_test/src/core/components/custom_text_field.dart';
import 'package:kosmos_digital_test/src/features/connections/provider/user_provider.dart';
import 'package:kosmos_digital_test/src/features/post/model/post_model.dart';
import 'package:kosmos_digital_test/src/features/post/provider/post_provider.dart';

class AddPost extends ConsumerStatefulWidget {
  const AddPost({super.key});

  @override
  ConsumerState<AddPost> createState() => _AddPostState();
}

class _AddPostState extends ConsumerState<AddPost> {
  File? _profilePicture;
  final PageController _pageController = PageController();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var posts = ref.watch(postProvider.notifier);
    var user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary),
      body: PageView(
        controller: _pageController,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                Text(
                  "Choisissez une image",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(8),
                  dashPattern: [8, 4],
                  color: Colors.grey,
                  strokeWidth: 2,
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.65,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        _profilePicture = await showModalBottomSheet<File>(
                          context: context,
                          builder: (_) {
                            return Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 16,
                                children: [
                                  CustomButton(
                                    onPressed: () {
                                      final ImagePicker picker = ImagePicker();
                                      picker
                                          .pickImage(
                                            source: ImageSource.gallery,
                                          )
                                          .then((pickedFile) {
                                            if (pickedFile != null) {
                                              Navigator.pop(
                                                // ignore: use_build_context_synchronously
                                                context,
                                                File(pickedFile.path),
                                              );
                                            }
                                          });
                                    },
                                    text: "Depuis la galerie",
                                  ),
                                  CustomButton(
                                    onPressed: () async {
                                      final ImagePicker picker = ImagePicker();
                                      final XFile? pickedFile = await picker
                                          .pickImage(
                                            source: ImageSource.camera,
                                          );
                                      if (pickedFile != null) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              if (!mounted) return;
                                              Navigator.pop(
                                                context,
                                                File(pickedFile.path),
                                              );
                                            });
                                      }
                                    },
                                    text: "Prendre une photo",
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                        setState(() {});
                      },
                      child: _profilePicture?.path != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(_profilePicture!.path),
                                height: 108,
                                width: double.infinity,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : SizedBox(
                              height: 108,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      color: Colors.grey,
                                    ),
                                    Text(
                                      "Appuyez pour choisir une photo",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
                CustomButton(
                  text: "Suivant",
                  onPressed: _profilePicture == null
                      ? null
                      : () {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 24,
              children: [
                Text(
                  "Ajouter une description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                CustomTextField(
                  textController: _textController,
                  hintText: "Décrivez votre post...",
                  height: MediaQuery.of(context).size.height * 0.65,
                  onChanged: (value) {
                    setState(() {
                      _textController.text = value;
                    });
                  },
                ),
                CustomButton(
                  text: "Publier",
                  onPressed: _textController.text.isEmpty
                      ? null
                      : () {
                          posts.addPost(
                            PostModel(
                              id: DateTime.now().toString(),
                              title: user.firstName,
                              content: _textController.text,
                              image: XFile(_profilePicture!.path),
                              createdAt: DateTime.now(),
                            ),
                          );
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green,
                              content: Text("Post publié avec succès !"),
                            ),
                          );
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
