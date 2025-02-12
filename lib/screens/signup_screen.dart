import 'package:flutter/material.dart';
import 'package:oruphones/screens/home_screen.dart';
import 'package:stacked/stacked.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/auth_service.dart';
import 'package:get_it/get_it.dart';

class SignupScreen extends ViewModelBuilderWidget<AuthViewModel> {
  const SignupScreen({super.key});

  @override
  Widget builder(BuildContext context, AuthViewModel viewModel, Widget? child) {
    return _SignupContent(viewModel: viewModel);
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => 
      AuthViewModel(GetIt.I<AuthService>());
}

class _SignupContent extends StatefulWidget {
  final AuthViewModel viewModel;

  const _SignupContent({required this.viewModel});

  @override
  State<_SignupContent> createState() => _SignupContentState();
}

class _SignupContentState extends State<_SignupContent> {
  final TextEditingController _nameController = TextEditingController();
  bool _isNextEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_validateInput);
  }

  void _validateInput() {
    setState(() {
      _isNextEnabled = _nameController.text.trim().isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
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
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 40),
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
              'SignUp to continue',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            // Name Input Section
            Row(
              children: [
                const Text(
                  'Please Tell Us Your Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '*',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(color: Colors.grey[400]),
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
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Confirm Name Button
            ElevatedButton(
              onPressed: _isNextEnabled && !widget.viewModel.isBusy
                  ? () async {
                      final name = _nameController.text.trim();
                      if (name.isEmpty) return;

                      if (await widget.viewModel.updateUserName(name)) {
                        if (context.mounted) {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const HomeScreen()),
                            (route) => false,
                          );
                          
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Welcome, $name!'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2C2C66),
                disabledBackgroundColor: Colors.grey[400],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: widget.viewModel.isBusy
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Confirm Name',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
} 