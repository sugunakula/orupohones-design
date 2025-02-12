import 'package:flutter/material.dart';
import 'package:oruphones/screens/login_screen.dart';
import 'dart:ui';


class CustomAppBar extends StatelessWidget {
  final bool isVisible;

  const CustomAppBar({super.key, required this.isVisible});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: false,
      elevation: 0,
      backgroundColor: Colors.transparent, // Make background transparent
      expandedHeight: 220,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0), // Apply blur effect
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isVisible ? 1.0 : 0.0,
            child: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const SizedBox(width: 2),
                          const Text(
                            'ORUphones',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white.withOpacity(0.3), // Adjust transparency
                                ),
                                child: Row(
                                  children: [
                                    const Text('India'),
                                    const SizedBox(width: 4),
                                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black87,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: const Text('Login'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search phones with make, model, company...',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: const Icon(Icons.mic),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3), // Slight transparency
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.3),
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.grey),
                                ),
                              ),
                              onPressed: () {
                                // Handle navigation
                              },
                              child: Text('Sell Used Phones'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.3),
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.grey),
                                ),
                              ),
                              onPressed: () {
                                // Handle navigation
                              },
                              child: Text('Buy Used Phones'),
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.3),
                                foregroundColor: Colors.black,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.grey),
                                ),
                              ),
                              onPressed: () {
                                // Handle navigation
                              },
                              child: Text('Compare Prices'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}
