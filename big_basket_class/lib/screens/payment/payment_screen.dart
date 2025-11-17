import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentScreen extends StatefulWidget {
  final double amount;
  final String orderId;

  const PaymentScreen({
    Key? key,
    required this.amount,
    required this.orderId,
  }) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String _selectedPaymentMethod = 'cod';
  final _upiController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _isProcessing = false;

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'cod',
      'name': 'Cash on Delivery',
      'description': 'Pay when your order is delivered',
      'icon': Icons.money,
      'color': Colors.orange,
    },
    {
      'id': 'upi',
      'name': 'UPI',
      'description': 'Pay using UPI ID or QR code',
      'icon': Icons.phone_android,
      'color': Colors.purple,
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'description': 'Pay using your card',
      'icon': Icons.credit_card,
      'color': Colors.blue,
    },
    {
      'id': 'netbanking',
      'name': 'Net Banking',
      'description': 'Pay using your bank account',
      'icon': Icons.account_balance,
      'color': Colors.green,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Summary Card
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order ID:',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          widget.orderId,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Amount to Pay:',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        Text(
                          '₹${widget.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),

            // Payment Methods
            Text(
              'Select Payment Method',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),

            ..._paymentMethods.map((method) => _buildPaymentMethodCard(method)),

            SizedBox(height: 24),

            // Payment Form
            if (_selectedPaymentMethod == 'upi') _buildUPIForm(),
            if (_selectedPaymentMethod == 'card') _buildCardForm(),

            SizedBox(height: 32),

            // Pay Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                child: _isProcessing
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Processing...'),
                        ],
                      )
                    : Text(
                        'Pay ₹${widget.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            // Security Notice
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.security, color: Colors.blue, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Your payment information is secure and encrypted. We never store your card details.',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['id'];
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? method['color'] : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: RadioListTile<String>(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: method['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                method['icon'],
                color: method['color'],
                size: 24,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    method['description'],
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
        value: method['id'],
        groupValue: _selectedPaymentMethod,
        onChanged: (String? value) {
          setState(() {
            _selectedPaymentMethod = value!;
          });
        },
        activeColor: method['color'],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildUPIForm() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'UPI Payment',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _upiController,
              decoration: InputDecoration(
                labelText: 'UPI ID',
                hintText: 'example@upi',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone_android),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter UPI ID';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid UPI ID';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.qr_code, color: Colors.grey[600], size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scan QR Code',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          'Use any UPI app to scan and pay',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement QR code generation
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('QR Code generation coming soon!')),
                      );
                    },
                    child: Text('Generate QR'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Card Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _cardNumberController,
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.credit_card),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
                CardNumberFormatter(),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card number';
                }
                if (value.replaceAll(' ', '').length != 16) {
                  return 'Please enter a valid 16-digit card number';
                }
                return null;
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _cardNameController,
                    decoration: InputDecoration(
                      labelText: 'Cardholder Name',
                      hintText: 'John Doe',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter cardholder name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                      ExpiryDateFormatter(),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter expiry date';
                      }
                      if (value.length != 5) {
                        return 'Please enter valid expiry date';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.security),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter CVV';
                      }
                      if (value.length != 3) {
                        return 'Please enter valid CVV';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _processPayment() {
    if (_selectedPaymentMethod == 'cod') {
      _handleCODPayment();
    } else if (_selectedPaymentMethod == 'upi') {
      _handleUPIPayment();
    } else if (_selectedPaymentMethod == 'card') {
      _handleCardPayment();
    } else {
      _handleNetBankingPayment();
    }
  }

  void _handleCODPayment() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate processing
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });

      _showPaymentSuccessDialog('Cash on Delivery');
    });
  }

  void _handleUPIPayment() {
    if (_upiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter UPI ID')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate UPI payment processing
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isProcessing = false;
      });

      _showPaymentSuccessDialog('UPI');
    });
  }

  void _handleCardPayment() {
    if (_cardNumberController.text.isEmpty ||
        _cardNameController.text.isEmpty ||
        _expiryController.text.isEmpty ||
        _cvvController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all card details')),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate card payment processing
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        _isProcessing = false;
      });

      _showPaymentSuccessDialog('Card');
    });
  }

  void _handleNetBankingPayment() {
    setState(() {
      _isProcessing = true;
    });

    // Simulate net banking processing
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isProcessing = false;
      });

      _showPaymentSuccessDialog('Net Banking');
    });
  }

  void _showPaymentSuccessDialog(String paymentMethod) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 8),
            Text('Payment Successful!'),
          ],
        ),
        content: Text(
          'Your payment of ₹${widget.amount.toStringAsFixed(2)} has been processed successfully using $paymentMethod.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', (route) => false);
            },
            child: Text('Continue Shopping'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _upiController.dispose();
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}

// Custom formatters
class CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text.replaceAll(' ', '');
    final formatted = text
        .replaceAllMapped(
          RegExp(r'.{4}'),
          (match) => '${match.group(0)} ',
        )
        .trim();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final text = newValue.text;
    if (text.length == 2 && !text.contains('/')) {
      return TextEditingValue(
        text: '$text/',
        selection: TextSelection.collapsed(offset: 3),
      );
    }

    return newValue;
  }
}
