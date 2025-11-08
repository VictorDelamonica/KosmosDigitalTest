// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kosmos_digital_test/src/features/connections/model/user_model.dart';
import 'package:kosmos_digital_test/src/features/connections/service/connection_service.dart';

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

  void updateUserDetails({
    String? firstName,
    String? lastName,
    XFile? profilePicture,
  }) {
    state = state.copyWith(
      firstName: firstName ?? state.firstName,
      lastName: lastName ?? state.lastName,
      profilePicture: profilePicture ?? state.profilePicture,
    );
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
}
