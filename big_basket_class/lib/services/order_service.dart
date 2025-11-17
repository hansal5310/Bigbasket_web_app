import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import '../models/order.dart' as order_model;
import 'cart_service.dart';

class OrderService extends ChangeNotifier {
  List<order_model.Order> _orders = [];
  bool _isLoading = false;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;

  List<order_model.Order> get orders => [..._orders];
  bool get isLoading => _isLoading;
  bool get hasOrders => _orders.isNotEmpty;

  // Mock orders for development
  List<order_model.Order> get mockOrders => [
        order_model.Order(
          id: '1',
          userId: '1',
          items: [
            order_model.OrderItem(
              productId: '1',
              productName: 'Fresh Organic Tomatoes',
              productImage:
                  'https://images.unsplash.com/photo-1546094096-0df4bcaaa337?w=100&h=100&fit=crop',
              price: 45.0,
              quantity: 2,
              total: 90.0,
            ),
            order_model.OrderItem(
              productId: '2',
              productName: 'Sweet Corn',
              productImage:
                  'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=100&h=100&fit=crop',
              price: 30.0,
              quantity: 1,
              total: 30.0,
            ),
          ],
          subtotal: 120.0,
          deliveryCharge: 40.0,
          tax: 6.0,
          total: 166.0,
          deliveryAddress:
              '123 Main Street, Apartment 4B, Mumbai, Maharashtra - 400001',
          deliveryDate: DateTime.now().add(Duration(days: 1)),
          deliveryTimeSlot: '10:00 AM - 12:00 PM',
          status: order_model.OrderStatus.confirmed,
          paymentStatus: order_model.PaymentStatus.completed,
          paymentMethod: 'UPI',
          orderDate: DateTime.now().subtract(Duration(hours: 2)),
        ),
        order_model.Order(
          id: '2',
          userId: '1',
          items: [
            order_model.OrderItem(
              productId: '3',
              productName: 'Fresh Milk',
              productImage:
                  'https://images.unsplash.com/photo-1550583724-b2692b85b150?w=100&h=100&fit=crop',
              price: 60.0,
              quantity: 1,
              total: 60.0,
            ),
          ],
          subtotal: 60.0,
          deliveryCharge: 0.0,
          tax: 3.0,
          total: 63.0,
          deliveryAddress:
              '123 Main Street, Apartment 4B, Mumbai, Maharashtra - 400001',
          deliveryDate: DateTime.now().add(Duration(days: 3)),
          deliveryTimeSlot: '2:00 PM - 4:00 PM',
          status: order_model.OrderStatus.processing,
          paymentStatus: order_model.PaymentStatus.completed,
          paymentMethod: 'Credit Card',
          orderDate: DateTime.now().subtract(Duration(days: 1)),
        ),
        order_model.Order(
          id: '3',
          userId: '1',
          items: [
            order_model.OrderItem(
              productId: '4',
              productName: 'Whole Wheat Bread',
              productImage:
                  'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=100&h=100&fit=crop',
              price: 35.0,
              quantity: 2,
              total: 70.0,
            ),
            order_model.OrderItem(
              productId: '5',
              productName: 'Fresh Eggs',
              productImage:
                  'https://images.unsplash.com/photo-1569288063648-5bb9348b0b0b?w=100&h=100&fit=crop',
              price: 120.0,
              quantity: 1,
              total: 120.0,
            ),
          ],
          subtotal: 190.0,
          deliveryCharge: 0.0,
          tax: 9.5,
          total: 199.5,
          deliveryAddress:
              '123 Main Street, Apartment 4B, Mumbai, Maharashtra - 400001',
          deliveryDate: DateTime.now().subtract(Duration(days: 5)),
          deliveryTimeSlot: '11:00 AM - 1:00 PM',
          status: order_model.OrderStatus.delivered,
          paymentStatus: order_model.PaymentStatus.completed,
          paymentMethod: 'UPI',
          orderDate: DateTime.now().subtract(Duration(days: 6)),
          deliveredDate: DateTime.now().subtract(Duration(days: 5, hours: 2)),
          deliveryPersonName: 'Rahul Kumar',
          deliveryPersonPhone: '+91 98765 12345',
          trackingNumber: 'TRK123456789',
        ),
      ];

  Future<void> loadOrders() async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        _orders = [];
        _isLoading = false;
        notifyListeners();
        return;
      }

      // Load orders from Firestore for current user
      final querySnapshot = await _db
          .collection('orders')
          .where('userId', isEqualTo: user.uid)
          .orderBy('orderDate', descending: true)
          .get();

      _orders = querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return orderFromFirestore(data);
      }).toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('Error loading orders: $e');
      _orders = [];
      _isLoading = false;
      notifyListeners();
    }
  }

  static order_model.Order orderFromFirestore(Map<String, dynamic> data) {
    // Convert Firestore data to Order model
    final items = (data['items'] as List<dynamic>? ?? []).map((item) {
      return order_model.OrderItem(
        productId: item['productId'] ?? '',
        productName: item['productName'] ?? '',
        productImage: item['productImage'] ?? '',
        price: (item['price'] as num?)?.toDouble() ?? 0.0,
        quantity: item['quantity'] ?? 1,
        total: (item['total'] as num?)?.toDouble() ?? 0.0,
      );
    }).toList();

    // Parse status
    order_model.OrderStatus _parseStatus(String? status) {
      if (status == null) return order_model.OrderStatus.pending;
      switch (status.toLowerCase()) {
        case 'pending':
          return order_model.OrderStatus.pending;
        case 'confirmed':
          return order_model.OrderStatus.confirmed;
        case 'processing':
          return order_model.OrderStatus.processing;
        case 'out for delivery':
        case 'outfordelivery':
          return order_model.OrderStatus.outForDelivery;
        case 'delivered':
          return order_model.OrderStatus.delivered;
        case 'cancelled':
        case 'canceled':
          return order_model.OrderStatus.cancelled;
        case 'returned':
          return order_model.OrderStatus.returned;
        default:
          return order_model.OrderStatus.pending;
      }
    }

    // Parse payment status
    order_model.PaymentStatus _parsePaymentStatus(String? status) {
      if (status == null) return order_model.PaymentStatus.pending;
      switch (status.toLowerCase()) {
        case 'pending':
          return order_model.PaymentStatus.pending;
        case 'completed':
          return order_model.PaymentStatus.completed;
        case 'failed':
          return order_model.PaymentStatus.failed;
        case 'refunded':
          return order_model.PaymentStatus.refunded;
        default:
          return order_model.PaymentStatus.pending;
      }
    }

    // Parse dates
    DateTime _parseDate(dynamic date) {
      if (date == null) return DateTime.now();
      if (date is Timestamp) {
        return date.toDate();
      }
      if (date is String) {
        try {
          return DateTime.parse(date);
        } catch (e) {
          return DateTime.now();
        }
      }
      return DateTime.now();
    }

    final status = _parseStatus(data['status']?.toString());
    final paymentStatus =
        _parsePaymentStatus(data['paymentStatus']?.toString());
    final orderDate = _parseDate(data['orderDate']);
    final deliveryDate = _parseDate(data['deliveryDate']);

    return order_model.Order(
      id: data['id'] ?? '',
      userId: data['userId'] ?? '',
      items: items,
      subtotal: (data['subtotal'] as num?)?.toDouble() ?? 0.0,
      deliveryCharge: (data['deliveryCharge'] as num?)?.toDouble() ?? 0.0,
      tax: (data['tax'] as num?)?.toDouble() ?? 0.0,
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      deliveryAddress: data['deliveryAddress'] ?? '',
      deliveryDate: deliveryDate,
      deliveryTimeSlot: data['deliveryTimeSlot'] ?? '',
      status: status,
      paymentStatus: paymentStatus,
      paymentMethod: data['paymentMethod'] ?? '',
      couponCode: data['couponCode'],
      discountAmount: (data['discountAmount'] as num?)?.toDouble(),
      orderDate: orderDate,
      deliveredDate: data['deliveredDate'] != null
          ? _parseDate(data['deliveredDate'])
          : null,
      deliveryPersonName: data['deliveryPersonName'],
      deliveryPersonPhone: data['deliveryPersonPhone'],
      trackingNumber: data['trackingNumber'],
      notes: data['notes'],
    );
  }

  Future<order_model.Order> createOrder({
    required CartService cartService,
    required String deliveryAddress,
    required DateTime deliveryDate,
    required String deliveryTimeSlot,
    required String paymentMethod,
    String? couponCode,
    double? discountAmount,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final user = _auth.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Get user data
      final userDoc = await _db.collection('users').doc(user.uid).get();
      final userData = userDoc.data() ?? {};

      // Get cart items with quantities from CartService
      final orderItems = cartService.items.values.map((cartItem) {
        return {
          'productId': cartItem.product.id,
          'productName': cartItem.product.name,
          'productImage': cartItem.product.imageUrl,
          'price': cartItem.product.price,
          'quantity': cartItem.quantity,
          'total': cartItem.product.price * cartItem.quantity,
        };
      }).toList();

      final subtotal = orderItems.fold(
          0.0, (sum, item) => sum + (item['total'] as num).toDouble());
      final deliveryCharge = subtotal > 500 ? 0.0 : 40.0;
      final tax = subtotal * 0.05;
      final total = subtotal + deliveryCharge + tax - (discountAmount ?? 0.0);

      // Save to Firestore
      final orderData = {
        'userId': user.uid,
        'customerName': userData['name'] ?? 'Customer',
        'customerEmail': user.email ?? '',
        'customerPhone': userData['phone'] ?? '',
        'items': orderItems,
        'subtotal': subtotal,
        'deliveryCharge': deliveryCharge,
        'tax': tax,
        'total': total,
        'deliveryAddress': deliveryAddress,
        'deliveryDate': Timestamp.fromDate(deliveryDate),
        'deliveryTimeSlot': deliveryTimeSlot,
        'status': 'Pending',
        'paymentStatus': 'Pending',
        'paymentMethod': paymentMethod,
        'couponCode': couponCode,
        'discountAmount': discountAmount ?? 0.0,
        'orderDate': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      final docRef = await _db.collection('orders').add(orderData);
      final orderId = docRef.id;

      final order = order_model.Order(
        id: orderId,
        userId: user.uid,
        items: cartService.items.values.map((cartItem) {
          return order_model.OrderItem(
            productId: cartItem.product.id,
            productName: cartItem.product.name,
            productImage: cartItem.product.imageUrl,
            price: cartItem.product.price,
            quantity: cartItem.quantity,
            total: cartItem.product.price * cartItem.quantity,
          );
        }).toList(),
        subtotal: subtotal,
        deliveryCharge: deliveryCharge,
        tax: tax,
        total: total,
        deliveryAddress: deliveryAddress,
        deliveryDate: deliveryDate,
        deliveryTimeSlot: deliveryTimeSlot,
        status: order_model.OrderStatus.pending,
        paymentStatus: order_model.PaymentStatus.pending,
        paymentMethod: paymentMethod,
        couponCode: couponCode,
        discountAmount: discountAmount,
        orderDate: DateTime.now(),
      );

      _orders.insert(0, order);
      _isLoading = false;
      notifyListeners();

      return order;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to create order: $e');
    }
  }

  Future<void> updateOrderStatus(
      String orderId, order_model.OrderStatus status) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 500));

      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        final order = _orders[orderIndex];
        final updatedOrder = order_model.Order(
          id: order.id,
          userId: order.userId,
          items: order.items,
          subtotal: order.subtotal,
          deliveryCharge: order.deliveryCharge,
          tax: order.tax,
          total: order.total,
          deliveryAddress: order.deliveryAddress,
          deliveryDate: order.deliveryDate,
          deliveryTimeSlot: order.deliveryTimeSlot,
          status: status,
          paymentStatus: order.paymentStatus,
          paymentMethod: order.paymentMethod,
          couponCode: order.couponCode,
          discountAmount: order.discountAmount,
          orderDate: order.orderDate,
          deliveredDate: status == order_model.OrderStatus.delivered
              ? DateTime.now()
              : order.deliveredDate,
          deliveryPersonName: order.deliveryPersonName,
          deliveryPersonPhone: order.deliveryPersonPhone,
          trackingNumber: order.trackingNumber,
          notes: order.notes,
        );
        _orders[orderIndex] = updatedOrder;
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, order_model.OrderStatus.cancelled);
  }

  order_model.Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  List<order_model.Order> getOrdersByStatus(order_model.OrderStatus status) {
    return _orders.where((order) => order.status == status).toList();
  }

  List<order_model.Order> getRecentOrders(int count) {
    return _orders.take(count).toList();
  }
}
