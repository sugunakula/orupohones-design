import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'product_card.dart';
import 'dummy_product_card.dart';
import '../screens/login_screen.dart';

class ProductGrid extends ViewModelWidget<AuthViewModel> {
  const ProductGrid({super.key});

  // List of dummy product configurations
  static const List<Map<String, String>> dummyProducts = [
    {
      'title': 'Sell Old Phone',
      'subtitle': 'Get Best Value',
      'image': 'assets/dummy/sell_phone.jpg',
    },
    {
      'title': 'Buy New Phone',
      'subtitle': 'Latest Models',
      'image': 'assets/dummy/buy_phone.jpg',
    },
    {
      'title': 'Exchange Phone',
      'subtitle': 'Upgrade Today',
      'image': 'assets/dummy/exchange_phone.jpg',
    },
  ];

  @override
  Widget build(BuildContext context, AuthViewModel viewModel) {
    print('Building ProductGrid with ${viewModel.products.length} products');

    if (viewModel.isBusy && viewModel.products.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading products...'),
            ],
          ),
        ),
      );
    }

    if (viewModel.products.isEmpty) {
      return const SliverToBoxAdapter(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No products available',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 0.6,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            // Load more when reaching end
            if (index >= viewModel.products.length - 4 && !viewModel.isBusy) {
              viewModel.loadMoreProducts();
            }

            // Show ad cards
            if (index == 3 || index == 11) {
              return _buildAdCard(index);
            }
            
            // Show dummy card after every 7th item
            if ((index + 1) % 8 == 0) {
              // Calculate which dummy product to show based on position
              final dummyIndex = ((index + 1) ~/ 8 - 1) % dummyProducts.length;
              return DummyProductCard(
                title: dummyProducts[dummyIndex]['title']!,
                subtitle: dummyProducts[dummyIndex]['subtitle']!,
                image: dummyProducts[dummyIndex]['image']!,
              );
            }

            // Get actual product index
            final productIndex = _getAdjustedIndex(index);
            if (productIndex >= viewModel.products.length) {
              // Show loading indicator at the end
              if (viewModel.isLoadingMore) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return null;
            }

            final product = viewModel.products[productIndex];
            return ProductCard(
              product: product,
              isLiked: viewModel.isProductLiked(product.id),
              onLikePressed: () {
                if (!viewModel.isLoggedIn) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => LoginScreen(
                      productIdToLike: product.id,
                    ),
                  );
                } else {
                  viewModel.toggleLike(product.id);
                }
              },
            );
          },
          childCount: viewModel.products.length + 4, // +2 for ads, +2 for loading
        ),
      ),
    );
  }

  Widget _buildAdCard(int index) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          index == 3 ? 'assets/ad/img.png' : 'assets/ad/img_1.png',
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  int _getAdjustedIndex(int index) {
    if (index > 11) {
      return index - 2; // After second ad
    } else if (index > 3) {
      return index - 1; // After first ad
    }
    return index; // Before first ad
  }
} 