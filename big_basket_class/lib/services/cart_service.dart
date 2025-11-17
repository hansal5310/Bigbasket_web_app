import 'package:flutter/foundation.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get total => product.price * quantity;
}

class CartService extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final Set<String> _wishlistItems = {};

  // Cart methods
  Map<String, CartItem> get items => {..._items};
  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;

  double get subtotal {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.total;
    });
    return total;
  }

  double get deliveryCharge => subtotal > 500 ? 0.0 : 40.0;
  double get tax => subtotal * 0.05; // 5% tax
  double get totalAmount => subtotal + deliveryCharge + tax;

  // Wishlist methods
  Set<String> get wishlistItems => {..._wishlistItems};
  int get wishlistCount => _wishlistItems.length;
  bool get isWishlistEmpty => _wishlistItems.isEmpty;

  bool isInWishlist(String productId) => _wishlistItems.contains(productId);

  // Cart operations
  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product: product),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    if (!_items.containsKey(productId)) return;

    if (quantity <= 0) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => CartItem(
          product: existingItem.product,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  // Wishlist operations
  void toggleWishlist(String productId) {
    if (_wishlistItems.contains(productId)) {
      _wishlistItems.remove(productId);
    } else {
      _wishlistItems.add(productId);
    }
    notifyListeners();
  }

  void addToWishlist(String productId) {
    _wishlistItems.add(productId);
    notifyListeners();
  }

  void removeFromWishlist(String productId) {
    _wishlistItems.remove(productId);
    notifyListeners();
  }

  void clearWishlist() {
    _wishlistItems.clear();
    notifyListeners();
  }

  // Move item from wishlist to cart
  void moveToCart(Product product) {
    addItem(product);
    removeFromWishlist(product.id);
  }

  // Check if product is in cart
  bool isInCart(String productId) => _items.containsKey(productId);

  // Get cart item quantity
  int getCartItemQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }
}
