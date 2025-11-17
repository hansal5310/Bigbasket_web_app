import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/order.dart' as order_model;

class ReceiptDetailScreen extends StatelessWidget {
  final order_model.Order order;

  const ReceiptDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt Details'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => _shareReceipt(context),
          ),
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () => _downloadReceipt(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Receipt Header
            _buildReceiptHeader(),
            SizedBox(height: 24),

            // Order Items
            _buildOrderItems(),
            SizedBox(height: 24),

            // Order Summary
            _buildOrderSummary(),
            SizedBox(height: 24),

            // Delivery Information
            _buildDeliveryInfo(),
            SizedBox(height: 24),

            // Payment Information
            _buildPaymentInfo(),
            SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  String _shortId(String id) {
    final end = id.length < 8 ? id.length : 8;
    return id.substring(0, end).toUpperCase();
  }

  Widget _buildReceiptHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            size: 48,
            color: Colors.white,
          ),
          SizedBox(height: 16),
          Text(
            'Order Receipt',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Receipt #${_shortId(order.id)}',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Ordered on ${_formatDate(order.orderDate)}',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItems() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Items',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        ...order.items.map((item) => _buildOrderItem(item)).toList(),
      ],
    );
  }

  Widget _buildOrderItem(order_model.OrderItem item) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
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
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  'Quantity: ${item.quantity}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Price: ₹${item.price.toStringAsFixed(2)} each',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item.total.toStringAsFixed(2)}',
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
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildSummaryRow('Subtotal', '₹${order.subtotal.toStringAsFixed(2)}'),
          if (order.discountAmount != null && order.discountAmount! > 0)
            _buildSummaryRow(
              'Discount (${order.couponCode ?? 'Coupon'})',
              '-₹${order.discountAmount!.toStringAsFixed(2)}',
              isDiscount: true,
            ),
          _buildSummaryRow(
              'Delivery Charge', '₹${order.deliveryCharge.toStringAsFixed(2)}'),
          _buildSummaryRow('Tax (5%)', '₹${order.tax.toStringAsFixed(2)}'),
          Divider(height: 24),
          _buildSummaryRow(
            'Total Amount',
            '₹${order.total.toStringAsFixed(2)}',
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value,
      {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green[600] : null,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isDiscount
                  ? Colors.green[600]
                  : isTotal
                      ? Colors.green[700]
                      : Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Delivery Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.blue[700], size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                order.deliveryAddress,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.schedule, color: Colors.blue[700], size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Delivery Time',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                '${_formatDate(order.deliveryDate)} • ${order.deliveryTimeSlot}',
                style: TextStyle(fontSize: 14),
              ),
              if (order.deliveredDate != null) ...[
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.check_circle,
                        color: Colors.green[700], size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Delivered on',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  _formatDate(order.deliveredDate!),
                  style: TextStyle(fontSize: 14),
                ),
              ],
              if (order.deliveryPersonName != null) ...[
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.person, color: Colors.blue[700], size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Delivered by',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[700],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  order.deliveryPersonName!,
                  style: TextStyle(fontSize: 14),
                ),
                if (order.deliveryPersonPhone != null)
                  Text(
                    order.deliveryPersonPhone!,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.payment, color: Colors.green[700], size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Payment Method',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                order.paymentMethod,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.credit_card, color: Colors.green[700], size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Payment Status',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  order.paymentStatusText,
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _shareReceipt(context),
            icon: Icon(Icons.share),
            label: Text('Share Receipt'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.green),
              foregroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _downloadReceipt(context),
            icon: Icon(Icons.download),
            label: Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _shareReceipt(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt sharing feature coming soon!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _downloadReceipt(BuildContext context) {
    // Copy receipt details to clipboard
    final receiptText = _generateReceiptText();
    Clipboard.setData(ClipboardData(text: receiptText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Receipt details copied to clipboard!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _generateReceiptText() {
    final buffer = StringBuffer();
    buffer.writeln('BIGBASKET - ORDER RECEIPT');
    buffer.writeln('========================');
    buffer.writeln('Receipt #${_shortId(order.id)}');
    buffer.writeln('Order Date: ${_formatDate(order.orderDate)}');
    buffer.writeln('');
    buffer.writeln('ITEMS:');
    for (final item in order.items) {
      buffer.writeln('• ${item.productName}');
      buffer.writeln(
          '  Qty: ${item.quantity} × ₹${item.price.toStringAsFixed(2)} = ₹${item.total.toStringAsFixed(2)}');
    }
    buffer.writeln('');
    buffer.writeln('ORDER SUMMARY:');
    buffer.writeln('Subtotal: ₹${order.subtotal.toStringAsFixed(2)}');
    if (order.discountAmount != null && order.discountAmount! > 0) {
      buffer.writeln('Discount: -₹${order.discountAmount!.toStringAsFixed(2)}');
    }
    buffer.writeln(
        'Delivery Charge: ₹${order.deliveryCharge.toStringAsFixed(2)}');
    buffer.writeln('Tax: ₹${order.tax.toStringAsFixed(2)}');
    buffer.writeln('TOTAL: ₹${order.total.toStringAsFixed(2)}');
    buffer.writeln('');
    buffer.writeln('DELIVERY ADDRESS:');
    buffer.writeln(order.deliveryAddress);
    buffer.writeln(
        'Delivery Time: ${_formatDate(order.deliveryDate)} • ${order.deliveryTimeSlot}');
    if (order.deliveredDate != null) {
      buffer.writeln('Delivered on: ${_formatDate(order.deliveredDate!)}');
    }
    buffer.writeln('');
    buffer.writeln('PAYMENT:');
    buffer.writeln('Method: ${order.paymentMethod}');
    buffer.writeln('Status: ${order.paymentStatusText}');
    buffer.writeln('');
    buffer.writeln('Thank you for shopping with BigBasket!');

    return buffer.toString();
  }
}
