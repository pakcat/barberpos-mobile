# Observability (Firebase)

## Firebase (Analytics + Crashlytics)

Already used in code via `firebase_core` options (`lib/firebase_options.dart`).

- **Crashlytics only on release**:
  - `FirebaseCrashlytics` collection is enabled only when `kReleaseMode == true` (`lib/main.dart`).
  - Android mapping upload is enabled only for `release` build type (`android/app/build.gradle.kts`).
- **Analytics only on release**:
  - `FirebaseAnalytics` collection is enabled only when `kReleaseMode == true` (`lib/main.dart`).

### Android
- Ensure `android/app/google-services.json` exists (already present).

### iOS
- This repo now includes `ios/Podfile`. After `flutter pub get`, run:
  - `cd ios`
  - `pod install`

## Sentry
Sentry tidak digunakan (skip).
