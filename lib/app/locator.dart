import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  final prefs = await SharedPreferences.getInstance();
  locator.registerSingleton<SharedPreferences>(prefs);
  locator.registerLazySingleton(() => AuthService(locator<SharedPreferences>()));
  locator.registerLazySingleton(() => NotificationService());
} 