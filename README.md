A CivicHaven

## Firebase setup

Phone OTP requires a real Firebase project. The checked-in `lib/firebase_options.dart` contains placeholder values and cannot send SMS.

1. Create or select a Firebase project in the Firebase Console.
2. Enable **Authentication > Sign-in method > Phone**.
3. Add the Android app with package name `com.example.civic_haven`.
4. From the project root, run:

	```powershell
	dart pub global activate flutterfire_cli
	flutterfire configure
	```

5. Select the Firebase project and Android platform when prompted.
6. In Firebase Authentication, add a test phone number if you do not want to send real SMS during development.
7. Run `flutter run` again.

For Android phone authentication, add the app's SHA-1 and SHA-256 fingerprints in the Firebase Console under the Android app settings. The debug SHA-1 can be obtained with:

```powershell
cd android
./gradlew signingReport
```

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
