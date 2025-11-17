import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/user_service.dart';
import '../../models/user.dart';

class AddressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Addresses'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer<UserService>(
        builder: (context, userService, child) {
          if (userService.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          final user = userService.currentUser;
          if (user == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Please login to view addresses',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          if (user.addresses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No addresses found',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your first address to get started',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: user.addresses.length,
            itemBuilder: (context, index) {
              final address = user.addresses[index];
              return _buildAddressCard(context, address, userService);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditAddressDialog(context, null),
        backgroundColor: Colors.green,
        child: Icon(Icons.add_location_alt, color: Colors.white),
      ),
    );
  }

  Widget _buildAddressCard(
      BuildContext context, Address address, UserService userService) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: address.isDefault ? Colors.green : Colors.grey.shade300,
          width: address.isDefault ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  address.addressType == 'home' ? Icons.home : Icons.business,
                  color: Colors.green,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  address.addressType.toUpperCase(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                Spacer(),
                if (address.isDefault)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'DEFAULT',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              address.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 4),
            Text(
              address.phone,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              address.fullAddress,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
            if (address.landmark != null && address.landmark!.isNotEmpty) ...[
              SizedBox(height: 4),
              Text(
                'Landmark: ${address.landmark}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
            SizedBox(height: 16),
            Row(
              children: [
                if (!address.isDefault)
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          _setDefaultAddress(context, address.id, userService),
                      icon: Icon(Icons.star_outline, size: 16),
                      label: Text('Set Default'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                if (!address.isDefault) SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _showAddEditAddressDialog(context, address),
                    icon: Icon(Icons.edit, size: 16),
                    label: Text('Edit'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue,
                      side: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        _deleteAddress(context, address.id, userService),
                    icon: Icon(Icons.delete, size: 16),
                    label: Text('Delete'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _setDefaultAddress(
      BuildContext context, String addressId, UserService userService) {
    userService.setDefaultAddress(addressId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Default address updated successfully')),
    );
  }

  void _deleteAddress(
      BuildContext context, String addressId, UserService userService) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Address'),
        content: Text('Are you sure you want to delete this address?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              userService.deleteAddress(addressId);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Address deleted successfully')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddEditAddressDialog(BuildContext context, Address? address) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AddEditAddressBottomSheet(address: address),
    );
  }
}

class _AddEditAddressBottomSheet extends StatefulWidget {
  final Address? address;

  const _AddEditAddressBottomSheet({this.address});

  @override
  _AddEditAddressBottomSheetState createState() =>
      _AddEditAddressBottomSheetState();
}

class _AddEditAddressBottomSheetState
    extends State<_AddEditAddressBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _landmarkController = TextEditingController();
  String _selectedAddressType = 'home';
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    if (widget.address != null) {
      _nameController.text = widget.address!.name;
      _phoneController.text = widget.address!.phone;
      _addressLine1Controller.text = widget.address!.addressLine1;
      _addressLine2Controller.text = widget.address!.addressLine2;
      _cityController.text = widget.address!.city;
      _stateController.text = widget.address!.state;
      _pincodeController.text = widget.address!.pincode;
      _landmarkController.text = widget.address!.landmark ?? '';
      _selectedAddressType = widget.address!.addressType;
      _isDefault = widget.address!.isDefault;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Text(
                  widget.address == null ? 'Add New Address' : 'Edit Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressLine1Controller,
                      label: 'Address Line 1',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    _buildTextField(
                      controller: _addressLine2Controller,
                      label: 'Address Line 2 (Optional)',
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _cityController,
                            label: 'City',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter city';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _stateController,
                            label: 'State',
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter state';
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
                          child: _buildTextField(
                            controller: _pincodeController,
                            label: 'Pincode',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter pincode';
                              }
                              if (value.length != 6) {
                                return 'Pincode must be 6 digits';
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _landmarkController,
                            label: 'Landmark (Optional)',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _selectedAddressType,
                            decoration: InputDecoration(
                              labelText: 'Address Type',
                              border: OutlineInputBorder(),
                            ),
                            items: [
                              DropdownMenuItem(
                                  value: 'home', child: Text('Home')),
                              DropdownMenuItem(
                                  value: 'office', child: Text('Office')),
                              DropdownMenuItem(
                                  value: 'other', child: Text('Other')),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedAddressType = value!;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: CheckboxListTile(
                            title: Text('Set as Default'),
                            value: _isDefault,
                            onChanged: (value) {
                              setState(() {
                                _isDefault = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveAddress,
                        child: Text(
                          widget.address == null
                              ? 'Add Address'
                              : 'Update Address',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
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
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      validator: validator,
    );
  }

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
      final userService = context.read<UserService>();
      final address = Address(
        id: widget.address?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        phone: _phoneController.text,
        addressLine1: _addressLine1Controller.text,
        addressLine2: _addressLine2Controller.text,
        city: _cityController.text,
        state: _stateController.text,
        pincode: _pincodeController.text,
        landmark:
            _landmarkController.text.isEmpty ? null : _landmarkController.text,
        addressType: _selectedAddressType,
        isDefault: _isDefault,
      );

      if (widget.address == null) {
        userService.addAddress(address);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address added successfully')),
        );
      } else {
        userService.updateAddress(address);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Address updated successfully')),
        );
      }

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressLine1Controller.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }
}
