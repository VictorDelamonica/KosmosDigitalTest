// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:kosmos_digital_test/src/features/connections/service/connection_service.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final connectionService = ConnectionService();
    final isLoggedIn = connectionService.isUserLoggedIn();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLoggedIn) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
