// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kosmos_digital_test/src/core/components/custom_text_field.dart';
import 'package:kosmos_digital_test/src/core/components/popup_modal.dart';
import 'package:kosmos_digital_test/src/features/connections/provider/user_provider.dart';
import 'package:kosmos_digital_test/src/features/connections/service/connection_service.dart';

import '../../../core/components/custom_button.dart';

class EmailEditView extends ConsumerStatefulWidget {
  const EmailEditView({super.key});

  @override
  ConsumerState<EmailEditView> createState() => _EmailEditViewState();
}

class _EmailEditViewState extends ConsumerState<EmailEditView> {
  TextEditingController emailController = TextEditingController();

  anonymousEmail(String text) {
    var parts = text.split("@");
    if (parts.length != 2) return text;
    var name = parts[0];
    var domain = parts[1];
    if (name.length <= 2) {
      name = "${name[0]}*";
    } else {
      name = name[0] + "*" * (name.length - 2) + name[name.length - 1];
    }
    return "$name@$domain";
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "Adresse e-mail",
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
                  "Adresse email*",
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
                CustomTextField(
                  textController: TextEditingController(text: user.email),
                  hintText: user.email,
                  onChanged: (value) {
                    emailController.text = value;
                  },
                ),
              ],
            ),
            CustomButton(
              text: "Enregistrer",
              onPressed: () async {
                ref
                    .watch(userProvider.notifier)
                    .updateUserDetails(email: emailController.text);
                await ConnectionService().updateEmail(emailController.text);
                // ignore: use_build_context_synchronously
                Navigator.of(context).pop();
                showDialog(
                  // ignore: use_build_context_synchronously
                  context: context,
                  builder: (_) {
                    return PopupModal(
                      title: "Vérifiez votre boîte mail",
                      content:
                          "Vous venez de recevoir un email de vérification sur john ${anonymousEmail(emailController.text)}",
                      ctaText: "Fermer",
                      onPressed: (newContext) {
                        Navigator.pop(newContext);
                      },
                    );
                  },
                );
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
