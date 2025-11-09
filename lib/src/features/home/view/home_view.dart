// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosmos_digital_test/src/core/components/custom_button.dart';
import 'package:kosmos_digital_test/src/features/connections/provider/user_provider.dart';
import 'package:kosmos_digital_test/src/features/post/provider/post_provider.dart';
import 'package:kosmos_digital_test/src/features/profile/view/profile_view.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    var posts = ref.watch(postProvider);
    return Scaffold(
      body: _currentIndex == 0
          ? SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bonjour, ${user.firstName} 👋",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                  Text(
                                    "Fil d'actualité",
                                    style: TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed('/profile');
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(999),
                                  child: user.profilePicture != null
                                      ? Image.file(
                                          File(user.profilePicture!.path),
                                          height: 42,
                                          width: 42,
                                          fit: BoxFit.cover,
                                        )
                                      : Icon(
                                          Icons.account_circle,
                                          size: 42,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                              .withValues(alpha: 0.7),
                                        ),
                                ),
                              ),
                            ],
                          ),
                          Divider(),
                          Text("Récents"),
                        ],
                      ),
                    ),
                    for (var post in posts.reversed)
                      GestureDetector(
                        onTap: () {
                          Navigator.of(
                            context,
                          ).pushNamed('/post_details', arguments: post.id);
                        },
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Stack(
                                alignment: Alignment.bottomLeft,
                                children: [
                                  post.image != null
                                      ? Image.file(
                                          File(post.image!.path),
                                          width: double.infinity,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : SizedBox.shrink(),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Spacer(),
                                          IconButton(
                                            icon: Icon(
                                              Icons.menu,
                                              color: Colors.white,
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          24.0,
                                                        ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      spacing: 4,
                                                      children: [
                                                        Text(
                                                          "Que souhaitez-vous faire ?",
                                                          style: TextStyle(
                                                            color:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .onPrimary
                                                                    .withValues(
                                                                      alpha:
                                                                          0.7,
                                                                    ),
                                                          ),
                                                        ),
                                                        CustomButton(
                                                          onPressed: () {
                                                            ref
                                                                .read(
                                                                  postProvider
                                                                      .notifier,
                                                                )
                                                                .removePost(
                                                                  post.id,
                                                                );
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                          text:
                                                              "Supprimer le post",
                                                          color: Colors.red,
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                              context,
                                                            ).pop();
                                                          },
                                                          child: Text(
                                                            "Annuler",
                                                            style: TextStyle(
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .onPrimary,
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
                                      Container(
                                        height: 240,
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
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          spacing: 8,
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              child: user.profilePicture != null
                                                  ? Image.file(
                                                      File(
                                                        user
                                                            .profilePicture!
                                                            .path,
                                                      ),
                                                      height: 40,
                                                      width: 40,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Icon(
                                                      Icons.account_circle,
                                                      size: 32,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .onPrimary
                                                          .withValues(
                                                            alpha: 0.7,
                                                          ),
                                                    ),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Row(
                                                  spacing: 8,
                                                  children: [
                                                    Text(
                                                      "${user.firstName} ${user.lastName}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${DateTime.now().difference(post.createdAt).inMinutes} min",
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width:
                                                      MediaQuery.of(
                                                        context,
                                                      ).size.width -
                                                      124,
                                                  child: Text(
                                                    post.content,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            )
          : ProfileView(),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/add_post');
              },
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        backgroundColor: Theme.of(context).colorScheme.primary,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(
          context,
        ).colorScheme.onPrimary.withValues(alpha: 0.6),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}
