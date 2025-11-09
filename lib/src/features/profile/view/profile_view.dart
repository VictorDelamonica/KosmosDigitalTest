// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosmos_digital_test/src/core/components/custom_button.dart';
import 'package:kosmos_digital_test/src/core/components/popup_modal.dart';
import 'package:kosmos_digital_test/src/features/connections/provider/user_provider.dart';
import 'package:kosmos_digital_test/src/features/profile/view/personal_info_view.dart';
import 'package:kosmos_digital_test/src/features/profile/view/security_view.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 4,
                      children: [
                        CustomButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return PopupModal(
                                  title: "Supprimer mon compte",
                                  content:
                                      "Souhaitez-vous vraiment supprimer votre compte ?",
                                  ctaText: "Oui",
                                  secondaryCtaText: "Non",
                                  onPressed: (context) {
                                    ref
                                        .read(userProvider.notifier)
                                        .removeUser();
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      "/login",
                                      (root) => false,
                                    );
                                  },
                                );
                              },
                            );
                          },
                          text: "Supprimer mon profil",
                          color: Colors.red,
                        ),
                        TextButton(
                          onPressed: () {
                            ref.read(userProvider.notifier).logout(context);
                          },
                          child: Text(
                            "Se déconnecter",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: user.profilePicture != null
                                  ? Image.file(
                                      File(user.profilePicture!.path),
                                      width: 92,
                                      height: 92,
                                      fit: BoxFit.fill,
                                    )
                                  : Icon(
                                      Icons.account_circle,
                                      size: 92,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withValues(alpha: 0.5),
                                    ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          child: GestureDetector(
                            onTap: () async {
                              var profilePicture = await showModalBottomSheet<File>(
                                context: context,
                                builder: (_) {
                                  return Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 16,
                                      children: [
                                        CustomButton(
                                          onPressed: () {
                                            final ImagePicker picker =
                                                ImagePicker();
                                            picker
                                                .pickImage(
                                                  source: ImageSource.gallery,
                                                )
                                                .then((pickedFile) {
                                                  if (pickedFile != null) {
                                                    Navigator.pop(
                                                      // ignore: use_build_context_synchronously
                                                      context,
                                                      File(pickedFile.path),
                                                    );
                                                  }
                                                });
                                          },
                                          text: "Depuis la galerie",
                                        ),
                                        CustomButton(
                                          onPressed: () async {
                                            final ImagePicker picker =
                                                ImagePicker();
                                            final XFile? pickedFile =
                                                await picker.pickImage(
                                                  source: ImageSource.camera,
                                                );
                                            if (pickedFile != null) {
                                              WidgetsBinding.instance
                                                  .addPostFrameCallback((_) {
                                                    if (!mounted) return;
                                                    Navigator.pop(
                                                      context,
                                                      File(pickedFile.path),
                                                    );
                                                  });
                                            }
                                          },
                                          text: "Prendre une photo",
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                              if (profilePicture != null) {
                                user = user.copyWith(
                                  profilePicture: XFile(profilePicture.path),
                                );
                                await ref
                                    .read(userProvider.notifier)
                                    .setUser(user);
                              }
                              setState(() {});
                            },
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.black.withValues(
                                alpha: 0.8,
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 13,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.withValues(alpha: 0.7)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    "Mon compte",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  ProfileRow(
                    title: '${user.firstName} ${user.lastName}',
                    subtitle: user.email,
                    imageFile: user.profilePicture,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PersonalInfoView(),
                        ),
                      );
                    },
                  ),
                  ProfileRow(
                    title: "Sécurité",
                    subtitle: "Mot de passe, email...",
                    iconData: Icons.lock_outline_rounded,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SecurityView(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    "Paramètres",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  ProfileRow(
                    title: 'Notifications push',
                    subtitle: "Activées",
                    iconData: Icons.notifications_none_outlined,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    "Autres",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  ProfileRow(
                    title: "Aide",
                    subtitle: "Contactez-nous par email",
                    iconData: Icons.help_outline_outlined,
                  ),
                  ProfileRow(
                    title: "Partager l'application",
                    subtitle: "Contactez-nous par email",
                    iconData: Icons.ios_share_rounded,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    "Lines",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  ProfileRow(title: "Politique de confidentialité"),
                  ProfileRow(
                    title: "Conditions générales de ventes et d’utilisation",
                  ),
                  ProfileRow(title: "Mentions légales"),
                  ProfileRow(title: "A propos"),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    "Réseaux sociaux",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  ProfileRow(
                    title: "Notre page Facebook",
                    imageNetwork:
                        "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b9/2023_Facebook_icon.svg/2048px-2023_Facebook_icon.svg.png",
                  ),
                  ProfileRow(
                    title: "Notre instagram",
                    imageNetwork:
                        "https://media.gqmagazine.fr/photos/6242dfd58d00963242412206/1:1/w_1600%2Cc_limit/insta%2520cover.jpg",
                  ),
                  ProfileRow(
                    title: "Notre Twitter",
                    imageNetwork:
                        "https://play-lh.googleusercontent.com/XyI6Hyz9AFg7E_joVzX2zh6CpWm9B2DG2JuEz5meCFVm4-wTKTnHgqbmg62iFKe4Gzca",
                  ),
                  ProfileRow(
                    title: "Notre Snapchat",
                    imageNetwork:
                        "https://upload.wikimedia.org/wikipedia/fr/7/75/Snapchat.png",
                  ),
                ],
              ),
              Center(child: Text("Édité par kosmos-digital.com")),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final XFile? imageFile;
  final IconData? iconData;
  final String? imageNetwork;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const ProfileRow({
    super.key,
    this.imageFile,
    this.iconData,
    this.imageNetwork,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            spacing: 8,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: imageFile != null
                    ? Image.file(
                        File(imageFile!.path),
                        width: 44,
                        height: 44,
                        fit: BoxFit.fill,
                      )
                    : iconData != null
                    ? CircleAvatar(
                        radius: 22,
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        child: Icon(iconData!, size: 22, color: Colors.white),
                      )
                    : imageNetwork != null
                    ? Image.network(
                        imageNetwork!,
                        width: 44,
                        height: 44,
                        fit: BoxFit.fill,
                      )
                    : SizedBox.shrink(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.7),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
