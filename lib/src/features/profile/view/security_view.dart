// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosmos_digital_test/src/features/connections/provider/user_provider.dart';
import 'package:kosmos_digital_test/src/features/profile/view/email_edit_view.dart';
import 'package:kosmos_digital_test/src/features/profile/view/profile_view.dart';

class SecurityView extends ConsumerWidget {
  const SecurityView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Sécurité",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          spacing: 8,
          children: [
            ProfileRow(
              title: "Adresse e-mail",
              subtitle: ref.read(userProvider).email,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EmailEditView(),
                  ),
                );
              },
            ),
            ProfileRow(
              title: "Mot de passe",
              subtitle:
                  "Dernière modification: il y a 3j", // PLACEHOLDER: dynamic date
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
