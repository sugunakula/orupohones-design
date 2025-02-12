import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: "AIzaSyBa4NbBpYLKtIKBLhbI0w3OiX39Ngrg-WI",
      appId: "1:510769384927:android:e1c71291c53553ccba086a",
      messagingSenderId: "510769384927",
      projectId: "oruphones-7f962",
      storageBucket: "oruphones-7f962.firebasestorage.app",
    );
  }
}
