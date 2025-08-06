# Chatting App

A Flutter-based mobile application for real-time messaging and user authentication.

## Current Features

- User Authentication
  - User Registration
  - User Login
  - Token-based Authentication
  - Secure Storage for Tokens

## Project Structure

```
lib/
├── core/
│   └── constants/
│       └── api_constant.dart
├── features/
│   └── auth/
│       ├── data/
│       │   ├── datasources/
│       │   │   └── remote_data/
│       │   │       └── user_remote_data_source_impl.dart
│       │   └── models/
│       │       └── user_model.dart
│       └── domain/
│           └── entities/
│               └── user.dart
└── test/
    └── features/
        └── auth/
            └── data/
                └── datasources/
                    └── remote_data/
                        └── user_remote_data_source_impl_test.dart
```

## Getting Started

### 🛠️ Prerequisites

- ⚙️ Flutter SDK (latest stable version)
- 🎯 Dart SDK (included with Flutter)
- 📱 Android Studio / Xcode (for emulator/simulator)

### 🚀 Installation

1. 📥 Clone the repository
   ```bash
   git clone https://github.com/yourusername/chatting-app.git
   cd chatting-app
   ```

2. 📦 Install dependencies:
   ```bash
   flutter pub get
   ```

3. 🔄 Run the app:
   ```bash
   # For Android
   flutter run -d <device_id>
   
   # For iOS
   cd ios && pod install && cd ..
   flutter run
   ```

4. ✅ Verify the setup:
   ```bash
   flutter doctor
   ```

## Testing

Run tests using:
```bash
flutter test
```

## Dependencies

- http: ^1.1.0
- flutter_secure_storage: ^9.2.4
- mockito: ^5.4.4 (dev dependency)
- build_runner: ^2.4.8 (dev dependency)
