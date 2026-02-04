import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _userEmailKey = 'user_email';
  static const String _registeredEmailsKey = 'registered_emails';
  
  // สร้าง OTP Code 6 หลัก
  static String generateOTP() {
    final random = Random();
    String otp = '';
    for (int i = 0; i < 6; i++) {
      otp += random.nextInt(10).toString();
    }
    return otp;
  }
  
  // ตรวจสอบว่า Login อยู่หรือไม่
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }
  
  // ดึง Email ที่ Login อยู่
  static Future<String?> getCurrentUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userEmailKey);
  }

  // บันทึกการ Login
  static Future<void> login(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, true);
    await prefs.setString(_userEmailKey, email);
    
    // เพิ่ม email ลงในรายการ registered emails
    List<String> registeredEmails = prefs.getStringList(_registeredEmailsKey) ?? [];
    if (!registeredEmails.contains(email)) {
      registeredEmails.add(email);
      await prefs.setStringList(_registeredEmailsKey, registeredEmails);
    }
  }
  
  // Logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, false);
    await prefs.remove(_userEmailKey);
  }
  
  // ตรวจสอบว่า Email เคยลงทะเบียนหรือยัง
  static Future<bool> isEmailRegistered(String email) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> registeredEmails = prefs.getStringList(_registeredEmailsKey) ?? [];
    return registeredEmails.contains(email);
  }
  
  // Validate Email Format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }
}
