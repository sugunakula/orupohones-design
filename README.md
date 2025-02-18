
# **ORUphones - Flutter App**  
A Flutter application for **buying and selling used phones**, built with **clean architecture** and **robust state management**.

---

## **🛠 Architecture & State Management**  
### **State Management**
- **Stacked Architecture**: Implements the **MVVM** pattern using the `stacked` package.  
- **ViewModels**: Handle business logic and state.  
- **Services**: Manage data operations and external interactions.  
- **Dependency Injection**: Uses `get_it` for service locator pattern.  

---

## **📂 Project Structure**  
```
lib/
├── core/                          # Core functionalities
│   ├── config/                    # App configurations
│   │   ├── app_config.dart
│   │   ├── theme.dart
│   │   └── constants.dart
│   ├── dependencies/              # Dependency injection setup
│   │   └── locator.dart
│   ├── utils/                     # Helper functions
│   │   ├── validators.dart
│   │   ├── date_formatter.dart
│   │   └── logger.dart
│   ├── services/                  # Business logic & external services
│   │   ├── auth_service.dart
│   │   ├── product_service.dart
│   │   ├── notification_service.dart
│   │   ├── api_service.dart        # Handles API requests
│   │   └── local_storage_service.dart # SharedPreferences/Hive storage
│   ├── models/                     # Data models
│   │   ├── user.dart
│   │   ├── product.dart
│   │   ├── notification.dart
│   │   └── order.dart
│   ├── repositories/               # Repository layer (abstraction for services)
│   │   ├── auth_repository.dart
│   │   ├── product_repository.dart
│   │   ├── notification_repository.dart
│   │   └── order_repository.dart
├── features/                       # Features of the app
│   ├── auth/                       # Authentication module
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   ├── register_screen.dart
│   │   │   ├── forgot_password_screen.dart
│   │   ├── viewmodels/
│   │   │   ├── auth_viewmodel.dart
│   │   └── widgets/
│   │       ├── login_form.dart
│   │       ├── register_form.dart
│   ├── home/                       # Home module
│   │   ├── screens/
│   │   │   ├── home_screen.dart
│   │   │   ├── product_detail_screen.dart
│   │   │   ├── category_screen.dart
│   │   ├── viewmodels/
│   │   │   ├── home_viewmodel.dart
│   │   │   ├── product_viewmodel.dart
│   │   └── widgets/
│   │       ├── product_card.dart
│   │       ├── category_list.dart
│   ├── notifications/               # Notifications module
│   │   ├── screens/
│   │   │   ├── notification_screen.dart
│   │   ├── viewmodels/
│   │   │   ├── notification_viewmodel.dart
│   │   ├── widgets/
│   │       ├── notification_tile.dart
│   └── orders/                      # Orders module
│       ├── screens/
│       │   ├── orders_screen.dart
│       │   ├── order_detail_screen.dart
│       ├── viewmodels/
│       │   ├── order_viewmodel.dart
│       ├── widgets/
│           ├── order_card.dart
├── shared/                         # Shared UI components
│   ├── widgets/
│   │   ├── custom_app_bar.dart
│   │   ├── custom_button.dart
│   │   ├── loading_indicator.dart
│   └── styles/
│       ├── colors.dart
│       ├── typography.dart
└── main.dart                       # App entry point
```

---

## **🚀 Key Features**
✅ **Clean Architecture** principles  
✅ **MVVM pattern with Stacked** for structured state management  
✅ **Dependency Injection** using `get_it`  
✅ **Firebase Cloud Messaging** for push notifications  
✅ **REST API integration** using Dio  
✅ **Secure local storage** with SharedPreferences  
✅ **Custom UI components & animations**  

---

## **🔧 Setup Instructions**

### **Prerequisites**
- **Flutter SDK (3.5.4 or higher)**
- **Android Studio / VS Code**
- **Git**

### **Getting Started**
#### **1. Clone the Repository**
```sh
git clone https://github.com/yourusername/oruphones.git
cd oruphones
```

#### **2. Install Dependencies**
```sh
flutter pub get
```

#### **3. Set Up Firebase**
- Create a new **Firebase project**  
- Add your **Android app** to Firebase  
- Download `google-services.json` and place it in `android/app/`  
- Update `firebase_options.dart` with your Firebase configuration  

#### **4. Run the App**
```sh
flutter run
```

---

## **🌍 Environment Setup**
Ensure the following configurations:  
✔ **Android SDK & Flutter SDK**  
✔ **Firebase configuration setup**  
✔ **API endpoints configured** in `product_service.dart`  

---

## **📌 Features**
- **User Authentication** (Login, Register)  
- **Product Listing & Management**  
- **Advanced Search & Filters**  
- **Push Notifications**  
- **Real-time Updates**  
- **Responsive UI** for all devices  

---

## **📦 Dependencies**
```yaml
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
```

---

## **🤝 Contributing**
1. **Fork** the repository  
2. **Create a feature branch** (`git checkout -b feature/NewFeature`)  
3. **Commit your changes** (`git commit -m 'Add NewFeature'`)  
4. **Push to the branch** (`git push origin feature/NewFeature`)  
5. **Open a Pull Request**  

---

## **📜 License**
This project is licensed under the **MIT License** - see the `LICENSE` file for details.
