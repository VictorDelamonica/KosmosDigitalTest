// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController emailController;
  final String hintText;
  final bool obscureText;
  const CustomTextField({
    super.key,
    required this.emailController,
    required this.hintText,
    required this.obscureText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(8),
      child: TextField(
        controller: widget.emailController,
        showCursor: true,
        cursorColor: Theme.of(context).colorScheme.onPrimary,
        obscureText: widget.obscureText,
        decoration: InputDecoration(
          fillColor: Theme.of(context).colorScheme.surface,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: Icon(
                    _isObscured ? Icons.visibility : Icons.visibility_off,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscured = !_isObscured;
                    });
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
