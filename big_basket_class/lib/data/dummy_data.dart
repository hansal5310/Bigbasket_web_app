import '../models/product.dart';

// Categories
final List<Map<String, dynamic>> categories = [
  {
    'id': '1',
    'name': 'Vegetables & Fruits',
    'icon': '🥬',
    'color': 0xFF4CAF50,
    'subcategories': ['Fresh Vegetables', 'Fresh Fruits', 'Organic', 'Exotic']
  },
  {
    'id': '2',
    'name': 'Dairy & Bakery',
    'icon': '🥛',
    'color': 0xFFFFEB3B,
    'subcategories': ['Milk', 'Cheese', 'Bread', 'Pastries']
  },
  {
    'id': '3',
    'name': 'Meat & Seafood',
    'icon': '🥩',
    'color': 0xFFE91E63,
    'subcategories': ['Chicken', 'Fish', 'Mutton', 'Pork']
  },
  {
    'id': '4',
    'name': 'Foodgrains & Staples',
    'icon': '🌾',
    'color': 0xFF795548,
    'subcategories': ['Rice', 'Wheat', 'Pulses', 'Oils']
  },
  {
    'id': '5',
    'name': 'Beverages',
    'icon': '🥤',
    'color': 0xFF2196F3,
    'subcategories': ['Juices', 'Soft Drinks', 'Tea', 'Coffee']
  },
  {
    'id': '6',
    'name': 'Snacks & Munchies',
    'icon': '🍿',
    'color': 0xFFFF9800,
    'subcategories': ['Chips', 'Nuts', 'Biscuits', 'Chocolates']
  }
];

// Banners
final List<Map<String, dynamic>> banners = [
  {
    'id': '1',
    'image':
        'https://images.unsplash.com/photo-1542838132-92c53300491e?w=800&h=400&fit=crop',
    'title': 'Fresh Vegetables',
    'subtitle': 'Up to 40% off',
    'color': 0xFF4CAF50
  },
  {
    'id': '2',
    'image':
        'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=800&h=400&fit=crop',
    'title': 'Organic Fruits',
    'subtitle': 'Farm to Table',
    'color': 0xFF8BC34A
  },
  {
    'id': '3',
    'image':
        'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=800&h=400&fit=crop',
    'title': 'Fresh Dairy',
    'subtitle': 'Pure & Natural',
    'color': 0xFFFFEB3B
  }
];

// Products
final List<Product> dummyProducts = [
  // Vegetables
  Product(
      id: '1',
      name: 'Fresh Organic Tomatoes',
      description:
          'Fresh, juicy organic tomatoes perfect for salads and cooking. Rich in vitamins and antioxidants.',
      price: 45.0,
      originalPrice: 60.0,
      imageUrl: 'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=300&h=300&fit=crop',
      category: 'Vegetables & Fruits',
      subcategory: 'Fresh Vegetables',
      isAvailable: true,
      stockQuantity: 50,
      rating: 4.5,
      reviewCount: 128,
      isOrganic: true,
      isDiscounted: true,
      brand: 'Organic Valley',
      weight: '500g',
      unit: 'pack',
      tags: [
        'organic',
        'fresh',
        'vitamin-c'
      ],
      specifications: {
        'Origin': 'Local Farm',
        'Storage': 'Refrigerate',
        'Shelf Life': '7 days'
      }),
  Product(
      id: '2',
      name: 'Sweet Corn',
      description:
          'Sweet and tender corn kernels, perfect for salads, soups, and side dishes.',
      price: 30.0,
      imageUrl:
          'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=300&h=300&fit=crop',
      category: 'Vegetables & Fruits',
      subcategory: 'Fresh Vegetables',
      isAvailable: true,
      stockQuantity: 75,
      rating: 4.3,
      reviewCount: 89,
      isOrganic: false,
      brand: 'Fresh Farm',
      weight: '400g',
      unit: 'pack'),
  Product(
      id: '3',
      name: 'Fresh Milk',
      description:
          'Pure, fresh milk from grass-fed cows. Rich in calcium and essential nutrients.',
      price: 60.0,
      imageUrl:
          'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=300&h=300&fit=crop',
      category: 'Dairy & Bakery',
      subcategory: 'Milk',
      isAvailable: true,
      stockQuantity: 100,
      rating: 4.7,
      reviewCount: 256,
      isOrganic: true,
      brand: 'Amul',
      weight: '1L',
      unit: 'bottle'),
  Product(
      id: '4',
      name: 'Whole Wheat Bread',
      description:
          'Freshly baked whole wheat bread, rich in fiber and nutrients.',
      price: 35.0,
      imageUrl:
          'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=300&h=300&fit=crop',
      category: 'Dairy & Bakery',
      subcategory: 'Bread',
      isAvailable: true,
      stockQuantity: 40,
      rating: 4.4,
      reviewCount: 167,
      isOrganic: false,
      brand: 'Britannia',
      weight: '400g',
      unit: 'loaf'),
  Product(
      id: '5',
      name: 'Fresh Eggs',
      description:
          'Farm fresh eggs from free-range chickens. Rich in protein and essential nutrients.',
      price: 120.0,
      imageUrl:
          'https://images.unsplash.com/photo-1569288063648-5bb9348b0b0b?w=300&h=300&fit=crop',
      category: 'Dairy & Bakery',
      subcategory: 'Dairy',
      isAvailable: true,
      stockQuantity: 200,
      rating: 4.6,
      reviewCount: 198,
      isOrganic: true,
      brand: 'Farm Fresh',
      weight: '12 pieces',
      unit: 'dozen'),
  Product(
      id: '6',
      name: 'Fresh Bananas',
      description:
          'Sweet and nutritious bananas, perfect for snacking and smoothies.',
      price: 40.0,
      originalPrice: 50.0,
      imageUrl:
          'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=300&h=300&fit=crop',
      category: 'Vegetables & Fruits',
      subcategory: 'Fresh Fruits',
      isAvailable: true,
      stockQuantity: 150,
      rating: 4.2,
      reviewCount: 134,
      isOrganic: false,
      isDiscounted: true,
      brand: 'Fresh Fruits Co',
      weight: '1kg',
      unit: 'bunch'),
  Product(
      id: '7',
      name: 'Chicken Breast',
      description: 'Fresh, boneless chicken breast, perfect for healthy meals.',
      price: 180.0,
      imageUrl:
          'https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=300&h=300&fit=crop',
      category: 'Meat & Seafood',
      subcategory: 'Chicken',
      isAvailable: true,
      stockQuantity: 60,
      rating: 4.5,
      reviewCount: 89,
      isOrganic: false,
      brand: 'Fresh Meat Co',
      weight: '500g',
      unit: 'pack'),
  Product(
      id: '8',
      name: 'Basmati Rice',
      description: 'Premium quality basmati rice, long grain and aromatic.',
      price: 85.0,
      imageUrl:
          'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=300&h=300&fit=crop',
      category: 'Foodgrains & Staples',
      subcategory: 'Rice',
      isAvailable: true,
      stockQuantity: 80,
      rating: 4.4,
      reviewCount: 156,
      isOrganic: false,
      brand: 'India Gate',
      weight: '1kg',
      unit: 'pack')
];

// Offers
final List<Map<String, dynamic>> offers = [
  {
    'id': '1',
    'title': 'First Order',
    'description': 'Get 20% off on your first order',
    'discount': '20%',
    'code': 'FIRST20',
    'validUntil': DateTime.now().add(Duration(days: 30)),
    'minOrder': 200.0
  },
  {
    'id': '2',
    'title': 'Free Delivery',
    'description': 'Free delivery on orders above ₹500',
    'discount': '₹40',
    'code': 'FREEDEL',
    'validUntil': DateTime.now().add(Duration(days: 60)),
    'minOrder': 500.0
  },
  {
    'id': '3',
    'title': 'Organic Discount',
    'description': '15% off on all organic products',
    'discount': '15%',
    'code': 'ORGANIC15',
    'validUntil': DateTime.now().add(Duration(days: 45)),
    'minOrder': 300.0
  }
];
