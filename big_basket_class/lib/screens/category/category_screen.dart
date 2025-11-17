import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool _isGridView = true;
  final List<Map<String, dynamic>> _categories = [
    {'name': 'Fruits & Vegetables', 'icon': Icons.local_florist, 'color': Colors.green},
    {'name': 'Dairy & Eggs', 'icon': Icons.egg, 'color': Colors.blue},
    {'name': 'Snacks', 'icon': Icons.fastfood, 'color': Colors.orange},
    {'name': 'Beverages', 'icon': Icons.local_drink, 'color': Colors.purple},
    {'name': 'Bakery', 'icon': Icons.cake, 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Categories'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.list : Icons.grid_view),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Hierarchy Navigation
          Container(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                _buildBreadcrumb('Home', false),
                _buildBreadcrumb('Categories', true),
              ],
            ),
          ),

          // Filters and Sort Options
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _showFilterDialog,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.filter_list, color: Colors.grey.shade600, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _showSortDialog,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.sort, color: Colors.grey.shade600, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Sort',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Category List/Grid
          Expanded(
            child: _isGridView
                ? GridView.builder(
              padding: EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryCard(_categories[index]);
              },
            )
                : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return _buildCategoryListTile(_categories[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(String title, bool isActive) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Text(
        title + (isActive ? '' : ' >'),
        style: TextStyle(
          fontSize: 14,
          fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          color: isActive ? Colors.green : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/product-list', arguments: category['name']);
      },
      child: Container(
        decoration: BoxDecoration(
          color: category['color'].withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'],
              size: 50,
              color: category['color'],
            ),
            SizedBox(height: 8),
            Text(
              category['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryListTile(Map<String, dynamic> category) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/product-list', arguments: category['name']);
      },
      leading: Icon(
        category['icon'],
        color: category['color'],
        size: 30,
      ),
      title: Text(
        category['name'],
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey.shade600, size: 16),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Vegetarian Only'),
                trailing: Checkbox(value: false, onChanged: (value) {}),
              ),
              ListTile(
                title: Text('Organic Only'),
                trailing: Checkbox(value: false, onChanged: (value) {}),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text('Apply Filters', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Sort By',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(height: 16),
              ListTile(
                title: Text('Name (A-Z)'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: Text('Name (Z-A)'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                title: Text('Popularity'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }
}