import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('orders').orderBy('orderDate', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
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
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              data['id'] = doc.id;

              return Card(
                margin: EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(data['status']).withOpacity(0.2),
                    child: Icon(
                      Icons.shopping_bag,
                      color: _getStatusColor(data['status']),
                    ),
                  ),
                  title: Text(
                    'Order #${data['id'].toString().substring(0, 8).toUpperCase()}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer: ${data['customerName'] ?? 'N/A'}'),
                      Text('Total: ₹${data['total'] ?? 0}'),
                      Text(
                        'Date: ${_formatDate(data['orderDate'])}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  trailing: Chip(
                    label: Text(
                      data['status'] ?? 'Pending',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    backgroundColor: _getStatusColor(data['status']),
                  ),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildDetailRow('Order ID', data['id']),
                          _buildDetailRow('Customer', data['customerName'] ?? 'N/A'),
                          _buildDetailRow('Email', data['customerEmail'] ?? 'N/A'),
                          _buildDetailRow('Phone', data['customerPhone'] ?? 'N/A'),
                          _buildDetailRow('Delivery Address', data['deliveryAddress'] ?? 'N/A'),
                          _buildDetailRow('Payment Method', data['paymentMethod'] ?? 'N/A'),
                          _buildDetailRow('Payment Status', data['paymentStatus'] ?? 'Pending'),
                          _buildDetailRow('Total Amount', '₹${data['total'] ?? 0}'),
                          _buildDetailRow('Order Date', _formatDate(data['orderDate'])),
                          _buildDetailRow('Delivery Date', _formatDate(data['deliveryDate'])),
                          SizedBox(height: 16),
                          Text(
                            'Items:',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          ...(data['items'] as List<dynamic>? ?? []).map((item) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text('${item['name']} x ${item['quantity']}'),
                                  ),
                                  Text('₹${item['price'] * item['quantity']}'),
                                ],
                              ),
                            );
                          }).toList(),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _updateOrderStatus(
                                    context,
                                    doc.id,
                                    data['status'],
                                  ),
                                  child: Text('Update Status'),
                                ),
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => _viewOrderDetails(context, data),
                                  child: Text('View Details'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'out for delivery':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    if (date is Timestamp) {
      return DateFormat('dd/MM/yyyy HH:mm').format(date.toDate());
    }
    return 'N/A';
  }

  Future<void> _updateOrderStatus(
    BuildContext context,
    String orderId,
    String? currentStatus,
  ) async {
    final statuses = [
      'Pending',
      'Confirmed',
      'Processing',
      'Out for Delivery',
      'Delivered',
      'Cancelled',
    ];

    final newStatus = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Order Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            return RadioListTile<String>(
              title: Text(status),
              value: status,
              groupValue: currentStatus,
              onChanged: (value) => Navigator.pop(context, value),
            );
          }).toList(),
        ),
      ),
    );

    if (newStatus != null && newStatus != currentStatus) {
      try {
        await _db.collection('orders').doc(orderId).update({
          'status': newStatus,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order status updated to $newStatus'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating status: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _viewOrderDetails(BuildContext context, Map<String, dynamic> orderData) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Order ID', orderData['id']),
              _buildDetailRow('Status', orderData['status'] ?? 'Pending'),
              _buildDetailRow('Total', '₹${orderData['total'] ?? 0}'),
              _buildDetailRow('Payment', orderData['paymentMethod'] ?? 'N/A'),
              _buildDetailRow('Address', orderData['deliveryAddress'] ?? 'N/A'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}

