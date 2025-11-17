import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/cart_service.dart';
import '../../services/user_service.dart';
import '../../services/order_service.dart';
import '../../models/user.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  Address? _selectedAddress;
  String _selectedPaymentMethod = 'cod';
  String _selectedDeliveryTime = '10:00 AM - 12:00 PM';
  DateTime _selectedDeliveryDate = DateTime.now().add(Duration(days: 1));

  final List<String> _deliveryTimeSlots = [
    '10:00 AM - 12:00 PM',
    '12:00 PM - 2:00 PM',
    '2:00 PM - 4:00 PM',
    '4:00 PM - 6:00 PM',
    '6:00 PM - 8:00 PM',
  ];

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'cod', 'name': 'Cash on Delivery', 'icon': Icons.money},
    {'id': 'upi', 'name': 'UPI', 'icon': Icons.phone_android},
    {'id': 'card', 'name': 'Credit/Debit Card', 'icon': Icons.credit_card},
    {'id': 'netbanking', 'name': 'Net Banking', 'icon': Icons.account_balance},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<UserService, CartService>(
        builder: (context, userService, cartService, child) {
          if (userService.isLoading || cartService.items.isEmpty) {
            return Center(child: CircularProgressIndicator());
          }

          final user = userService.currentUser;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Please login to checkout',
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

          return Stepper(
            currentStep: _currentStep,
            onStepContinue: () {
              if (_currentStep < 3) {
                setState(() {
                  _currentStep++;
                });
              } else {
                _placeOrder(context, cartService, userService);
              }
            },
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              }
            },
            controlsBuilder: (context, details) {
              return Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: details.onStepCancel,
                          child: Text('Back'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.green),
                            foregroundColor: Colors.green,
                          ),
                        ),
                      ),
                    if (_currentStep > 0) SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: Text(
                            _currentStep == 3 ? 'Place Order' : 'Continue'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                title: Text('Delivery Address'),
                subtitle: Text('Select delivery address'),
                content: _buildAddressSelection(user),
                isActive: _currentStep >= 0,
                state:
                    _currentStep > 0 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Delivery Time'),
                subtitle: Text('Choose delivery date & time'),
                content: _buildDeliveryTimeSelection(),
                isActive: _currentStep >= 1,
                state:
                    _currentStep > 1 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Payment Method'),
                subtitle: Text('Select payment option'),
                content: _buildPaymentMethodSelection(),
                isActive: _currentStep >= 2,
                state:
                    _currentStep > 2 ? StepState.complete : StepState.indexed,
              ),
              Step(
                title: Text('Order Summary'),
                subtitle: Text('Review your order'),
                content: _buildOrderSummary(cartService),
                isActive: _currentStep >= 3,
                state: StepState.indexed,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAddressSelection(User user) {
    if (user.addresses.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.location_off, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No addresses found',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Text(
              'Please add an address to continue',
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/addresses'),
              child: Text('Add Address'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: user.addresses.map((address) {
        return RadioListTile<Address>(
          title: Text(
            address.name,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(address.phone),
              Text(address.fullAddress),
              if (address.landmark != null && address.landmark!.isNotEmpty)
                Text('Landmark: ${address.landmark}'),
              if (address.isDefault)
                Container(
                  margin: EdgeInsets.only(top: 4),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'DEFAULT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          value: address,
          groupValue: _selectedAddress,
          onChanged: (Address? value) {
            setState(() {
              _selectedAddress = value;
            });
          },
          secondary: Icon(
            address.addressType == 'home' ? Icons.home : Icons.business,
            color: Colors.green,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDeliveryTimeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Delivery Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 7,
            itemBuilder: (context, index) {
              final date = DateTime.now().add(Duration(days: index + 1));
              final isSelected = date.day == _selectedDeliveryDate.day;
              final isToday = index == 0;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDeliveryDate = date;
                  });
                },
                child: Container(
                  width: 80,
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.green : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date.day.toString(),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : Colors.grey[800],
                        ),
                      ),
                      Text(
                        _getDayName(date.weekday),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                      if (isToday)
                        Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white70 : Colors.green,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 24),
        Text(
          'Select Delivery Time',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _deliveryTimeSlots.map((timeSlot) {
            final isSelected = timeSlot == _selectedDeliveryTime;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedDeliveryTime = timeSlot;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.green : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  timeSlot,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[800],
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelection() {
    return Column(
      children: _paymentMethods.map((method) {
        final isSelected = method['id'] == _selectedPaymentMethod;
        return RadioListTile<String>(
          title: Row(
            children: [
              Icon(
                method['icon'] as IconData,
                color: isSelected ? Colors.green : Colors.grey[600],
              ),
              SizedBox(width: 12),
              Text(
                method['name'] as String,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
          value: method['id'] as String,
          groupValue: _selectedPaymentMethod,
          onChanged: (String? value) {
            setState(() {
              _selectedPaymentMethod = value!;
            });
          },
          activeColor: Colors.green,
        );
      }).toList(),
    );
  }

  Widget _buildOrderSummary(CartService cartService) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Order Summary
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
                SizedBox(height: 16),
                ...cartService.items.values.map((item) => Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: NetworkImage(item.product.imageUrl),
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
                                  item.product.name,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Qty: ${item.quantity}',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₹${(item.product.price * item.quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    )),
                Divider(height: 24),
                _buildSummaryRow(
                    'Subtotal', '₹${cartService.subtotal.toStringAsFixed(2)}'),
                _buildSummaryRow(
                    'Delivery Charge',
                    cartService.deliveryCharge > 0
                        ? '₹${cartService.deliveryCharge.toStringAsFixed(2)}'
                        : 'FREE'),
                _buildSummaryRow(
                    'Tax (5%)', '₹${cartService.tax.toStringAsFixed(2)}'),
                Divider(height: 16),
                _buildSummaryRow(
                  'Total Amount',
                  '₹${cartService.totalAmount.toStringAsFixed(2)}',
                  isTotal: true,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // Delivery Details
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 16),
                if (_selectedAddress != null) ...[
                  _buildDetailRow('Address', _selectedAddress!.fullAddress),
                  _buildDetailRow('Contact', _selectedAddress!.phone),
                  _buildDetailRow('Date', _formatDate(_selectedDeliveryDate)),
                  _buildDetailRow('Time', _selectedDeliveryTime),
                ],
              ],
            ),
          ),
        ),
        SizedBox(height: 16),

        // Payment Details
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment Details',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 16),
                _buildDetailRow(
                    'Method', _getPaymentMethodName(_selectedPaymentMethod)),
                if (_selectedPaymentMethod == 'cod')
                  Container(
                    margin: EdgeInsets.only(top: 8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.orange.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Pay ₹${cartService.totalAmount.toStringAsFixed(2)} when your order is delivered',
                            style: TextStyle(
                              color: Colors.orange.shade800,
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
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              color: isTotal ? Colors.green[700] : Colors.grey[800],
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return '';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getPaymentMethodName(String methodId) {
    switch (methodId) {
      case 'cod':
        return 'Cash on Delivery';
      case 'upi':
        return 'UPI';
      case 'card':
        return 'Credit/Debit Card';
      case 'netbanking':
        return 'Net Banking';
      default:
        return 'Unknown';
    }
  }

  void _placeOrder(
      BuildContext context, CartService cartService, UserService userService) {
    if (_selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a delivery address')),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(color: Colors.green),
            SizedBox(width: 16),
            Text('Placing your order...'),
          ],
        ),
      ),
    );

    // Simulate order placement
    Future.delayed(Duration(seconds: 2), () async {
      Navigator.pop(context); // Close loading dialog

      // Create order
      final orderService = context.read<OrderService>();

      try {
        await orderService.createOrder(
          cartService: cartService,
          deliveryAddress: _selectedAddress!.fullAddress,
          deliveryDate: _selectedDeliveryDate,
          deliveryTimeSlot: _selectedDeliveryTime,
          paymentMethod: _getPaymentMethodName(_selectedPaymentMethod),
        );

        // Clear cart
        cartService.clear();

        // Show success dialog
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 24),
                  SizedBox(width: 8),
                  Text('Order Placed!'),
                ],
              ),
              content: Text(
                  'Your order has been placed successfully. You will receive a confirmation email shortly.'),
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
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to place order: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    });
  }
}
