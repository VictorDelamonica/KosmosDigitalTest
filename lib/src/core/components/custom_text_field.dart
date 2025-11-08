// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController textController;
  final String hintText;
  final Function(String)? onChanged;
  final bool obscureText;
  final double? height;
  const CustomTextField({
    super.key,
    required this.textController,
    required this.hintText,
    this.obscureText = false,
    this.onChanged,
    this.height,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(8),
        child: TextField(
          controller: widget.textController,
          showCursor: true,
          cursorColor: Theme.of(context).colorScheme.onPrimary,
          obscureText: widget.obscureText ? _isObscured : false,
          onChanged: (value) {
            if (widget.onChanged != null) {
              widget.onChanged!(value);
            }
          },
          decoration: InputDecoration(
            fillColor: Theme.of(
              context,
            ).colorScheme.surface.withValues(alpha: 0.9),
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
      ),
    );
  }
}
