import 'package:flutter/material.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Frequently Asked Questions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildExpandableItem(
                  'Why should you buy used phones on ORUphones?',
                  'Explanation text here...',
                ),
                _buildExpandableItem(
                  'How to sell phone on ORUphones ?',
                  '''You can sell used phones online through ORUphones in three steps:

Step 1: Add your Device
Click on the "Sell Now" button available at the top right corner of the ORUphones homepage, select your device, add the mobile details on the listing page, and enter your expected price for the device.

Step 2: Device Verification
After listing your device, we recommend you verify your device. To verify your device, download the ORUphones app on the device you want to sell. Run and follow the instructions in the app & perform diagnostics to complete the verification process. After verification is "verified" badge will be displayed along with your listing.

Step 3: Get Offers
You will start receiving offers for your listing. If the price and buyer location suits you, you can proceed with the buyer verification process in the ORUphones app. If satisfied you can conclude the deal and get instant payment from the buyer.''',
                ),
                _buildExpandableItem(
                  'Why should you buy used phones on ORUphones?',
                  'Explanation text here...',
                ),
              ],
            ),
          ),
          // Bottom Image
          Image.asset(
            'assets/icons/img_1.png',
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableItem(String title, String content) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.grey[300]!),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 