class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final String imageUrl;
  final List<String> additionalImages;
  final String category;
  final String subcategory;
  final bool isAvailable;
  final int stockQuantity;
  final double rating;
  final int reviewCount;
  final bool isOrganic;
  final bool isDiscounted;
  final String? brand;
  final String? weight;
  final String? unit;
  final List<String> tags;
  final Map<String, String> specifications;
  final bool isWishlisted;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.additionalImages = const [],
    required this.category,
    required this.subcategory,
    this.isAvailable = true,
    this.stockQuantity = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isOrganic = false,
    this.isDiscounted = false,
    this.brand,
    this.weight,
    this.unit,
    this.tags = const [],
    this.specifications = const {},
    this.isWishlisted = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      imageUrl: json['imageUrl'],
      additionalImages: List<String>.from(json['additionalImages'] ?? []),
      category: json['category'],
      subcategory: json['subcategory'],
      isAvailable: json['isAvailable'] ?? true,
      stockQuantity: json['stockQuantity'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      isOrganic: json['isOrganic'] ?? false,
      isDiscounted: json['isDiscounted'] ?? false,
      brand: json['brand'],
      weight: json['weight'],
      unit: json['unit'],
      tags: List<String>.from(json['tags'] ?? []),
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      isWishlisted: json['isWishlisted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'additionalImages': additionalImages,
      'category': category,
      'subcategory': subcategory,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
      'rating': rating,
      'reviewCount': reviewCount,
      'isOrganic': isOrganic,
      'isDiscounted': isDiscounted,
      'brand': brand,
      'weight': weight,
      'unit': unit,
      'tags': tags,
      'specifications': specifications,
      'isWishlisted': isWishlisted,
    };
  }

  double get discountPercentage {
    if (originalPrice == null || originalPrice == 0) return 0.0;
    return ((originalPrice! - price) / originalPrice! * 100).roundToDouble();
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;

  String get displayPrice {
    if (hasDiscount) {
      return '₹${price.toStringAsFixed(2)}';
    }
    return '₹${price.toStringAsFixed(2)}';
  }

  String get displayOriginalPrice {
    if (hasDiscount) {
      return '₹${originalPrice!.toStringAsFixed(2)}';
    }
    return '';
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? originalPrice,
    String? imageUrl,
    List<String>? additionalImages,
    String? category,
    String? subcategory,
    bool? isAvailable,
    int? stockQuantity,
    double? rating,
    int? reviewCount,
    bool? isOrganic,
    bool? isDiscounted,
    String? brand,
    String? weight,
    String? unit,
    List<String>? tags,
    Map<String, String>? specifications,
    bool? isWishlisted,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      additionalImages: additionalImages ?? this.additionalImages,
      category: category ?? this.category,
      subcategory: subcategory ?? this.subcategory,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isOrganic: isOrganic ?? this.isOrganic,
      isDiscounted: isDiscounted ?? this.isDiscounted,
      brand: brand ?? this.brand,
      weight: weight ?? this.weight,
      unit: unit ?? this.unit,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
      isWishlisted: isWishlisted ?? this.isWishlisted,
    );
  }
}
