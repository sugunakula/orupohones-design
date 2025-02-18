# ORUphones Flutter App

A Flutter application for buying and selling used phones, built with a clean architecture and robust state management.

## Architecture & State Management

### State Management
- **Stacked Architecture**: Implements MVVM pattern using the `stacked` package
- View Models handle business logic and state
- Services handle data operations and external interactions
- Dependency injection using `get_it` for service locator pattern

### Project Structure
lib/
├── app/
│ └── locator.dart # Dependency injection setup
├── models/
│ └── product.dart # Data models
├── screens/
│ ├── home_screen.dart # UI screens
│ ├── login_screen.dart
│ └── ...
├── services/
│ ├── auth_service.dart # Business logic services
│ ├── product_service.dart
│ └── notification_service.dart
├── viewmodels/
│ └── auth_viewmodel.dart # View models for state management
└── widgets/
├── custom_app_bar.dart # Reusable widgets
└── ...

### Key Features
- Clean Architecture principles
- MVVM pattern with Stacked
- Dependency Injection
- Firebase Cloud Messaging for notifications
- REST API integration using Dio
- Secure local storage with SharedPreferences
- Custom widgets and animations

## Setup Instructions

### Prerequisites
- Flutter SDK (3.5.4 or higher)
- Android Studio / VS Code
- Git

### Getting Started
1. Clone the repository

git clone https://github.com/yourusername/oruphones.git
cd oruphones

2. Install dependencies
3. 
3. Set up Firebase
- Create a new Firebase project
- Add your Android app to Firebase
- Download `google-services.json` and place it in `android/app/`
- Update `firebase_options.dart` with your Firebase configuration

4. Run the app
   
### Environment Setup
Make sure to set up the following:
- Android SDK
- Flutter SDK
- Firebase configuration
- API endpoints configuration in `product_service.dart`

## Features
- User Authentication
- Product Listing
- Product Search & Filters
- Push Notifications
- Real-time Updates
- Responsive UI

## Dependencies
yaml
dependencies:
flutter_svg: ^2.0.10
stacked: ^3.4.0
stacked_services: ^1.1.0
shared_preferences: ^2.2.2
dio: ^5.4.0
get_it: ^7.6.7
lottie: ^3.0.0
firebase_core: ^2.25.4
firebase_messaging: ^14.7.15


## Contributing
1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License
This project is licensed under the MIT License - see the LICENSE file for details

## Acknowledgments
- Flutter team for the amazing framework
- Firebase for backend services
- All contributors who participate in this project
