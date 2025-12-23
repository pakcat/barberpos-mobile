---
description: Build APK with Firebase Backend
---

To build the APK configured for Firebase usage, you must pass the `BACKEND_MODE` environment variable during the build command.

1. Ensure `google-services.json` is in `android/app` (already verified).
2. Run the build command with dart-define:

```bash
flutter build apk --release --dart-define=BACKEND_MODE=firebase
```

// turbo
3. (Optional) Install the APK to connected device:
```bash
flutter install
```
