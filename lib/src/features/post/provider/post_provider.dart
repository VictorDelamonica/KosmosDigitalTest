// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter_riverpod/legacy.dart';
import 'package:kosmos_digital_test/src/features/post/model/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

var postProvider = StateNotifierProvider<PostProvider, List<PostModel>>(
  (ref) => PostProvider(),
);

class PostProvider extends StateNotifier<List<PostModel>> {
  PostProvider() : super([]);

  void addPost(PostModel post) {
    state = [...state, post];
  }

  void removePost(String postId) {
    state = state.where((post) => post.id != postId).toList();
  }

  void updatePost(PostModel updatedPost) {
    state = state.map((post) {
      return post.id == updatedPost.id ? updatedPost : post;
    }).toList();
  }

  Future<void> persistPosts() async {
    var prefs = await SharedPreferences.getInstance();

    List<String> postStrings = state.map((post) => post.toString()).toList();
    await prefs.setStringList('posts_key', postStrings);
  }

  Future<void> loadPosts() async {
    var prefs = await SharedPreferences.getInstance();

    List<String>? postStrings = prefs.getStringList('posts_key');
    if (postStrings != null) {
      state = postStrings.map((str) => PostModel.fromString(str)).toList();
    }
  }

  List<PostModel> getPosts() {
    return state;
  }
}
