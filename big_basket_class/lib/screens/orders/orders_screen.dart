import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/order_service.dart';
import '../../services/user_service.dart';
import '../../models/order.dart' as order_model;
import 'order_details_screen.dart';

class OrdersScreen extends StatefulWidget {
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Load orders from Firestore
      context.read<OrderService>().loadOrders();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: 'All'),
            Tab(text: 'Pending'),
            Tab(text: 'Processing'),
            Tab(text: 'Out for Delivery'),
            Tab(text: 'Delivered'),
          ],
        ),
      ),
      body: Consumer<UserService>(
        builder: (context, userService, child) {
          if (userService.currentUser == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Please login to view orders',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          final userId = FirebaseAuth.instance.currentUser?.uid;
          if (userId == null) {
            return Center(child: Text('User not found'));
          }

          // Use real-time Firestore stream
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('userId', isEqualTo: userId)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Colors.green));
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined,
                          size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No orders yet',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Start shopping to see your orders here',
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, '/home'),
                        child: Text('Start Shopping'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Convert Firestore docs to Order models and sort by date
              final orders = snapshot.data!.docs.map((doc) {
                final data = doc.data() as Map<String, dynamic>;
                data['id'] = doc.id;
                return OrderService.orderFromFirestore(data);
              }).toList()
                ..sort((a, b) => b.orderDate.compareTo(a.orderDate));

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildOrdersList(orders),
                  _buildOrdersList(orders.where((o) => o.status == order_model.OrderStatus.pending).toList()),
                  _buildOrdersList(orders.where((o) => o.status == order_model.OrderStatus.processing).toList()),
                  _buildOrdersList(orders.where((o) => o.status == order_model.OrderStatus.outForDelivery).toList()),
                  _buildOrdersList(orders.where((o) => o.status == order_model.OrderStatus.delivered).toList()),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildOrdersList(List<order_model.Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No orders in this category',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Orders will appear here after you place them',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await context.read<OrderService>().loadOrders();
      },
      child: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(order);
        },
      ),
    );
  }

  Widget _buildOrderCard(order_model.Order order) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(order: order),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${_shortId(order.id)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  _buildStatusChip(order.status),
                ],
              ),
              SizedBox(height: 12),

              // Order Items Preview
              ...order.items.take(2).map((item) => Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(item.productImage),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.productName,
                                style: TextStyle(fontWeight: FontWeight.w500),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'Qty: ${item.quantity} × ₹${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),

              if (order.items.length > 2)
                Padding(
                  padding: EdgeInsets.only(left: 52, top: 4),
                  child: Text(
                    '+${order.items.length - 2} more items',
                    style: TextStyle(
                      color: Colors.green[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              Divider(height: 24),

              // Order Details
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order Date',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        _formatDate(order.orderDate),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '₹${order.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Payment and Delivery Info
              Row(
                children: [
                  _buildInfoChip(
                    'Payment: ${_getPaymentStatusText(order.paymentStatus)}',
                    _getPaymentStatusColor(order.paymentStatus),
                  ),
                  SizedBox(width: 8),
                  _buildInfoChip(
                    order.paymentMethod,
                    Colors.blue,
                  ),
                ],
              ),

              SizedBox(height: 12),

              // Delivery Info
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.deliveryAddress,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8),

              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${_formatDate(order.deliveryDate)} • ${order.deliveryTimeSlot}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailsScreen(order: order),
                        ),
                      ),
                      child: Text('View Details'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.green),
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  if (order.status == order_model.OrderStatus.pending ||
                      order.status == order_model.OrderStatus.confirmed)
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _cancelOrder(order.id),
                        child: Text('Cancel'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _shortId(String id) {
    final end = id.length < 8 ? id.length : 8;
    return id.substring(0, end).toUpperCase();
  }

  Widget _buildStatusChip(order_model.OrderStatus status) {
    Color color;
    String text;
    IconData icon;

    switch (status) {
      case order_model.OrderStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        icon = Icons.schedule;
        break;
      case order_model.OrderStatus.confirmed:
        color = Colors.blue;
        text = 'Confirmed';
        icon = Icons.check_circle;
        break;
      case order_model.OrderStatus.processing:
        color = Colors.purple;
        text = 'Processing';
        icon = Icons.settings;
        break;
      case order_model.OrderStatus.outForDelivery:
        color = Colors.indigo;
        text = 'Out for Delivery';
        icon = Icons.local_shipping;
        break;
      case order_model.OrderStatus.delivered:
        color = Colors.green;
        text = 'Delivered';
        icon = Icons.done_all;
        break;
      case order_model.OrderStatus.cancelled:
        color = Colors.red;
        text = 'Cancelled';
        icon = Icons.cancel;
        break;
      case order_model.OrderStatus.returned:
        color = Colors.grey;
        text = 'Returned';
        icon = Icons.undo;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getPaymentStatusText(order_model.PaymentStatus status) {
    switch (status) {
      case order_model.PaymentStatus.pending:
        return 'Pending';
      case order_model.PaymentStatus.completed:
        return 'Completed';
      case order_model.PaymentStatus.failed:
        return 'Failed';
      case order_model.PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  Color _getPaymentStatusColor(order_model.PaymentStatus status) {
    switch (status) {
      case order_model.PaymentStatus.pending:
        return Colors.orange;
      case order_model.PaymentStatus.completed:
        return Colors.green;
      case order_model.PaymentStatus.failed:
        return Colors.red;
      case order_model.PaymentStatus.refunded:
        return Colors.blue;
    }
  }

  void _cancelOrder(String orderId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Order'),
        content: Text(
            'Are you sure you want to cancel this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<OrderService>().cancelOrder(orderId);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Order cancelled successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to cancel order: $e')),
                );
              }
            },
            child: Text('Yes, Cancel'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
