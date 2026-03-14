import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  User? _user;
  bool _isLoading = false;
  bool _isEmailVerified = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isEmailVerified => _isEmailVerified;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _authService.user.listen((User? user) {
      _user = user;
      if (user != null) {
        _checkVerificationStatus();
      } else {
        _isEmailVerified = false;
      }
      notifyListeners();
    });
  }

  Future<void> _checkVerificationStatus() async {
    _isEmailVerified = await _authService.checkEmailVerified();
    notifyListeners();
  }

  Future<void> reloadUser() async {
    await _checkVerificationStatus();
  }

  Future<String?> signUp(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _authService.signUp(email, password);
      _isLoading = false;
      notifyListeners();
      return null; // No error
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "An unexpected error occurred.";
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _authService.login(email, password);
      _isLoading = false;
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      return e.message;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return "An unexpected error occurred.";
    }
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
