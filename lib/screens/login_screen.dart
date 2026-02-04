import 'package:flutter/material.dart';
import '../l10n/generated/app_localizations.dart';
import '../services/api_service.dart';
import '../services/email_service.dart';
import '../services/branding_service.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { _isLoading = true; _errorMessage = null; });

    final email = _emailController.text.trim();
    
    // Register with API to get OTP
    final result = await ApiService.register(email);

    if (!result['success']) {
      setState(() {
        _isLoading = false;
        if (result['error_code'] == 'rate_limited') {
          _errorMessage = AppLocalizations.of(context)?.tooManyOtpRequests ?? result['message'];
        } else {
          _errorMessage = result['message'] ?? AppLocalizations.of(context)?.failedToRegister ?? 'Failed to register';
        }
      });
      return;
    }

    final otpCode = result['otp'] ?? '';
    
    // Send OTP via Email
    final emailSent = await EmailService.sendOTPEmail(
      toEmail: email,
      otpCode: otpCode,
    );

    setState(() => _isLoading = false);
    if (!mounted) return;

    if (emailSent) {
      // Email sent successfully - go to OTP screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => OTPVerificationScreen(email: email, otpCode: otpCode),
        ),
      );
    } else {
      // Email failed - show OTP in dialog (demo mode)
      _showDemoOTPDialog(email, otpCode);
    }
  }

  void _showDemoOTPDialog(String email, String otpCode) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Row(
          children: [
            Icon(Icons.info_outline, color: BrandingService.primaryColor),
            SizedBox(width: 10),
            Expanded(child: Text(AppLocalizations.of(context)!.demoMode, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.emailNotConfigured),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                otpCode,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                  color: BrandingService.primaryColor,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => OTPVerificationScreen(email: email, otpCode: otpCode),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: BrandingService.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text(AppLocalizations.of(context)!.continueBtn, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final horizontalPadding = isTablet ? size.width * 0.2 : 30.0;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: size.height * 0.05),
                // Logo
                Center(
                  child: Container(
                    width: isTablet ? 180 : 140,
                    height: isTablet ? 180 : 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: BrandingService.primaryColor.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(15),
                    child: BrandingService.buildLogo(fit: BoxFit.contain),
                  ),
                ),
                const SizedBox(height: 30),
                // Title
                Text(
                  AppLocalizations.of(context)!.welcome,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isTablet ? 36 : 26,
                    fontWeight: FontWeight.bold,
                    color: BrandingService.primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.enterEmailToSignIn,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: isTablet ? 18 : 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 30),
                // Email Input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: BrandingService.primaryColor.withOpacity(0.3)),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _sendOTP(),
                    style: TextStyle(fontSize: isTablet ? 18 : 16),
                    decoration: InputDecoration(
                      hintText: 'example@email.com',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: BrandingService.primaryColor,
                        size: isTablet ? 28 : 24,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: BrandingService.primaryColor, width: 2),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: isTablet ? 20 : 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) return AppLocalizations.of(context)!.pleaseEnterEmail;
                      if (!_isValidEmail(value)) return AppLocalizations.of(context)!.invalidEmailFormat;
                      return null;
                    },
                  ),
                ),
                // Error Message
                if (_errorMessage != null) ...[
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red[700], size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red[700], fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                // Send OTP Button
                SizedBox(
                  height: isTablet ? 60 : 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _sendOTP,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BrandingService.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.send, size: isTablet ? 24 : 20),
                              const SizedBox(width: 10),
                              Text(
                                AppLocalizations.of(context)!.sendOtp,
                                style: TextStyle(
                                  fontSize: isTablet ? 20 : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
                const SizedBox(height: 25),
                // Info Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.otpInfoMessage,
                          style: TextStyle(
                            color: Colors.blue[700],
                            fontSize: isTablet ? 15 : 13,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
