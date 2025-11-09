// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosmos_digital_test/src/features/post/model/post_model.dart';
import 'package:kosmos_digital_test/src/features/post/provider/post_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PostProvider Tests', () {
    late ProviderContainer container;
    late PostProvider providerNotifier;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
      providerNotifier = container.read(postProvider.notifier);
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state should be empty list', () {
      final posts = container.read(postProvider);
      expect(posts, isEmpty);
    });

    test('addPost should add a post to the state', () {
      final post = PostModel(
        id: '1',
        title: 'Test Post',
        content: 'Test Content',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );

      providerNotifier.addPost(post);

      final posts = container.read(postProvider);
      expect(posts.length, 1);
      expect(posts.first.id, '1');
      expect(posts.first.title, 'Test Post');
      expect(posts.first.content, 'Test Content');
    });

    test('addPost should add multiple posts', () {
      final post1 = PostModel(
        id: '1',
        title: 'Post 1',
        content: 'Content 1',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );
      final post2 = PostModel(
        id: '2',
        title: 'Post 2',
        content: 'Content 2',
        image: null,
        createdAt: DateTime(2025, 1, 2),
      );

      providerNotifier.addPost(post1);
      providerNotifier.addPost(post2);

      final posts = container.read(postProvider);
      expect(posts.length, 2);
      expect(posts[0].id, '1');
      expect(posts[1].id, '2');
    });

    test('removePost should remove a post by id', () {
      final post1 = PostModel(
        id: '1',
        title: 'Post 1',
        content: 'Content 1',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );
      final post2 = PostModel(
        id: '2',
        title: 'Post 2',
        content: 'Content 2',
        image: null,
        createdAt: DateTime(2025, 1, 2),
      );
      providerNotifier.addPost(post1);
      providerNotifier.addPost(post2);

      providerNotifier.removePost('1');

      final posts = container.read(postProvider);
      expect(posts.length, 1);
      expect(posts.first.id, '2');
    });

    test('removePost should handle non-existent id', () {
      final post = PostModel(
        id: '1',
        title: 'Post 1',
        content: 'Content 1',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );
      providerNotifier.addPost(post);

      providerNotifier.removePost('999');

      final posts = container.read(postProvider);
      expect(posts.length, 1);
      expect(posts.first.id, '1');
    });

    test('updatePost should update an existing post', () {
      final post = PostModel(
        id: '1',
        title: 'Original Title',
        content: 'Original Content',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );
      providerNotifier.addPost(post);

      final updatedPost = PostModel(
        id: '1',
        title: 'Updated Title',
        content: 'Updated Content',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );

      providerNotifier.updatePost(updatedPost);

      final posts = container.read(postProvider);
      expect(posts.length, 1);
      expect(posts.first.title, 'Updated Title');
      expect(posts.first.content, 'Updated Content');
    });

    test('updatePost should not affect other posts', () {
      final post1 = PostModel(
        id: '1',
        title: 'Post 1',
        content: 'Content 1',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );
      final post2 = PostModel(
        id: '2',
        title: 'Post 2',
        content: 'Content 2',
        image: null,
        createdAt: DateTime(2025, 1, 2),
      );
      providerNotifier.addPost(post1);
      providerNotifier.addPost(post2);

      final updatedPost1 = PostModel(
        id: '1',
        title: 'Updated Post 1',
        content: 'Updated Content 1',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );

      providerNotifier.updatePost(updatedPost1);

      final posts = container.read(postProvider);
      expect(posts.length, 2);
      expect(posts[0].title, 'Updated Post 1');
      expect(posts[1].title, 'Post 2');
    });

    test('getPosts should return current state', () {
      final post1 = PostModel(
        id: '1',
        title: 'Post 1',
        content: 'Content 1',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );
      final post2 = PostModel(
        id: '2',
        title: 'Post 2',
        content: 'Content 2',
        image: null,
        createdAt: DateTime(2025, 1, 2),
      );
      providerNotifier.addPost(post1);
      providerNotifier.addPost(post2);

      final posts = providerNotifier.getPosts();

      expect(posts.length, 2);
      expect(posts[0].id, '1');
      expect(posts[1].id, '2');
    });

    test('persistPosts should save posts to SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});
      final post = PostModel(
        id: '1',
        title: 'Test Post',
        content: 'Test Content',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );
      providerNotifier.addPost(post);

      await providerNotifier.persistPosts();

      final prefs = await SharedPreferences.getInstance();
      final savedPosts = prefs.getStringList('posts_key');
      expect(savedPosts, isNotNull);
      expect(savedPosts!.length, 1);
      expect(savedPosts.first.contains('Test Post'), true);
    });

    test('loadPosts should load posts from SharedPreferences', () async {
      final post = PostModel(
        id: '1',
        title: 'Persisted Post',
        content: 'Persisted Content',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );

      SharedPreferences.setMockInitialValues({
        'posts_key': [post.toString()],
      });

      await providerNotifier.loadPosts();

      final posts = container.read(postProvider);
      expect(posts.length, 1);
      expect(posts.first.id, '1');
      expect(posts.first.title, 'Persisted Post');
      expect(posts.first.content, 'Persisted Content');
    });

    test('loadPosts should handle empty SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({});

      await providerNotifier.loadPosts();

      final posts = container.read(postProvider);
      expect(posts, isEmpty);
    });

    test('loadPosts should handle multiple posts', () async {
      final post1 = PostModel(
        id: '1',
        title: 'Post 1',
        content: 'Content 1',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );
      final post2 = PostModel(
        id: '2',
        title: 'Post 2',
        content: 'Content 2',
        image: null,
        createdAt: DateTime(2025, 1, 2),
      );

      SharedPreferences.setMockInitialValues({
        'posts_key': [post1.toString(), post2.toString()],
      });

      await providerNotifier.loadPosts();

      final posts = container.read(postProvider);
      expect(posts.length, 2);
      expect(posts[0].id, '1');
      expect(posts[1].id, '2');
    });

    test('persistPosts and loadPosts should work together', () async {
      SharedPreferences.setMockInitialValues({});
      final post1 = PostModel(
        id: '1',
        title: 'Post 1',
        content: 'Content 1',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );
      final post2 = PostModel(
        id: '2',
        title: 'Post 2',
        content: 'Content 2',
        image: null,
        createdAt: DateTime(2025, 1, 2),
      );
      providerNotifier.addPost(post1);
      providerNotifier.addPost(post2);

      await providerNotifier.persistPosts();

      final newContainer = ProviderContainer();
      final newProviderNotifier = newContainer.read(postProvider.notifier);
      await newProviderNotifier.loadPosts();

      final loadedPosts = newContainer.read(postProvider);
      expect(loadedPosts.length, 2);
      expect(loadedPosts[0].id, '1');
      expect(loadedPosts[0].title, 'Post 1');
      expect(loadedPosts[1].id, '2');
      expect(loadedPosts[1].title, 'Post 2');

      newContainer.dispose();
    });

    test('addPost with image should preserve image path', () {
      final post = PostModel(
        id: '1',
        title: 'Post with Image',
        content: 'Content',
        image: XFile('/path/to/image.jpg'),
        createdAt: DateTime(2025, 1, 1),
      );

      providerNotifier.addPost(post);

      final posts = container.read(postProvider);
      expect(posts.first.image, isNotNull);
      expect(posts.first.image!.path, '/path/to/image.jpg');
    });

    test('state should be immutable', () {
      final post1 = PostModel(
        id: '1',
        title: 'Post 1',
        content: 'Content 1',
        image: null,
        createdAt: DateTime(2025, 1, 1),
      );
      providerNotifier.addPost(post1);

      final stateBefore = container.read(postProvider);

      final post2 = PostModel(
        id: '2',
        title: 'Post 2',
        content: 'Content 2',
        image: null,
        createdAt: DateTime(2025, 1, 2),
      );
      providerNotifier.addPost(post2);

      expect(stateBefore.length, 1);
      expect(container.read(postProvider).length, 2);
    });
  });
}
