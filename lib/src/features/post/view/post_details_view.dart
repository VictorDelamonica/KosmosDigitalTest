// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosmos_digital_test/src/core/components/custom_button.dart';
import 'package:kosmos_digital_test/src/features/connections/provider/user_provider.dart';
import 'package:kosmos_digital_test/src/features/post/provider/post_provider.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final String postId;
  const PostDetailsView(this.postId, {super.key});

  @override
  ConsumerState<PostDetailsView> createState() => _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    var post = ref
        .watch(postProvider)
        .where((p) => p.id == widget.postId)
        .first;
    var user = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withValues(alpha: 0.5),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        CustomButton(
                          onPressed: () {
                            ref
                                .read(postProvider.notifier)
                                .removePost(widget.postId);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          },
                          text: "Supprimer le post",
                          color: Colors.red,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            "Annuler",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          SizedBox(
            height: double.infinity,
            child: Image.file(File(post.image!.path), fit: BoxFit.cover),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(0),
                  Colors.black.withAlpha(255),
                ],
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 8,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: user.profilePicture != null
                        ? Image.file(
                            File(user.profilePicture!.path),
                            height: 40,
                            width: 40,
                            fit: BoxFit.cover,
                          )
                        : Icon(
                            Icons.account_circle,
                            size: 32,
                            color: Colors.grey,
                          ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        spacing: 8,
                        children: [
                          Text(
                            "${user.firstName} ${user.lastName}",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            "${DateTime.now().difference(post.createdAt).inMinutes} min",
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          post.content,
                          maxLines: 999,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
