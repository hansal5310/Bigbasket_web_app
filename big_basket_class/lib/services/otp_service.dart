import 'package:flutter/foundation.dart';

class OTPService extends ChangeNotifier {
  bool _isLoading = false;
  bool _isOTPSent = false;
  String? _phoneNumber;
  String? _verificationId;

  bool get isLoading => _isLoading;
  bool get isOTPSent => _isOTPSent;
  String? get phoneNumber => _phoneNumber;

  // Mock OTP service for development
  Future<bool> sendOTP(String phoneNumber) async {
    _isLoading = true;
    _phoneNumber = phoneNumber;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 2));

    // For demo purposes, always succeed
    _isOTPSent = true;
    _verificationId =
        'mock_verification_id_${DateTime.now().millisecondsSinceEpoch}';
    _isLoading = false;
    notifyListeners();

    return true;
  }

  Future<bool> verifyOTP(String otp) async {
    if (!_isOTPSent || _verificationId == null) {
      return false;
    }

    _isLoading = true;
    notifyListeners();

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 1));

    // For demo purposes, accept any 6-digit OTP
    final isValid = otp.length == 6 && RegExp(r'^\d{6}$').hasMatch(otp);

    if (isValid) {
      _isOTPSent = false;
      _verificationId = null;
    }

    _isLoading = false;
    notifyListeners();

    return isValid;
  }

  Future<bool> resendOTP() async {
    if (_phoneNumber == null) return false;
    return await sendOTP(_phoneNumber!);
  }

  void reset() {
    _isLoading = false;
    _isOTPSent = false;
    _phoneNumber = null;
    _verificationId = null;
    notifyListeners();
  }

  // Validate phone number format (Indian format)
  bool isValidPhoneNumber(String phoneNumber) {
    // Remove spaces, dashes, and parentheses
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    // Check if it starts with +91 or 91 and has 10 digits after that
    if (cleanPhone.startsWith('+91')) {
      return cleanPhone.length == 13 &&
          RegExp(r'^\d{13}$').hasMatch(cleanPhone);
    } else if (cleanPhone.startsWith('91')) {
      return cleanPhone.length == 12 &&
          RegExp(r'^\d{12}$').hasMatch(cleanPhone);
    } else if (cleanPhone.startsWith('0')) {
      return cleanPhone.length == 11 &&
          RegExp(r'^\d{11}$').hasMatch(cleanPhone);
    } else {
      return cleanPhone.length == 10 &&
          RegExp(r'^\d{10}$').hasMatch(cleanPhone);
    }
  }

  // Format phone number for display
  String formatPhoneNumber(String phoneNumber) {
    final cleanPhone = phoneNumber.replaceAll(RegExp(r'[\s\-\(\)]'), '');

    if (cleanPhone.startsWith('+91')) {
      return '+91 ${cleanPhone.substring(3, 8)} ${cleanPhone.substring(8, 13)}';
    } else if (cleanPhone.startsWith('91')) {
      return '+91 ${cleanPhone.substring(2, 7)} ${cleanPhone.substring(7, 12)}';
    } else if (cleanPhone.startsWith('0')) {
      return '+91 ${cleanPhone.substring(1, 6)} ${cleanPhone.substring(6, 11)}';
    } else {
      return '+91 ${cleanPhone.substring(0, 5)} ${cleanPhone.substring(5, 10)}';
    }
  }
}
