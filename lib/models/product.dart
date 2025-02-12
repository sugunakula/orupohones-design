class Product {
  final String id;
  final String make;
  final String model;
  final String condition;
  final String storage;
  final double price;
  final bool verified;
  final String imageUrl;
  final String location;
  final String listedDate;

  Product({
    required this.id,
    required this.make,
    required this.model,
    required this.condition,
    required this.storage,
    required this.price,
    required this.verified,
    required this.imageUrl,
    required this.location,
    required this.listedDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Handle price conversion from String or int to double
    double parsePrice(dynamic price) {
      if (price == null) return 0.0;
      if (price is double) return price;
      if (price is int) return price.toDouble();
      if (price is String) return double.tryParse(price) ?? 0.0;
      return 0.0;
    }

    return Product(
      id: json['_id'] ?? '',
      make: json['make'] ?? '',
      model: json['marketingName'] ?? '',
      condition: json['deviceCondition'] ?? '',
      storage: json['deviceStorage'] ?? '',
      price: parsePrice(json['listingPrice']),
      verified: json['verified'] ?? false,
      imageUrl: json['defaultImage']?['fullImage'] ?? '',
      location: json['listingLocation'] ?? '',
      listedDate: json['listingDate'] ?? '',
    );
  }
} 