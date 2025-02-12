import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Request permission
      await _requestPermission();

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification open events when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);

      _isInitialized = true;
      print('NotificationService initialized successfully');
      
      // Get and print FCM token for testing
      final token = await getToken();
      print('FCM Token: $token');
      
    } catch (e) {
      print('Error initializing NotificationService: $e');
      _isInitialized = false;
    }
  }

  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    
    print('User granted permission: ${settings.authorizationStatus}');
  }

  void _handleForegroundMessage(RemoteMessage message) async {
    print('Handling foreground message: ${message.messageId}');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');

    // Handle different notification types
    if (message.data['type'] == 'order_update') {
      // Handle order updates
    } else if (message.data['type'] == 'chat_message') {
      // Handle chat messages
    } else if (message.data['type'] == 'promotion') {
      // Handle promotional notifications
    }
  }

  void _handleNotificationOpen(RemoteMessage message) {
    print('Notification opened: ${message.messageId}');
    print('Data: ${message.data}');

    // Navigate based on notification type
    switch (message.data['type']) {
      case 'order_update':
        // Navigate to order details
        break;
      case 'chat_message':
        // Navigate to chat screen
        break;
      case 'promotion':
        // Navigate to promotion details
        break;
    }
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }
}

// Handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling background message: ${message.messageId}');
} 