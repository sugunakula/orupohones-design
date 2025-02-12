import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:lottie/lottie.dart';
import '../services/notification_service.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/auth_service.dart';
import '../app/locator.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class SplashScreen extends ViewModelBuilderWidget<AuthViewModel> {
  const SplashScreen({super.key});

  @override
  Widget builder(BuildContext context, AuthViewModel viewModel, Widget? child) {
    // Set context when building
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        viewModel.setContext(context);
        
        // Initialize notifications only once
        final notificationService = locator<NotificationService>();
        await notificationService.initialize();
        
        // Check auth state after notifications are initialized
        await _checkAuthState(viewModel);
      } catch (e) {
        print('Error in SplashScreen initialization: $e');
        // Navigate to home screen even if notifications fail
        if (context.mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset(
          'assets/Splash.json',
          width: 400,
          height: 400,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  void onViewModelReady(AuthViewModel viewModel) {
    super.onViewModelReady(viewModel);
    // Remove context setting from here
  }

  Future<void> _checkAuthState(AuthViewModel viewModel) async {
    await viewModel.initialize();
    
    if (!viewModel.hasListeners) return;

    final context = viewModel.currentContext;
    if (context == null) return;

    if (!viewModel.isLoggedIn) {
      // Not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else if (viewModel.userName == null) {
      // Logged in but name not set
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      // Fully authenticated
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => 
      AuthViewModel(locator<AuthService>());
} 