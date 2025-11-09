// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosmos_digital_test/src/core/components/custom_button.dart';
import 'package:kosmos_digital_test/src/core/components/custom_text_field.dart';
import 'package:kosmos_digital_test/src/features/profile/view/profile_view.dart';

import '../../connections/provider/user_provider.dart';

class PersonalInfoView extends StatelessWidget {
  const PersonalInfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Modifier",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ProfileRow(
              title: "Informations personnelles",
              subtitle: "Nom, prénom...",
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const EditPersonalInfoView(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditPersonalInfoView extends ConsumerStatefulWidget {
  const EditPersonalInfoView({super.key});

  @override
  ConsumerState<EditPersonalInfoView> createState() =>
      _EditPersonalInfoViewState();
}

class _EditPersonalInfoViewState extends ConsumerState<EditPersonalInfoView> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Informations personnelles",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          spacing: 16,
          children: [
            Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Prénom*",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                CustomTextField(
                  textController: TextEditingController(text: user.firstName),
                  hintText: user.firstName,
                  onChanged: (value) {
                    firstNameController.text = value;
                  },
                ),
              ],
            ),
            Column(
              spacing: 3,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nom*",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                CustomTextField(
                  textController: TextEditingController(text: user.lastName),
                  hintText: user.lastName,
                  onChanged: (value) {
                    lastNameController.text = value;
                  },
                ),
              ],
            ),
            CustomButton(
              text: "Enregistrer",
              onPressed: () async {
                await ref
                    .read(userProvider.notifier)
                    .updateUserDetails(
                      firstName: firstNameController.text.isNotEmpty
                          ? firstNameController.text
                          : user.firstName,
                      lastName: lastNameController.text.isNotEmpty
                          ? lastNameController.text
                          : user.lastName,
                    );
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
              },
            ),
            Text(
              "*Les champs sont obligatoires.",
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
