// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:kosmos_digital_test/src/core/components/custom_button.dart';
import 'package:kosmos_digital_test/src/core/components/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            spacing: 24,
            children: [
              Text(
                "Connectez-vous ou\ncréez un compte.",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adresse e-mail",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                    emailController: emailController,
                    hintText: "john.doe@gmail.com",
                    obscureText: true,
                  ),
                ],
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mot de passe",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                    emailController: passwordController,
                    hintText: "Mot de passe",
                    obscureText: true,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Mot de passe oublié ?",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (_) {
                          return Container(
                            padding: EdgeInsets.all(24),
                            width: double.infinity,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 24,
                              children: [
                                Text(
                                  "Réinitialiser mot de passe",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Entrez l’adresse email associée à votre compte. Nous vous enverrons un email de réinitialisation sur celle-ci.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Column(
                                  spacing: 3,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Adresse e-mail",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    CustomTextField(
                                      emailController: emailController,
                                      hintText: "john.doe@gmail.com",
                                      obscureText: true,
                                    ),
                                  ],
                                ),
                                CustomButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    showDialog(
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          titleTextStyle: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                          ),
                                          title: Text("Email envoyé"),
                                          content: Text(
                                            "Vous avez reçu un email afin de réinitialiser votre mot de passe.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          actions: [
                                            CustomButton(
                                              text: "Fermer",
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  text: "Réinitialiser",
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      "Réinitialiser",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        decoration: TextDecoration.underline,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              CustomButton(onPressed: () {}, text: "Connexion"),
            ],
          ),
        ),
      ),
    );
  }
}
