enum OrderStatus {
  pending,
  confirmed,
  processing,
  outForDelivery,
  delivered,
  cancelled,
  returned
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryCharge;
  final double tax;
  final double total;
  final String deliveryAddress;
  final DateTime deliveryDate;
  final String deliveryTimeSlot;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final String paymentMethod;
  final String? couponCode;
  final double? discountAmount;
  final DateTime orderDate;
  final DateTime? deliveredDate;
  final String? deliveryPersonName;
  final String? deliveryPersonPhone;
  final String? trackingNumber;
  final String? notes;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.deliveryCharge,
    required this.tax,
    required this.total,
    required this.deliveryAddress,
    required this.deliveryDate,
    required this.deliveryTimeSlot,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    this.couponCode,
    this.discountAmount,
    required this.orderDate,
    this.deliveredDate,
    this.deliveryPersonName,
    this.deliveryPersonPhone,
    this.trackingNumber,
    this.notes,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['userId'],
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      subtotal: json['subtotal'].toDouble(),
      deliveryCharge: json['deliveryCharge'].toDouble(),
      tax: json['tax'].toDouble(),
      total: json['total'].toDouble(),
      deliveryAddress: json['deliveryAddress'],
      deliveryDate: DateTime.parse(json['deliveryDate']),
      deliveryTimeSlot: json['deliveryTimeSlot'],
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
      ),
      paymentStatus: PaymentStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['paymentStatus'],
      ),
      paymentMethod: json['paymentMethod'],
      couponCode: json['couponCode'],
      discountAmount: json['discountAmount']?.toDouble(),
      orderDate: DateTime.parse(json['orderDate']),
      deliveredDate: json['deliveredDate'] != null
          ? DateTime.parse(json['deliveredDate'])
          : null,
      deliveryPersonName: json['deliveryPersonName'],
      deliveryPersonPhone: json['deliveryPersonPhone'],
      trackingNumber: json['trackingNumber'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryCharge': deliveryCharge,
      'tax': tax,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'deliveryDate': deliveryDate.toIso8601String(),
      'deliveryTimeSlot': deliveryTimeSlot,
      'status': status.toString().split('.').last,
      'paymentStatus': paymentStatus.toString().split('.').last,
      'paymentMethod': paymentMethod,
      'couponCode': couponCode,
      'discountAmount': discountAmount,
      'orderDate': orderDate.toIso8601String(),
      'deliveredDate': deliveredDate?.toIso8601String(),
      'deliveryPersonName': deliveryPersonName,
      'deliveryPersonPhone': deliveryPersonPhone,
      'trackingNumber': trackingNumber,
      'notes': notes,
    };
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'Order Pending';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.returned:
        return 'Returned';
    }
  }

  String get paymentStatusText {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Payment Pending';
      case PaymentStatus.completed:
        return 'Payment Completed';
      case PaymentStatus.failed:
        return 'Payment Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }
}

class OrderItem {
  final String productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final double total;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.total,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['productId'],
      productName: json['productName'],
      productImage: json['productImage'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      total: json['total'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'price': price,
      'quantity': quantity,
      'total': total,
    };
  }
}
