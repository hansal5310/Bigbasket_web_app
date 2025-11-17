import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

class UserService extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;

  // Mock user data for development
  User get mockUser => User(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        phone: '+91 98765 43210',
        profilePicture:
            'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
        addresses: [
          Address(
            id: '1',
            name: 'John Doe',
            phone: '+91 98765 43210',
            addressLine1: '123 Main Street',
            addressLine2: 'Apartment 4B',
            city: 'Mumbai',
            state: 'Maharashtra',
            pincode: '400001',
            landmark: 'Near Central Park',
            isDefault: true,
            addressType: 'home',
          ),
          Address(
            id: '2',
            name: 'John Doe',
            phone: '+91 98765 43210',
            addressLine1: '456 Business Park',
            addressLine2: 'Floor 8, Suite 12',
            city: 'Mumbai',
            state: 'Maharashtra',
            pincode: '400002',
            landmark: 'Opposite Metro Station',
            isDefault: false,
            addressType: 'office',
          ),
        ],
        defaultAddressId: '1',
        createdAt: DateTime.now().subtract(Duration(days: 365)),
        updatedAt: DateTime.now(),
      );

  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  UserService() {
    _bindAuthState();
  }

  void _bindAuthState() {
    _auth.authStateChanges().listen((fb.User? firebaseUser) async {
      if (firebaseUser == null) {
        _currentUser = null;
        notifyListeners();
      } else {
        await _loadUserProfile(firebaseUser.uid, firebaseUser.email);
      }
    });
  }

  Future<void> _loadUserProfile(String uid, String? email) async {
    _isLoading = true;
    notifyListeners();
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!..['id'] = uid;
        _currentUser = User.fromJson(data);
      } else {
        // Initialize minimal profile if not present
        final now = FieldValue.serverTimestamp();
        await _db.collection('users').doc(uid).set({
          'id': uid,
          'name': '',
          'email': email ?? '',
          'phone': '',
          'addresses': [],
          'defaultAddressId': null,
          'createdAt': now,
          'updatedAt': now,
        }, SetOptions(merge: true));
        _currentUser = User(
          id: uid,
          name: '',
          email: email ?? '',
          phone: '',
          profilePicture: null,
          addresses: const [],
          defaultAddressId: null,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
      }
    } catch (e) {
      // Fallback to minimal in-memory user so UI can render without blocking
      _currentUser = User(
        id: uid,
        name: '',
        email: email ?? '',
        phone: '',
        profilePicture: null,
        addresses: const [],
        defaultAddressId: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signup(
      String name, String email, String phone, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = cred.user!.uid;
      await _db.collection('users').doc(uid).set({
        'id': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'profilePicture': null,
        'addresses': [],
        'defaultAddressId': null,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await _loadUserProfile(uid, email);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _auth.signOut();
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? profilePicture,
  }) async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();
      final uid = _currentUser!.id;
      await _db.collection('users').doc(uid).set({
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (profilePicture != null) 'profilePicture': profilePicture,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      await _loadUserProfile(uid, email ?? _currentUser!.email);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to update profile: $e');
    }
  }

  Future<void> addAddress(Address address) async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 500));

      final updatedAddresses = List<Address>.from(_currentUser!.addresses);
      updatedAddresses.add(address);

      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profilePicture: _currentUser!.profilePicture,
        addresses: updatedAddresses,
        defaultAddressId: _currentUser!.defaultAddressId,
        createdAt: _currentUser!.createdAt,
        updatedAt: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to add address: $e');
    }
  }

  Future<void> updateAddress(Address address) async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 500));

      final updatedAddresses = _currentUser!.addresses.map((addr) {
        return addr.id == address.id ? address : addr;
      }).toList();

      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profilePicture: _currentUser!.profilePicture,
        addresses: updatedAddresses,
        defaultAddressId: _currentUser!.defaultAddressId,
        createdAt: _currentUser!.createdAt,
        updatedAt: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to update address: $e');
    }
  }

  Future<void> deleteAddress(String addressId) async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 500));

      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profilePicture: _currentUser!.profilePicture,
        addresses: _currentUser!.addresses
            .where((addr) => addr.id != addressId)
            .toList(),
        defaultAddressId: _currentUser!.defaultAddressId,
        createdAt: _currentUser!.createdAt,
        updatedAt: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to delete address: $e');
    }
  }

  Future<void> setDefaultAddress(String addressId) async {
    if (_currentUser == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Simulate network delay
      await Future.delayed(Duration(milliseconds: 500));

      final updatedAddresses = _currentUser!.addresses.map((addr) {
        return Address(
          id: addr.id,
          name: addr.name,
          phone: addr.phone,
          addressLine1: addr.addressLine1,
          addressLine2: addr.addressLine2,
          city: addr.city,
          state: addr.state,
          pincode: addr.pincode,
          landmark: addr.landmark,
          isDefault: addr.id == addressId,
          addressType: addr.addressType,
        );
      }).toList();

      _currentUser = User(
        id: _currentUser!.id,
        name: _currentUser!.name,
        email: _currentUser!.email,
        phone: _currentUser!.phone,
        profilePicture: _currentUser!.profilePicture,
        addresses: updatedAddresses,
        defaultAddressId: addressId,
        createdAt: _currentUser!.createdAt,
        updatedAt: DateTime.now(),
      );

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to set default address: $e');
    }
  }
}
