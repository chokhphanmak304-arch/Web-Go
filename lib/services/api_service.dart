import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://npdhrms.com/odoo_api/odoo_app_api.php';
  
  // Register & Send OTP
  static Future<Map<String, dynamic>> register(String email) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'register', 'email': email}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
  
  // Verify OTP
  static Future<Map<String, dynamic>> verifyOTP(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'verify_otp', 'email': email, 'otp': otp}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Check Subscription
  static Future<Map<String, dynamic>> checkSubscription(String email) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'check_subscription', 'email': email}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
  
  // Get Plans
  static Future<Map<String, dynamic>> getPlans() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'get_plans'}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
  
  // Verify Purchase Receipt with Google Play / App Store via server
  static Future<Map<String, dynamic>> verifyPurchaseReceipt({
    required String email,
    required String productId,
    required String receiptData,
    required String platform,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'verify_receipt',
          'email': email,
          'product_id': productId,
          'receipt_data': receiptData,
          'platform': platform,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Activate Test Code
  static Future<Map<String, dynamic>> activateTestCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'activate_test_code',
          'email': email,
          'code': code,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Register Device (for Pro plan device tracking)
  static Future<Map<String, dynamic>> registerDevice({
    required String email,
    required String deviceId,
    required String deviceName,
    required String platform,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'register_device',
          'email': email,
          'device_id': deviceId,
          'device_name': deviceName,
          'platform': platform,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Check Devices
  static Future<Map<String, dynamic>> checkDevices(String email) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'check_device', 'email': email}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Process Payment
  static Future<Map<String, dynamic>> processPayment({
    required String email,
    required String planType,
    String? transactionId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'process_payment',
          'email': email,
          'plan_type': planType,
          'transaction_id': transactionId ?? 'TXN_${DateTime.now().millisecondsSinceEpoch}',
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
}

// Subscription Model
class SubscriptionInfo {
  final String planType;
  final String status;
  final String? startDate;
  final String? endDate;
  final int daysRemaining;
  final bool isActive;
  final int maxDevices;
  final bool isPro;

  SubscriptionInfo({
    required this.planType,
    required this.status,
    this.startDate,
    this.endDate,
    required this.daysRemaining,
    required this.isActive,
    this.maxDevices = 1,
    this.isPro = false,
  });

  factory SubscriptionInfo.fromJson(Map<String, dynamic> json) {
    return SubscriptionInfo(
      planType: json['plan_type'] ?? 'none',
      status: json['status'] ?? 'expired',
      startDate: json['start_date'],
      endDate: json['end_date'],
      daysRemaining: (json['days_remaining'] ?? 0).toInt(),
      isActive: json['is_active'] ?? false,
      maxDevices: json['max_devices'] ?? 1,
      isPro: json['is_pro'] ?? false,
    );
  }

  bool get isTrial => planType == 'trial';
  bool get isExpired => !isActive;
}
