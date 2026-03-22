import 'dart:convert';
import 'dart:io'; // Needed for Platform check
import 'package:flutter/foundation.dart' show kIsWeb; // Needed for Web check
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // DYNAMIC URL: Automatically switches based on where the app is running
  static String get baseUrl {
    if (kIsWeb) {
      return "http://localhost:8000"; // For Chrome/Web
    } else if (Platform.isAndroid) {
      return "http://10.0.2.2:8000"; // For Android Emulator
    } else {
      return "http://127.0.0.1:8000"; // For iOS Simulator or others
    }
  }

  // LOGIN 
  static Future<void> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Login error: ${res.body}");
    }

    final data = jsonDecode(res.body);
    final token = data["access_token"];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);
  }

  //  PROFILE 
  static Future<Map<String, dynamic>> profile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    if (token == null) {
      throw Exception("Token missing");
    }

    final url = Uri.parse("$baseUrl/profile");

    final res = await http.get(
      url,
      headers: {"Authorization": "Bearer $token"},
    );

    if (res.statusCode != 200) {
      throw Exception("Profile error: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  //  SIGNUP 
  static Future<void> signup({
    required String email,
    required String password,
    String? fullName,
    String? phone,
    String? gender,
    String? birthday,
  }) async {
    final url = Uri.parse("$baseUrl/signin");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
        "full_name": fullName,
        "phone": phone,
        "gender": gender,
        "birthday": birthday,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception(res.body);
    }
  }

  //FORGOT PASSWORD 
  static Future<void> forgotPassword(String email) async {
    final url = Uri.parse("$baseUrl/forgot-password");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (res.statusCode != 200) {
      throw Exception("Email not found");
    }
  }

  // RESET PASSWORD 
  static Future<void> resetPassword(String email, String newPassword) async {
    final url = Uri.parse("$baseUrl/reset-password");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "new_password": newPassword,
      }),
    );

    if (res.statusCode != 200) {
      throw Exception("Password reset failed");
    }
  }

  //  LOGOUT 
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}