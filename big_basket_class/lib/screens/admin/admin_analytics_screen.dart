import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAnalyticsScreen extends StatelessWidget {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db.collection('orders').snapshots(),
        builder: (context, ordersSnapshot) {
          return StreamBuilder<QuerySnapshot>(
            stream: _db.collection('products').snapshots(),
            builder: (context, productsSnapshot) {
              // Calculate totals
              int totalOrders =
                  ordersSnapshot.hasData ? ordersSnapshot.data!.docs.length : 0;
              int totalProducts = productsSnapshot.hasData
                  ? productsSnapshot.data!.docs.length
                  : 0;

              double totalSales = 0.0;
              if (ordersSnapshot.hasData) {
                for (var doc in ordersSnapshot.data!.docs) {
                  final data = doc.data() as Map<String, dynamic>;
                  final total = (data['total'] as num?)?.toDouble() ?? 0.0;
                  totalSales += total;
                }
              }

              return SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store Analytics',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Real-time store statistics',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Total Sales Card
                    _buildStatCard(
                      context,
                      'Total Sales',
                      '₹${totalSales.toStringAsFixed(2)}',
                      Icons.attach_money,
                      Colors.green,
                      'Total revenue from all orders',
                    ),

                    SizedBox(height: 16),

                    // Total Products Card
                    _buildStatCard(
                      context,
                      'Total Products',
                      totalProducts.toString(),
                      Icons.inventory_2,
                      Colors.blue,
                      'Products in your store',
                    ),

                    SizedBox(height: 16),

                    // Total Orders Card
                    _buildStatCard(
                      context,
                      'Total Orders',
                      totalOrders.toString(),
                      Icons.shopping_bag,
                      Colors.orange,
                      'All customer orders',
                    ),

                    SizedBox(height: 24),

                    // Additional Stats
                    if (ordersSnapshot.connectionState ==
                            ConnectionState.waiting ||
                        productsSnapshot.connectionState ==
                            ConnectionState.waiting)
                      Center(child: CircularProgressIndicator())
                    else if (ordersSnapshot.hasError ||
                        productsSnapshot.hasError)
                      Center(
                        child: Text(
                          'Error loading analytics',
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    else
                      _buildAdditionalStats(
                        context,
                        totalOrders,
                        totalProducts,
                        totalSales,
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

  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withOpacity(0.1),
              color.withOpacity(0.05),
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
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

  Widget _buildAdditionalStats(
    BuildContext context,
    int totalOrders,
    int totalProducts,
    double totalSales,
  ) {
    double avgOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Statistics',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatRow('Average Order Value',
                    '₹${avgOrderValue.toStringAsFixed(2)}'),
                Divider(),
                _buildStatRow(
                    'Products per Order',
                    totalOrders > 0
                        ? (totalProducts / totalOrders).toStringAsFixed(1)
                        : '0'),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
