// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:image_picker/image_picker.dart';

class PostModel {
  final String id;
  final String title;
  final String content;
  final XFile? image;
  final DateTime createdAt;

  PostModel({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.createdAt,
  });

  PostModel copyWith({
    String? id,
    String? title,
    String? content,
    XFile? imagePath,
    DateTime? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      image: imagePath ?? image,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return '{id: $id, title: $title, content: $content, image: ${image?.path}, createdAt: $createdAt}';
  }

  static PostModel fromString(String str) {
    var parts = str
        .substring(1, str.length - 1)
        .split(', ')
        .map((e) => e.split(': '))
        .toList();
    var id = parts[0][1];
    var title = parts[1][1];
    var content = parts[2][1];
    var imagePath = parts[3][1] != 'null' ? XFile(parts[3][1]) : null;
    var createdAt = DateTime.parse(parts[4][1]);
    return PostModel(
      id: id,
      title: title,
      content: content,
      image: imagePath,
      createdAt: createdAt,
    );
  }
}
