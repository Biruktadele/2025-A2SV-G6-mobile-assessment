# Chatting Application

A modern Flutter-based mobile application with user authentication and real-time chat capabilities.

## 📱 Screenshots

| Splash Screen | Login Screen | Sign Up Screen |
|--------------|--------------|----------------|
| <img src="chatting_app/images/screenshoots/splash.jpg" width="200"> | <img src="chatting_app/images/screenshoots/login.jpg" width="200"> | <img src="chatting_app/images/screenshoots/signup.jpg" width="200"> |

## ✨ Features

### 🔐 User Authentication
- **Login**: Secure user authentication with email and password
- **Sign Up**: New user registration with email verification
- **Logout**: Secure session termination
- **Splash Screen**: Beautiful loading screen with app branding
- **Terms & Conditions**: User agreement during signup

## Current Features

- User Authentication
  - User Registration
  - User Login
  - Token-based Authentication
  - Secure Storage for Tokens

## Project Structure

```
lib/
├── core/                             # Core functionalities shared across features
│   ├── error/                        # Error handling (e.g., exceptions, failures)
│   ├── network/                      # Network utilities (e.g., connectivity checker, API client)
│   ├── usecases/                     # Base UseCase class
│   └── utils/                        # Common helpers (e.g., formatters, constants)
│
├── features/                         # Feature-based modules
│   ├── auth/                         # Authentication feature (login, register, etc.)
│   │   ├── data/                     
│   │   │   ├── datasources/          # Remote and local data sources
│   │   │   ├── models/               # Data models (DTOs)
│   │   │   └── repositories/         # Auth repository implementation
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/             # Business objects (User, etc.)
│   │   │   ├── repositories/         # Abstract repository contract
│   │   │   └── usecases/             # Use case classes (LoginUser, RegisterUser, etc.)
│   │   │
│   │   └── presentation/
│   │       ├── bloc/                 # Auth BLoC/Cubit and state management
│   │       ├── pages/                # UI screens (LoginPage, SignupPage)
│   │       └── widgets/              # Shared widgets (input fields, buttons, etc.)
│
│   
│
├── injection_container.dart          # Service locator 
└── main.dart                         # Application entry point

```


## 🚀 Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Dart SDK (latest stable version)
- Android Studio / Xcode (for emulator/simulator)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/biruktadele/2025-A2SV-G6-mobile-assessment.git
   cd 2025-A2SV-G6-mobile-assessment/chatting_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## 🔄 Authentication Flow

1. **Splash Screen**: App loads and checks for existing user session
2. **Login/Signup**: New users can sign up, existing users can log in
3. **OTP Verification**: Email verification for new accounts
4. **Main App**: Access to chat features after successful authentication

## 📦 Dependencies

- `flutter_bloc`: State management
- `equatable`: For value comparison
- `get_it`: Dependency injection
- `dio`: HTTP client
- `shared_preferences`: Local storage for user session
- `google_fonts`: Beautiful typography

## 🧪 Testing

Run tests using:
```bash
flutter test
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.