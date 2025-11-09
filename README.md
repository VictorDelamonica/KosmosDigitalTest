# Kosmos Digital Test 🚀

A modern Flutter social media application with Firebase integration, featuring user authentication, post creation, profile management, and real-time data synchronization.

[![Flutter](https://img.shields.io/badge/Flutter-3.35.7-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.9.2-0175C2?logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Enabled-FFCA28?logo=firebase)](https://firebase.google.com)

## ✨ Features

### 🔐 Authentication
- **Email & Password Registration** with email verification
- **Secure Login** with Firebase Authentication
- **GDPR Compliant** with Terms & Conditions acceptance
- **Auto-login** with session persistence

### 📱 Social Features
- **Create Posts** with image upload support
- **View Feed** with all user posts
- **Post Details** view with full content
- **Profile Management** with customizable user information
- **Image Picker** integration for photos from camera or gallery

### 🎨 User Experience
- **Clean Material Design** with custom color scheme
- **Smooth Navigation** with bottom navigation bar
- **Responsive Layout** optimized for mobile devices
- **Custom Components** for consistent UI/UX
- **Dotted Border** design elements for modern aesthetics

## 📸 Screenshots

_Coming soon_

## 🛠️ Tech Stack

### Frontend
- **Flutter 3.35.7** - UI framework
- **Dart 3.9.2** - Programming language
- **Material Design 3** - Design system

### State Management
- **Riverpod 3.0.3** - State management solution

### Backend & Services
- **Firebase Core 4.2.1** - Firebase SDK
- **Firebase Auth 6.1.2** - Authentication service

### Key Packages
- `image_picker: ^1.2.0` - Camera and gallery access
- `dotted_border: ^2.1.0` - Custom border styling
- `shared_preferences: ^2.5.3` - Local data persistence

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.35.7 or higher
- Dart SDK 3.9.2 or higher
- Android Studio / VS Code with Flutter extensions
- Firebase account and project setup
- Java 17 (for Android builds)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/kosmos_digital_test.git
   cd kosmos_digital_test
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Firebase Setup**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Add Android and iOS apps to your Firebase project
   - Download and place `google-services.json` in `android/app/`
   - Download and place `GoogleService-Info.plist` in `ios/Runner/`
   - Enable Email/Password authentication in Firebase Console

4. **Configure Firebase**
   ```bash
   # Install FlutterFire CLI
   dart pub global activate flutterfire_cli
   
   # Configure Firebase for your project
   flutterfire configure
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle (for Play Store)
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## 🏗️ Project Structure

```
lib/
├── main.dart                          # App entry point
├── firebase_options.dart              # Firebase configuration
└── src/
    ├── core/                          # Core utilities and components
    │   └── components/
    │       ├── custom_button.dart
    │       ├── custom_text_field.dart
    │       └── popup_modal.dart
    └── features/                      # Feature modules
        ├── connections/               # Authentication features
        │   ├── provider/
        │   ├── service/
        │   └── view/
        │       ├── auth_wrapper.dart
        │       ├── login_view.dart
        │       ├── register_view.dart
        │       └── register_details_view.dart
        ├── home/                      # Home feed
        │   └── view/
        │       └── home_view.dart
        ├── post/                      # Post management
        │   ├── provider/
        │   └── view/
        │       ├── add_post.dart
        │       └── post_details_view.dart
        └── profile/                   # User profile
            └── view/
                └── profile_view.dart
```

## 🔧 Configuration

### Theme Customization

The app uses a custom color scheme defined in `main.dart`:

```dart
ColorScheme(
  primary: Colors.white,
  tertiary: Color(0xFF02132B),  // Dark blue
  secondary: Color(0xFFF7F8F8), // Light gray
  // ...
)
```

### Firebase Configuration

Firebase options are automatically generated in `firebase_options.dart` using FlutterFire CLI.

## 🤝 Contributing

This is a proprietary project. Unauthorized copying or distribution is prohibited.

## 📄 License

Copyright (c) 2025 Monikode. All rights reserved.

Unauthorized copying of this project, via any medium, is strictly prohibited.

## 👤 Author

**MoniK / Monikode**

## 🐛 Known Issues

- See the [Issues](https://github.com/yourusername/kosmos_digital_test/issues) page for known bugs and feature requests

## 📝 Changelog

See [Releases](https://github.com/yourusername/kosmos_digital_test/releases) for version history and changes.

## 🆘 Support

For support, email support@monikode.com or open an issue in the GitHub repository.

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend services
- Riverpod for state management
- All contributors and testers

---

**Made with ❤️ using Flutter**
