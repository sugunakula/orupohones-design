import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  final Dio _dio;
  final SharedPreferences _prefs;
  String? _csrfToken;
  String? _cookie;
  
  AuthService(this._prefs) : _dio = Dio(BaseOptions(
    baseUrl: 'http://40.90.224.241:5000',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  )) {
    // Add interceptor to handle cookies and CSRF tokens
    _dio.interceptors.add(InterceptorsWrapper(
      onResponse: (response, handler) {
        // Extract and store cookie
        final cookies = response.headers['set-cookie'];
        if (cookies != null && cookies.isNotEmpty) {
          _cookie = cookies.first;
          print('Got cookie: $_cookie'); // For debugging
        }

        // Check for CSRF token in response data
        if (response.data is Map && response.data['csrfToken'] != null) {
          _csrfToken = response.data['csrfToken'];
          print('Got CSRF token from response: $_csrfToken');
        }
        
        return handler.next(response);
      },
      onRequest: (options, handler) {
        // Add cookie to requests if available
        if (_cookie != null) {
          options.headers['Cookie'] = _cookie;
        }
        return handler.next(options);
      },
    ));
  }

  Future<bool> createOtp(String phoneNumber) async {
    try {
      final response = await _dio.post(
        '/login/otpCreate',
        data: {
          'countryCode': 91,
          'mobileNumber': int.parse(phoneNumber.trim())
        },
      );
      print('OTP Response: ${response.data}'); // For debugging
      return response.statusCode == 200;
    } catch (e) {
      print('Error creating OTP: $e');
      return false;
    }
  }

  Future<bool> verifyOtp(String phoneNumber, String otp) async {
    try {
      final response = await _dio.post(
        '/login/otpValidate',
        data: {
          'countryCode': 91,
          'mobileNumber': int.parse(phoneNumber.trim()),
          'otp': int.parse(otp.trim()),
        },
      );

      print('Verify OTP Response: ${response.data}');

      if (response.statusCode == 200) {
        // Store cookie from response
        final cookies = response.headers['set-cookie'];
        if (cookies != null && cookies.isNotEmpty) {
          _cookie = cookies.first;
          // Save cookie to SharedPreferences
          await _prefs.setString('cookie', _cookie!);
          print('Got cookie: $_cookie');
        }

        final loginStatus = await checkLoginStatus();
        if (loginStatus != null && loginStatus['isLoggedIn'] == true) {
          // Save login state
          await _prefs.setBool('isLoggedIn', true);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error validating OTP: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> checkLoginStatus() async {
    try {
      // Restore cookie if available
      if (_cookie == null) {
        _cookie = _prefs.getString('cookie');
      }

      final response = await _dio.get('/isLoggedIn', 
        options: Options(
          headers: _cookie != null ? {'Cookie': _cookie!} : null,
        ),
      );
      
      if (response.statusCode == 200 && response.data['isLoggedIn'] == true) {
        _csrfToken = response.data['csrfToken'];
        // Save user data
        await _prefs.setString('userData', json.encode(response.data));
        return response.data;
      }

      // Clear stored data if not logged in
      await _clearStoredData();
      return null;
    } catch (e) {
      print('Error checking login status: $e');
      await _clearStoredData();
      return null;
    }
  }

  Future<bool> updateUserName(String userName) async {
    try {
      // First ensure we have a valid session
      final loginStatus = await checkLoginStatus();
      if (loginStatus == null || loginStatus['isLoggedIn'] != true) {
        print('Not logged in or invalid session');
        return false;
      }

      // Get fresh CSRF token from login status
      _csrfToken = loginStatus['csrfToken'];
      if (_csrfToken == null) {
        print('No CSRF token in login response');
        return false;
      }

      print('Updating username with token: $_csrfToken');
      final response = await _dio.post(
        '/update',
        data: {
          'countryCode': 91,
          'userName': userName
        },
        options: Options(
          headers: {
            'X-Csrf-Token': _csrfToken,
            if (_cookie != null) 'Cookie': _cookie!,
          }
        ),
      );
      
      print('Update response: ${response.data}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error updating username: $e');
      return false;
    }
  }

  Future<bool> logout() async {
    try {
      final response = await _dio.get(
        '/logout',
        options: Options(
          headers: {
            'X-Csrf-Token': _csrfToken,
            if (_cookie != null) 'Cookie': _cookie!,
          }
        ),
      );
      
      if (response.statusCode == 200) {
        await _clearStoredData();
        return true;
      }
      return false;
    } catch (e) {
      print('Error logging out: $e');
      return false;
    }
  }

  Future<bool> toggleProductLike(String listingId, bool isFav) async {
    try {
      if (_csrfToken == null) {
        print('No CSRF token available');
        await checkLoginStatus();
        if (_csrfToken == null) return false;
      }

      final response = await _dio.post(
        '/favs',
        data: {
          'listingId': listingId,
          'isFav': isFav,
        },
        options: Options(
          headers: {
            'X-Csrf-Token': _csrfToken,
            if (_cookie != null) 'Cookie': _cookie!,
          }
        ),
      );

      print('Like response: ${response.data}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error toggling like: $e');
      return false;
    }
  }

  Future<void> _clearStoredData() async {
    await _prefs.remove('cookie');
    await _prefs.remove('userData');
    await _prefs.remove('isLoggedIn');
    _cookie = null;
    _csrfToken = null;
  }
} 