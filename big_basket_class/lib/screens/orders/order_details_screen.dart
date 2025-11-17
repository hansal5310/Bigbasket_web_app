import 'package:flutter/material.dart';
import '../../models/order.dart' as order_model;

class OrderDetailsScreen extends StatelessWidget {
  final order_model.Order order;

  const OrderDetailsScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderHeader(),
            SizedBox(height: 24),
            _buildOrderItems(),
            SizedBox(height: 24),
            _buildOrderSummary(),
            SizedBox(height: 24),
            _buildDeliveryInfo(),
            SizedBox(height: 24),
            _buildPaymentInfo(),
          ],
        ),
      ),
    );
  }

  String _shortId(String id) {
    final end = id.length < 8 ? id.length : 8;
    return id.substring(0, end).toUpperCase();
  }

  Widget _buildOrderHeader() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${_shortId(order.id)}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _buildStatusChip(order.status),
              ],
            ),
            SizedBox(height: 8),
            Text(
              'Order Date: ${_formatDate(order.orderDate)}',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItems() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Items (${order.items.length})',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ...order.items.map((item) => Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(item.productImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.productName,
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text(
                              'Qty: ${item.quantity} × ₹${item.price.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '₹${item.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildSummaryRow(
                'Subtotal', '₹${order.subtotal.toStringAsFixed(2)}'),
            _buildSummaryRow('Delivery Charge',
                '₹${order.deliveryCharge.toStringAsFixed(2)}'),
            _buildSummaryRow('Tax', '₹${order.tax.toStringAsFixed(2)}'),
            if (order.discountAmount != null && order.discountAmount! > 0)
              _buildSummaryRow(
                  'Discount', '-₹${order.discountAmount!.toStringAsFixed(2)}',
                  isDiscount: true),
            Divider(),
            _buildSummaryRow(
              'Total',
              '₹${order.total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? Colors.black : Colors.grey[600],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: isTotal
                  ? Colors.green[700]
                  : (isDiscount ? Colors.red : Colors.black),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow(Icons.location_on, 'Address', order.deliveryAddress),
            _buildInfoRow(Icons.schedule, 'Delivery Date',
                '${_formatDate(order.deliveryDate)} • ${order.deliveryTimeSlot}'),
            if (order.deliveryPersonName != null)
              _buildInfoRow(
                  Icons.person, 'Delivery Person', order.deliveryPersonName!),
            if (order.deliveryPersonPhone != null)
              _buildInfoRow(Icons.phone, 'Contact', order.deliveryPersonPhone!),
            if (order.trackingNumber != null)
              _buildInfoRow(Icons.local_shipping, 'Tracking Number',
                  order.trackingNumber!),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow(Icons.payment, 'Method', order.paymentMethod),
            _buildInfoRow(Icons.info, 'Status',
                _getPaymentStatusText(order.paymentStatus)),
            if (order.couponCode != null)
              _buildInfoRow(
                  Icons.local_offer, 'Coupon Code', order.couponCode!),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
}
