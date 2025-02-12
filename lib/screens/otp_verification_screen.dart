import 'package:flutter/material.dart';
import 'package:oruphones/screens/home_screen.dart';
import 'dart:async';
import 'package:stacked/stacked.dart';
import 'package:oruphones/screens/signup_screen.dart';
import 'package:oruphones/viewmodels/auth_viewmodel.dart';
import 'package:oruphones/services/auth_service.dart';
import 'package:get_it/get_it.dart';

class OtpVerificationScreen extends ViewModelBuilderWidget<AuthViewModel> {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  Widget builder(BuildContext context, AuthViewModel viewModel, Widget? child) {
    return _OtpVerificationContent(phoneNumber: phoneNumber, viewModel: viewModel);
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => 
      AuthViewModel(GetIt.I<AuthService>());
}

class _OtpVerificationContent extends StatefulWidget {
  final String phoneNumber;
  final AuthViewModel viewModel;

  const _OtpVerificationContent({
    required this.phoneNumber,
    required this.viewModel,
  });

  @override
  State<_OtpVerificationContent> createState() => _OtpVerificationContentState();
}

class _OtpVerificationContentState extends State<_OtpVerificationContent> {
  final List<TextEditingController> _controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
    (index) => FocusNode(),
  );
  
  Timer? _timer;
  int _remainingSeconds = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },

          ),
        ],
      ),
      body: Padding(
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
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Verify Mobile No.',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C2C66),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Text(
              'Please enter the 4 digital verification code sent to your mobile number ${widget.phoneNumber} via SMS',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // OTP Input Fields
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => SizedBox(
                  width: 60,
                  height: 60,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(fontSize: 24),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF2C2C66)),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 3) {
                        _focusNodes[index + 1].requestFocus();
                      }
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Resend OTP Section
            Column(
              children: [
                const Text(
                  "Didn't receive OTP?",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _canResend
                      ? () {
                          setState(() {
                            _remainingSeconds = 30;
                            _canResend = false;
                          });
                          startTimer();
                          // Implement resend logic here
                        }
                      : null,
                  child: RichText(
                    text: TextSpan(
                      text: 'Resend OTP',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF2C2C66),
                        decoration: _canResend
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                      children: [
                        if (!_canResend)
                          TextSpan(
                            text: ' in ${_remainingSeconds.toString()} Sec',
                            style: const TextStyle(
                              decoration: TextDecoration.none,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Verify OTP Button
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final otp = _controllers.map((c) => c.text).join();
                if (otp.length != 4) return;

                // Remove the '+91-' prefix from phone number before verification
                final cleanPhoneNumber = widget.phoneNumber.replaceAll('+91-', '');
                
                if (await widget.viewModel.verifyOtp(cleanPhoneNumber, otp)) {
                  if (context.mounted) {
                    if (widget.viewModel.isNewUser) {
                      // Navigate to signup screen for new users
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                        (route) => false, // Remove all previous routes
                      );
                    } else {
                      // Navigate to home screen for existing users
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                        (route) => false, // Remove all previous routes
                      );
                    }
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Invalid OTP. Please try again.'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2C66),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: widget.viewModel.isBusy
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Verify OTP',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }
} 