import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../services/auth_service.dart';
import '../app/locator.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/product_grid.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../widgets/app_drawer.dart';
import '../widgets/faq_section.dart';

class HomeScreen extends ViewModelBuilderWidget<AuthViewModel> {
  const HomeScreen({super.key});

  @override
  Widget builder(BuildContext context, AuthViewModel viewModel, Widget? child) {
    return _HomeScreenContent(viewModel: viewModel);
  }

  @override
  void onViewModelReady(AuthViewModel viewModel) {
    super.onViewModelReady(viewModel);
    viewModel.loadInitialProducts(); // Make sure products are loaded
  }

  @override
  AuthViewModel viewModelBuilder(BuildContext context) => 
      AuthViewModel(locator<AuthService>());
}

class _HomeScreenContent extends StatefulWidget {
  final AuthViewModel viewModel;

  const _HomeScreenContent({required this.viewModel});

  @override
  State<_HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  final ScrollController _scrollController = ScrollController();
  bool _isAppBarVisible = true;
  int _selectedIndex = 0;
  int _currentBannerIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (_isAppBarVisible) setState(() => _isAppBarVisible = false);
    }
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (!_isAppBarVisible) setState(() => _isAppBarVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            CustomAppBar(isVisible: _isAppBarVisible),
            // Navigation Buttons
            // Banner
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(
                    height: 180,
                    child: PageView.builder(
                      onPageChanged: (index) {
                        setState(() {
                          _currentBannerIndex = index;
                        });
                      },
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SvgPicture.asset(
                              'assets/banners/banner${index + 1}.svg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) => Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentBannerIndex == index
                              ? Theme.of(context).primaryColor
                              : Colors.grey[300],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // What's on your mind section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "What's on your mind?",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Row(
                          children: [
                            Image.asset('assets/icons/img_2.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_3.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_4.png', width: 100, height: 100),
                            Image.asset('assets/icons/img.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_5.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_6.png', width: 100, height: 100),
                            Image.asset('assets/icons/m7.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_8.png', width: 100, height: 100),
                            Image.asset('assets/icons/m9.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_10.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_11.png', width: 100, height: 100),
                            Image.asset('assets/icons/m12.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_13.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_14.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_15.png', width: 100, height: 100),
                            Image.asset('assets/icons/m16.png', width: 100, height: 100),
                            Image.asset('assets/icons/m17.png', width: 100, height: 100),
                            Image.asset('assets/icons/img_18.png', width: 100, height: 100),
                            Image.asset('assets/icons/m19.png', width: 100, height: 100),
                          ],
                        ),
                      ),
                    )

                  ],
                ),
              ),
            ),
            // Top Brands section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Brands',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 70, // Adjust height as needed
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildBrandLogo('', 0),
                            _buildBrandLogo('', 1),
                            _buildBrandLogo('', 2),
                            _buildBrandLogo('', 3),
                            _buildBrandLogo('', 4),
                            _buildBrandLogo('', 5),
                            _buildBrandLogo('', 6),
                            _buildBrandLogo('', 7),// Add more if needed
                          ].map((widget) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12.0),
                            child: widget,
                          )).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Best Deals section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Best Deal Near You ',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          '(India)',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Product Grid
            const ProductGrid(),

            // FAQ Section
            const FaqSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Listings'),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 32),
            label: 'Sell',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Services'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }


  Widget _buildBrandLogo(String brandName, int index) {
    return Column(
      children: [
        Image.asset(
          'assets/brands/img${index == 0 ? "" : "_$index"}.png',
          width: 60,
          height: 60,
          fit: BoxFit.contain,
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label, IconData? icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Colors.grey[600]),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(color: Colors.grey[800]),
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down, size: 18, color: Colors.grey[600]),
          ],
        ],
      ),
    );
  }

  Widget _buildProductCard({
    required String image,
    required String title,
    required String specs,
    required String price,
    required String location,
    required String date,
    bool isVerified = false,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.phone_android, color: Colors.grey[400], size: 50),
                    ),
                  ),
                ),
                if (isVerified)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ORU',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Text(
                            'Verified',
                            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.favorite_border, size: 20, color: Colors.grey),
                  ),
                ),
                if (isVerified)
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PRICE NEGOTIABLE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    specs,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          location,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        date,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
} 