import 'dart:convert';
// ApiService - handles all HTTP communication with the backend
import 'package:flutter/foundation.dart' show kIsWeb;
// ApiService - handles all HTTP communication with the backend
import 'package:http/http.dart' as http;
// ApiService - handles all HTTP communication with the backend
import 'package:shared_preferences/shared_preferences.dart';

// Note: This file handles all communication between Flutter and your FastAPI backend.
// It is designed to work on both Web (localhost) and Mobile (10.0.2.2).

class ApiService {
  // 1. DYNAMIC BASE URL
  static String get baseUrl {
    if (kIsWeb) {
      return "http://127.0.0.1:8000";
    }
    return "http://10.0.2.2:8000";
  }

  // 2. TOKEN HELPER
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String?> getSavedUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("full_name");
  }

  static Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("full_name", name);
  }

  // 3. LOGIN
  static Future<void> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode != 200) {
      throw Exception("Login error: ${res.body}");
    }

    final data = jsonDecode(res.body);
    final token = data["access_token"];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", token);

    // Fetch user profile immediately after login and save full name
    final profileData = await profile();
    final String fullName = (profileData["full_name"] ?? "").toString().trim();

    if (fullName.isNotEmpty) {
      await prefs.setString("full_name", fullName);
    }
  }

  // 4. SIGNUP (REGISTER)
  static Future<void> signup({
    required String email,
    required String password,
    String? fullName,
    String? phone,
    String? gender,
    String? birthday,
  }) async {
    final url = Uri.parse("$baseUrl/signup");

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
      throw Exception("Signup failed: ${res.body}");
    }
  }

  // 5. USER PROFILE
  static Future<Map<String, dynamic>> profile() async {
    final token = await getToken();

    if (token == null) {
      throw Exception("Token missing");
    }

    final url = Uri.parse("$baseUrl/profile");

    final res = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (res.statusCode != 200) {
      throw Exception("Profile error: ${res.body}");
    }

    return jsonDecode(res.body);
  }

  // 6. JOURNAL PROCESSOR (AI JOURNALING)
  // This sends your title and content to Python for Sentiment Analysis

  static Future<Map<String, dynamic>> processJournal(
    String title,
    String content,
  ) async {
    final token = await getToken();
    if (token == null) throw Exception("Authentication required");

    final url = Uri.parse("$baseUrl/journal/process");

    final res = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({"title": title, "content": content}),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("AI Journaling error: ${res.body}");
    }
  }

// 7. FORGOT PASSWORD (UPDATED)
  static Future<void> forgotPassword(String email) async {
    final url = Uri.parse("$baseUrl/forgot-password");

    try {
      final res = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (res.statusCode != 200) {
        // This will show the real error from your FastAPI backend
        final errorData = jsonDecode(res.body);
        throw Exception(errorData["detail"] ?? "Server Error: ${res.statusCode}");
      }
    } catch (e) {
      // If the server is offline or the URL is wrong, this catches it
      throw Exception("Connection Error: Check if your Backend is running.");
    }
  }

  // 8. RESET PASSWORD
  static Future<void> resetPassword(String email, String newPassword) async {
    final url = Uri.parse("$baseUrl/reset-password");

    final res = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "new_password": newPassword}),
    );

    if (res.statusCode != 200) {
      throw Exception("Password reset failed");
    }
  }

  // 9. LOGOUT
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("full_name");
  }
}
