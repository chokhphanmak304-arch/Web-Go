import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl = 'https://npdhrms.com/odoo_api/odoo_app_payment.php';
  
  static String? _publicKey;
  static Map<String, int>? _prices;
  
  // Initialize - get Omise public key
  static Future<void> init() async {
    try {
      final result = await getOmiseKey();
      if (result['success']) {
        _publicKey = result['public_key'];
        _prices = {
          'monthly': result['prices']['monthly'],
          'yearly': result['prices']['yearly'],
        };
      }
    } catch (e) {
      debugPrint('Payment init error: $e');
    }
  }
  
  static String? get publicKey => _publicKey;
  static int getPrice(String planType) => _prices?[planType] ?? 0;
  
  // Get Omise Public Key
  static Future<Map<String, dynamic>> getOmiseKey() async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'action': 'get_omise_key'}),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }

  // Create Credit Card Charge
  static Future<Map<String, dynamic>> createCardCharge({
    required String email,
    required String planType,
    required String token,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'create_charge',
          'email': email,
          'plan_type': planType,
          'token': token,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
  
  // Create PromptPay QR
  static Future<Map<String, dynamic>> createPromptPay({
    required String email,
    required String planType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'create_promptpay',
          'email': email,
          'plan_type': planType,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
  
  // Check PromptPay Payment Status
  static Future<Map<String, dynamic>> checkChargeStatus({
    required String chargeId,
    required String email,
    required String planType,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'action': 'check_charge',
          'charge_id': chargeId,
          'email': email,
          'plan_type': planType,
        }),
      );
      return json.decode(response.body);
    } catch (e) {
      return {'success': false, 'message': 'Connection error: $e'};
    }
  }
}
