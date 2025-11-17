import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/admin_service.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // Pre-fill admin credentials
    _emailController.text = AdminService.adminEmail;
    _passwordController.text = AdminService.adminPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo/Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Admin Login',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Access Admin Panel',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 40),
                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter password';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 30),
                  // Login Button
                  Consumer<AdminService>(
                    builder: (context, adminService, child) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: adminService.isLoading
                              ? null
                              : () => _handleLogin(adminService),
                          child: adminService.isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  'Login',
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
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  // Back to User Login
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Text('Back to User Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin(AdminService adminService) async {
    if (_formKey.currentState!.validate()) {
      try {
        await adminService.loginAsAdmin(
          _emailController.text.trim(),
          _passwordController.text,
        );
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/admin-dashboard');
        }
      } catch (e) {
        if (mounted) {
          String errorMessage = 'Login failed';
          final errorStr = e.toString();
          
          if (errorStr.contains('permission-denied') || errorStr.contains('Missing or insufficient permissions')) {
            errorMessage = 'Firestore permissions not configured. Please set up security rules in Firebase Console.';
            
            // Show detailed instructions
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Firestore Rules Required'),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'To use the admin panel, you need to configure Firestore security rules:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      Text('1. Go to Firebase Console:'),
                      Text('   https://console.firebase.google.com/', 
                        style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                      SizedBox(height: 8),
                      Text('2. Select project: bigbasketclass'),
                      SizedBox(height: 8),
                      Text('3. Go to Firestore Database → Rules'),
                      SizedBox(height: 8),
                      Text('4. Replace rules with:'),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: SelectableText(
                          'rules_version = \'2\';\nservice cloud.firestore {\n  match /databases/{database}/documents {\n    match /{document=**} {\n      allow read, write: if request.auth != null;\n    }\n  }\n}',
                          style: TextStyle(fontSize: 10, fontFamily: 'monospace'),
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('5. Click "Publish"'),
                      SizedBox(height: 16),
                      Text(
                        'Note: This is a temporary rule for development. Use stricter rules for production.',
                        style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: Colors.orange[700]),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          } else if (errorStr.contains('user-not-found')) {
            errorMessage = 'Admin account not found. Creating account...';
            try {
              await adminService.initializeAdminAccount();
              await Future.delayed(Duration(seconds: 1));
              await adminService.loginAsAdmin(
                _emailController.text.trim(),
                _passwordController.text,
              );
              if (mounted) {
                Navigator.pushReplacementNamed(context, '/admin-dashboard');
                return;
              }
            } catch (retryError) {
              errorMessage = 'Failed to create admin account: $retryError';
            }
          } else {
            errorMessage = errorStr.replaceAll('Exception: ', '');
          }
          
          if (!errorStr.contains('permission-denied')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(errorMessage),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

