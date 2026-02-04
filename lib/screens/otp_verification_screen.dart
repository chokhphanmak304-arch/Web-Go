import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../l10n/generated/app_localizations.dart';
import '../services/auth_service.dart';
import '../services/api_service.dart';
import '../services/branding_service.dart';
import '../services/email_service.dart';
import 'url_input_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final String otpCode;

  const OTPVerificationScreen({super.key, required this.email, required this.otpCode});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  
  bool _isLoading = false;
  String? _errorMessage;
  String _currentOTP = '';
  int _resendCountdown = 60;
  Timer? _timer;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _currentOTP = widget.otpCode;
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendCountdown = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var c in _controllers) { c.dispose(); }
    for (var n in _focusNodes) { n.dispose(); }
    super.dispose();
  }

  String _getEnteredOTP() => _controllers.map((c) => c.text).join();

  void _verifyOTP() async {
    final enteredOTP = _getEnteredOTP();
    if (enteredOTP.length != 6) {
      setState(() => _errorMessage = AppLocalizations.of(context)!.pleaseEnterAllDigits);
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });
    
    final result = await ApiService.verifyOTP(widget.email, enteredOTP);
    
    if (result['success']) {
      await AuthService.login(widget.email);
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const UrlInputScreen()),
        (route) => false,
      );
    } else {
      setState(() { 
        _isLoading = false; 
        _errorMessage = result['message'] ?? AppLocalizations.of(context)!.invalidOtpCode;
      });
      for (var c in _controllers) { c.clear(); }
      _focusNodes[0].requestFocus();
    }
  }

  Future<void> _resendOTP() async {
    if (!_canResend) return;
    setState(() => _isLoading = true);

    final result = await ApiService.register(widget.email);
    
    if (result['success']) {
      _currentOTP = result['otp'] ?? '';
      
      // Try to send email
      final emailSent = await EmailService.sendOTPEmail(
        toEmail: widget.email,
        otpCode: _currentOTP,
      );
      
      setState(() => _isLoading = false);
      _startResendTimer();
      
      if (!mounted) return;
      
      if (emailSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.newOtpSent),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Show OTP in dialog (demo mode)
        _showDemoOTPDialog(_currentOTP);
      }
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? AppLocalizations.of(context)!.failedToResendOtp),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showDemoOTPDialog(String otpCode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(AppLocalizations.of(context)!.demoMode),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(AppLocalizations.of(context)!.yourNewOtpCode),
            const SizedBox(height: 15),
            Text(
              otpCode,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                color: BrandingService.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.shortestSide >= 600;
    final horizontalPadding = isTablet ? size.width * 0.15 : 20.0;
    
    // Calculate OTP box size based on screen width
    final availableWidth = size.width - (horizontalPadding * 2) - 50; // 50 for margins
    final boxSize = (availableWidth / 6).clamp(40.0, 55.0);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: BrandingService.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.verifyOtp,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon
              Center(
                child: Container(
                  width: isTablet ? 90 : 70,
                  height: isTablet ? 90 : 70,
                  decoration: BoxDecoration(
                    color: BrandingService.primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mark_email_read_outlined,
                    size: isTablet ? 45 : 35,
                    color: BrandingService.primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Title
              Text(
                AppLocalizations.of(context)!.verifyOtp,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTablet ? 28 : 22,
                  fontWeight: FontWeight.bold,
                  color: BrandingService.primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.enterOtpSentTo,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 13,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.email,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: BrandingService.primaryColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 30),
              
              // OTP Input Boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Container(
                    width: boxSize,
                    height: boxSize + 5,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: TextFormField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: TextStyle(
                        fontSize: boxSize * 0.45,
                        fontWeight: FontWeight.bold,
                        color: BrandingService.primaryColor,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: BrandingService.primaryColor.withOpacity(0.3)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: BrandingService.primaryColor.withOpacity(0.3)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: BrandingService.primaryColor, width: 2),
                        ),
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        }
                        if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        if (_getEnteredOTP().length == 6) {
                          _verifyOTP();
                        }
                      },
                    ),
                  );
                }),
              ),

              // Error Message
              if (_errorMessage != null) ...[
                const SizedBox(height: 15),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red[700], size: 18),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red[700], fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 25),
              
              // Verify Button
              SizedBox(
                height: isTablet ? 55 : 48,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BrandingService.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          AppLocalizations.of(context)!.verify,
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Resend Code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.didntReceiveCode} ",
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isTablet ? 15 : 13,
                    ),
                  ),
                  TextButton(
                    onPressed: _canResend ? _resendOTP : null,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      _canResend ? AppLocalizations.of(context)!.resend : '${_resendCountdown}s',
                      style: TextStyle(
                        color: _canResend ? BrandingService.primaryColor : Colors.grey[400],
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 15 : 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
