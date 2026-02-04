import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailService {
  static const String _serviceId = 'service_bov7prv';
  static const String _templateId = 'template_w3kvjvs';
  static const String _publicKey = 'AnsuF-AVN32yeK4rt';
  
  static Future<bool> sendOTPEmail({
    required String toEmail,
    required String otpCode,
  }) async {
    try {
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'origin': 'http://localhost',
        },
        body: json.encode({
          'service_id': _serviceId,
          'template_id': _templateId,
          'user_id': _publicKey,
          'template_params': {
            'email': toEmail,
            'passcode': otpCode,
            'time': '5 minutes',
          },
        }),
      );
      
      print('EmailJS Response: ${response.statusCode} - ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}
