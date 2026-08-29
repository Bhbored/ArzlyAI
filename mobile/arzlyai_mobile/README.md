# ArzlyAI Mobile

Flutter Android/iOS client for the local-first ArzlyAI workflow platform.

The project is intentionally an empty scaffold. Implement the first vertical slice using [`docs/presets/flutter-linkedin-client-plan.md`](../../docs/presets/flutter-linkedin-client-plan.md).

```powershell
flutter pub get
flutter analyze
flutter test
flutter run
```

Flutter SQLite owns user workflow data and history. Provider credentials must use platform secure storage and must never be written to SQLite or logs.
