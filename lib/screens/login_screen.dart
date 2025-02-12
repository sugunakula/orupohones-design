import 'package:flutter/material.dart';
import 'package:oruphones/screens/home_screen.dart';
import 'package:stacked/stacked.dart';
import '../services/auth_service.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../app/locator.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends ViewModelBuilderWidget<AuthViewModel> {
  final String? productIdToLike;

  const LoginScreen({
    super.key,
    this.productIdToLike,
  });

  @override
  Widget builder(BuildContext context, AuthViewModel viewModel, Widget? child) {
    if (viewModel.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        if (productIdToLike != null) {
          viewModel.toggleLike(productIdToLike!);
        }
      });
    }

    final phoneController = TextEditingController();
    bool acceptTerms = false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        title: viewModel.isLoggedIn
            ? Text(
          viewModel.userName ?? '',
          style: const TextStyle(
            color: Color(0xFF2C2C66),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        )
            : const Text(
          'Login',
          style: TextStyle(
            color: Color(0xFF2C2C66),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: StatefulBuilder(
        builder: (context, setState) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo
                Center(
                  child: Image.network(
                    'https://www.oruphones.com/assets/images/oru_phones_logo.svg',
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text(
                        'ORUphones',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                // Welcome Text
                const Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C2C66),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Phone Number Section
                const Text(
                  'Enter Your Phone Number',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: const Text(
                          '+91',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: 'Mobile Number',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Terms and Conditions
                Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: acceptTerms,
                        onChanged: (value) {
                          setState(() {
                            acceptTerms = value ?? false;
                          });
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Accept ',
                      style: TextStyle(fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle terms and condition tap
                      },
                      child: const Text(
                        'Terms and condition',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2C2C66),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Next Button
                ElevatedButton(
                  onPressed: (!acceptTerms || viewModel.isBusy || phoneController.text.length != 10)
                      ? null
                      : () async {
                    if (await viewModel.createOtp(phoneController.text)) {
                      if (context.mounted) {
                        Navigator.push<void>(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpVerificationScreen(
                              phoneNumber: '+91-${phoneController.text}',
                            ),
                          ),
                        );
                      }
                    } else {
                      if (context.mounted) {  // Check if context is still valid
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to send OTP. Please try again.'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2C66),
                    disabledBackgroundColor: Colors.grey[400],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: viewModel.isBusy
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) =>
      AuthViewModel(locator<AuthService>());

  @override
  void onViewModelReady(AuthViewModel viewModel) {
    super.onViewModelReady(viewModel);
  }
}
