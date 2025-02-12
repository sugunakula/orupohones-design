import 'package:flutter/material.dart';
import 'package:oruphones/screens/login_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.network(
                  'https://www.oruphones.com/assets/images/oru_phones_logo.svg',
                  height: 30,
                  errorBuilder: (context, error, stackTrace) {
                    return const Text(
                      'ORUphones',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
              ],
            ),
          ),
          // Login/SignUp Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3E3E9C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Login/SignUp'),
            ),
          ),
          // Sell Your Phone Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFB700),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Sell Your Phone'),
            ),
          ),
          // Menu Items with Icons
          _buildMenuItem(Icons.article_outlined, 'Blogs'),
          _buildMenuItem(Icons.headset_mic_outlined, 'Support'),
          _buildMenuItem(Icons.store_outlined, 'Register Store'),
          const SizedBox(height: 16),
          // Footer Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildGridItem(Icons.shopping_cart_outlined, 'How to Buy'),
                _buildGridItem(Icons.sell_outlined, 'How to Sell'),
                _buildGridItem(Icons.info_outline, 'About Us'),
                _buildGridItem(Icons.question_mark, 'FAQs'),
                _buildGridItem(Icons.privacy_tip_outlined, 'Privacy Policy'),
                _buildGridItem(Icons.assignment_return_outlined, 'Refund Policy'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridItem(IconData icon, String text) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: Colors.black87),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 