import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEditProductScreen extends StatefulWidget {
  final Map<String, dynamic>? productData;

  const AddEditProductScreen({this.productData});

  @override
  _AddEditProductScreenState createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _isLoading = false;

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _originalPriceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _subcategoryController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();

  bool _isAvailable = true;
  bool _isOrganic = false;
  bool _isDiscounted = false;

  @override
  void initState() {
    super.initState();
    if (widget.productData != null) {
      _nameController.text = widget.productData!['name'] ?? '';
      _descriptionController.text = widget.productData!['description'] ?? '';
      _priceController.text = (widget.productData!['price'] ?? 0).toString();
      _originalPriceController.text =
          (widget.productData!['originalPrice'] ?? 0).toString();
      _imageUrlController.text = widget.productData!['imageUrl'] ?? '';
      _categoryController.text = widget.productData!['category'] ?? '';
      _subcategoryController.text = widget.productData!['subcategory'] ?? '';
      _brandController.text = widget.productData!['brand'] ?? '';
      _weightController.text = widget.productData!['weight'] ?? '';
      _stockController.text =
          (widget.productData!['stockQuantity'] ?? 0).toString();
      _ratingController.text = (widget.productData!['rating'] ?? 0).toString();
      _isAvailable = widget.productData!['isAvailable'] ?? true;
      _isOrganic = widget.productData!['isOrganic'] ?? false;
      _isDiscounted = widget.productData!['isDiscounted'] ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productData == null
            ? 'Add Product'
            : 'Edit Product'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nameController,
                label: 'Product Name',
                icon: Icons.shopping_bag,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: 'Description',
                icon: Icons.description,
                maxLines: 3,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _priceController,
                      label: 'Price (₹)',
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _originalPriceController,
                      label: 'Original Price (₹)',
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              _buildTextField(
                controller: _imageUrlController,
                label: 'Image URL',
                icon: Icons.image,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _categoryController,
                      label: 'Category',
                      icon: Icons.category,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _subcategoryController,
                      label: 'Subcategory',
                      icon: Icons.label,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _brandController,
                      label: 'Brand',
                      icon: Icons.business,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _weightController,
                      label: 'Weight/Unit',
                      icon: Icons.scale,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      controller: _stockController,
                      label: 'Stock Quantity',
                      icon: Icons.inventory,
                      keyboardType: TextInputType.number,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      controller: _ratingController,
                      label: 'Rating',
                      icon: Icons.star,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Toggle Switches
              SwitchListTile(
                title: Text('Available'),
                value: _isAvailable,
                onChanged: (v) => setState(() => _isAvailable = v),
                secondary: Icon(Icons.check_circle),
              ),
              SwitchListTile(
                title: Text('Organic'),
                value: _isOrganic,
                onChanged: (v) => setState(() => _isOrganic = v),
                secondary: Icon(Icons.eco),
              ),
              SwitchListTile(
                title: Text('Discounted'),
                value: _isDiscounted,
                onChanged: (v) => setState(() => _isDiscounted = v),
                secondary: Icon(Icons.local_offer),
              ),
              SizedBox(height: 30),
              // Save Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveProduct,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.productData == null
                              ? 'Add Product'
                              : 'Update Product',
                          style: TextStyle(fontSize: 18),
                        ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final productData = {
          'name': _nameController.text.trim(),
          'description': _descriptionController.text.trim(),
          'price': double.parse(_priceController.text),
          'originalPrice': _originalPriceController.text.isNotEmpty
              ? double.parse(_originalPriceController.text)
              : double.parse(_priceController.text),
          'imageUrl': _imageUrlController.text.trim(),
          'category': _categoryController.text.trim(),
          'subcategory': _subcategoryController.text.trim(),
          'brand': _brandController.text.trim(),
          'weight': _weightController.text.trim(),
          'stockQuantity': int.parse(_stockController.text),
          'rating': _ratingController.text.isNotEmpty
              ? double.parse(_ratingController.text)
              : 0.0,
          'isAvailable': _isAvailable,
          'isOrganic': _isOrganic,
          'isDiscounted': _isDiscounted,
          'reviewCount': widget.productData?['reviewCount'] ?? 0,
          'updatedAt': FieldValue.serverTimestamp(),
        };

        if (widget.productData == null) {
          productData['createdAt'] = FieldValue.serverTimestamp();
          await _db.collection('products').add(productData);
        } else {
          await _db
              .collection('products')
              .doc(widget.productData!['id'])
              .update(productData);
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.productData == null
                  ? 'Product added successfully'
                  : 'Product updated successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _originalPriceController.dispose();
    _imageUrlController.dispose();
    _categoryController.dispose();
    _subcategoryController.dispose();
    _brandController.dispose();
    _weightController.dispose();
    _stockController.dispose();
    _ratingController.dispose();
    super.dispose();
  }
}

