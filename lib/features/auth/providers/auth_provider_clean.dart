import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/hold_token.dart';
import '../models/auth_state.dart';
import '../services/auth_service.dart';
import '../utils/token_manager.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;
  final TokenManager _tokenManager;
  AuthState _state = AuthState();

  AuthProvider(this._authService, this._tokenManager);

  bool get isAuthenticated => _state.isAuthenticated;
  String? get token => _state.token;
  String? get error => _state.error;

  // Send OTP to phone number
  Future<bool> sendOTP({required String phoneNumber}) async {
    try {
      final result = await _authService.sendOTP(phoneNumber);

      if (result['success'] == true) {
        _state = _state.copyWith(error: null);
        notifyListeners();
        return true;
      } else {
        _state = _state.copyWith(
          error: result['message'] ?? 'Failed to send OTP',
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = _state.copyWith(error: e.toString());
      notifyListeners();
      return false;
    }
  }

  // Register user with OTP (called from OTP screen)
  Future<bool> register({
    required String phoneNumber,
    required String password,
    required String name,
    required String otp,
  }) async {
    try {
      final result = await _authService.register(
        phoneNumber,
        password,
        name,
        otp,
      );

      if (result['success'] == true) {
        _state = _state.copyWith(
          isAuthenticated: true,
          token: result['token'],
          error: null,
        );
        if (result['token'] != null) {
          await _tokenManager.saveToken(
            result['token'],
            DateTime.now().add(const Duration(hours: 24)),
          );
        }
        notifyListeners();
        return true;
      } else {
        _state = _state.copyWith(
          error: result['message'] ?? 'Registration failed',
        );
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = _state.copyWith(error: e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<bool> login(String phone, String password) async {
    try {
      final result = await _authService.login(phone, password);

      if (result['success'] == true) {
        _state = _state.copyWith(
          isAuthenticated: true,
          token: result['token'],
          error: null,
        );
        if (result['token'] != null) {
          await _tokenManager.saveToken(
            result['token'],
            DateTime.now().add(const Duration(hours: 24)),
          );
        }
        notifyListeners();
        return true;
      } else {
        _state = _state.copyWith(error: result['message'] ?? 'Login failed');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _state = _state.copyWith(error: e.toString());
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _tokenManager.clearToken();
    _state = AuthState();
    notifyListeners();
  }

  Future<void> checkAuthState() async {
    final isValid = await _tokenManager.isTokenValid();
    if (isValid) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(HoldToken.name);
      if (token != null) {
        _state = _state.copyWith(isAuthenticated: true, token: token);
      }
    } else {
      _state = AuthState();
    }
    notifyListeners();
  }
}
