// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:firebase_auth/firebase_auth.dart';

class ConnectionService {
  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  bool validatePassword(String password) {
    return password.length >= 6;
  }

  bool passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  Future<UserCredential> singInViaFirebaseEmailPassword(
    String email,
    String password,
  ) async {
    if (!validateEmail(email) || !validatePassword(password)) {
      throw Exception("Email ou mot de passe invalide");
    }
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    if (userCredential.user == null) {
      throw Exception("Utilisateur non trouvé; veuillez réessayer.");
    }
    return userCredential;
  }

  Future<UserCredential> signUpViaFirebaseEmailPassword(
    String email,
    String password,
  ) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user == null) {
      throw Exception("Utilisateur non créé; veuillez réessayer.");
    }
    await ConnectionService().sendEmailVerification();
    return userCredential;
  }

  void logout() {
    FirebaseAuth.instance.signOut();
  }

  bool isUserLoggedIn() {
    return FirebaseAuth.instance.currentUser != null;
  }

  void delete() {
    FirebaseAuth.instance.currentUser?.delete();
    FirebaseAuth.instance.signOut();
  }

  Future<void> updateEmail(String newEmail) async {
    await FirebaseAuth.instance.currentUser?.verifyBeforeUpdateEmail(newEmail);
  }

  Future<void> sendEmailVerification() async {
    await FirebaseAuth.instance.currentUser?.sendEmailVerification();
  }
}
