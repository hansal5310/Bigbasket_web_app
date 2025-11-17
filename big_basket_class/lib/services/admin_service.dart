import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService extends ChangeNotifier {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  bool _isAdmin = false;
  bool _isLoading = false;

  bool get isAdmin => _isAdmin;
  bool get isLoading => _isLoading;

  // Admin email
  static const String adminEmail = 'Admin@gmail.com';
  static const String adminPassword = 'Admin@123';

  AdminService() {
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _verifyAdmin(user.email ?? '');
    }
  }

  Future<bool> _verifyAdmin(String email) async {
    try {
      final adminDoc = await _db.collection('admins').doc(email).get();
      _isAdmin = adminDoc.exists && (adminDoc.data()?['isAdmin'] == true);
      notifyListeners();
      return _isAdmin;
    } catch (e) {
      _isAdmin = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> loginAsAdmin(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      // First try to login
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      
      // Wait a moment for auth to settle
      await Future.delayed(Duration(milliseconds: 500));
      
      // Verify admin status
      final isAdmin = await _verifyAdmin(email.trim());
      
      if (!isAdmin) {
        // If not admin in Firestore, create the admin document
        await _db.collection('admins').doc(email.trim()).set({
          'email': email.trim(),
          'isAdmin': true,
          'createdAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
        
        // Verify again
        final verified = await _verifyAdmin(email.trim());
        if (!verified) {
          await _auth.signOut();
          _isAdmin = false;
          throw Exception('Failed to set admin privileges');
        }
      }
      
      _isAdmin = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } on fb.FirebaseAuthException catch (e) {
      _isLoading = false;
      _isAdmin = false;
      notifyListeners();
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'Admin account not found. Please ensure admin account is initialized.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address';
      } else {
        message = 'Login failed: ${e.message}';
      }
      throw Exception(message);
    } catch (e) {
      _isLoading = false;
      _isAdmin = false;
      notifyListeners();
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> initializeAdminAccount() async {
    try {
      // Sign out any existing user first
      if (_auth.currentUser != null && _auth.currentUser!.email != adminEmail) {
        await _auth.signOut();
      }
      
      // Check if admin already exists
      try {
        await _auth.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        // Admin exists, just update Firestore
        try {
          await _db.collection('admins').doc(adminEmail).set({
            'email': adminEmail,
            'isAdmin': true,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
          
          // Also update user document
          final user = _auth.currentUser;
          if (user != null) {
            await _db.collection('users').doc(user.uid).set({
              'id': user.uid,
              'name': 'Admin',
              'email': adminEmail,
              'phone': '',
              'isAdmin': true,
              'createdAt': FieldValue.serverTimestamp(),
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));
          }
          print('Admin account verified and updated');
        } catch (firestoreError) {
          // Firestore permission error - log but don't fail
          print('Firestore permission error (this is OK if rules are not set yet): $firestoreError');
        }
        
        await _auth.signOut();
      } on fb.FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          // Admin doesn't exist, create it
          try {
            final cred = await _auth.createUserWithEmailAndPassword(
              email: adminEmail,
              password: adminPassword,
            );
            try {
              await _db.collection('admins').doc(adminEmail).set({
                'email': adminEmail,
                'isAdmin': true,
                'createdAt': FieldValue.serverTimestamp(),
                'updatedAt': FieldValue.serverTimestamp(),
              });
              await _db.collection('users').doc(cred.user!.uid).set({
                'id': cred.user!.uid,
                'name': 'Admin',
                'email': adminEmail,
                'phone': '',
                'isAdmin': true,
                'createdAt': FieldValue.serverTimestamp(),
                'updatedAt': FieldValue.serverTimestamp(),
              });
              print('Admin account created successfully');
            } catch (firestoreError) {
              print('Firestore permission error (this is OK if rules are not set yet): $firestoreError');
            }
            await _auth.signOut();
          } catch (createError) {
            print('Error creating admin account: $createError');
          }
        } else {
          print('Error checking admin account: $e');
        }
      }
    } catch (e) {
      // Don't throw - just log the error so app can still start
      print('Error initializing admin (non-critical): $e');
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _isAdmin = false;
    notifyListeners();
  }

  void onAuthStateChanged() {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        _isAdmin = false;
      } else {
        _verifyAdmin(user.email ?? '');
      }
      notifyListeners();
    });
  }
}

