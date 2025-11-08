// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosmos_digital_test/src/features/connections/model/user_model.dart';
import 'package:kosmos_digital_test/src/features/connections/service/connection_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

var userProvider = StateNotifierProvider<UserProvider, UserModel>(
  (ref) => UserProvider(),
);

class UserProvider extends StateNotifier<UserModel> {
  UserProvider()
    : super(
        UserModel(
          id: '',
          displayName: '',
          firstName: '',
          lastName: '',
          email: '',
        ),
      );

  void setUser(UserModel user) {
    state = user;
  }

  void setUserFromCredentials(UserCredential credentials) {
    final firebaseUser = credentials.user;
    if (firebaseUser != null) {
      state = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? 'NO_EMAIL',
        displayName: firebaseUser.displayName ?? 'NO_NAME',
      );
    }
  }

  Future<void> updateUserDetails({
    String? firstName,
    String? lastName,
    XFile? profilePicture,
  }) async {
    state = state.copyWith(
      firstName: firstName ?? state.firstName,
      lastName: lastName ?? state.lastName,
      profilePicture: profilePicture ?? state.profilePicture,
    );
    await saveUserData();
  }

  UserModel getUser() {
    return state;
  }

  void logout() {
    state = UserModel(
      id: '',
      displayName: '',
      firstName: '',
      lastName: '',
      email: '',
    );
    ConnectionService().logout();
  }

  Future<void> loadUserData() async {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('user_id') ?? '';
    var email = prefs.getString('user_email') ?? '';
    var displayName = prefs.getString('user_display_name') ?? '';
    var firstName = prefs.getString('user_first_name') ?? '';
    var lastName = prefs.getString('user_last_name') ?? '';
    var profilePicturePath = prefs.getString('user_profile_picture') ?? '';
    XFile? profilePicture;
    if (profilePicturePath.isNotEmpty) {
      profilePicture = XFile(profilePicturePath);
    }
    state = UserModel(
      id: userId,
      email: email,
      displayName: displayName,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
    );
  }

  Future<void> saveUserData() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_id', state.id);
    await prefs.setString('user_email', state.email);
    await prefs.setString('user_display_name', state.displayName);
    await prefs.setString('user_first_name', state.firstName);
    await prefs.setString('user_last_name', state.lastName);
    if (state.profilePicture != null) {
      await prefs.setString('user_profile_picture', state.profilePicture!.path);
    }
  }
}
