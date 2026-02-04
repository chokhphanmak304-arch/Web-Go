// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcome => 'Welcome';

  @override
  String get enterEmailToSignIn => 'Enter your email to sign in';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get invalidEmailFormat => 'Invalid email format';

  @override
  String get sendOtp => 'Send OTP';

  @override
  String get otpInfoMessage =>
      'We will send a 6-digit OTP to your email.\n🎁 Get 15 days FREE trial!';

  @override
  String get demoMode => 'Demo Mode';

  @override
  String get emailNotConfigured =>
      'Email service not configured.\nYour OTP code is:';

  @override
  String get continueBtn => 'Continue';

  @override
  String get accessWebApps => 'Access your web apps anywhere';

  @override
  String get connectToWebsite => 'Connect to Website';

  @override
  String get enterUrlToStart => 'Enter any URL to get started';

  @override
  String get urlHint => 'e.g. example.com';

  @override
  String get pleaseEnterUrl => 'Please enter URL';

  @override
  String get connect => 'Connect';

  @override
  String get recent => 'Recent';

  @override
  String get subscriptionRequired => 'Subscription Required';

  @override
  String get subscriptionExpiredMessage =>
      'Your subscription has expired. Please subscribe to continue using the app.';

  @override
  String get cancel => 'Cancel';

  @override
  String get viewPlans => 'View Plans';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirm => 'Are you sure you want to sign out?';

  @override
  String account(String email) {
    return 'Account: $email';
  }

  @override
  String get customize => 'Customize';

  @override
  String get subscription => 'Subscription';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get enterOtpSentTo => 'Enter the 6-digit code sent to';

  @override
  String get pleaseEnterAllDigits => 'Please enter all 6 digits';

  @override
  String get invalidOtpCode => 'Invalid OTP code';

  @override
  String get verify => 'Verify';

  @override
  String get didntReceiveCode => 'Didn\'t receive code?';

  @override
  String get resend => 'Resend';

  @override
  String resendCountdown(int seconds) {
    return '${seconds}s';
  }

  @override
  String get newOtpSent => 'New OTP sent to your email!';

  @override
  String get failedToResendOtp => 'Failed to resend OTP';

  @override
  String get yourNewOtpCode => 'Your new OTP code is:';

  @override
  String get ok => 'OK';

  @override
  String get subscriptionPlans => 'Subscription Plans';

  @override
  String get restore => 'Restore';

  @override
  String get securePayment => 'Secure Payment via App Store / Play Store';

  @override
  String get whatYouGet => 'What You Get';

  @override
  String get compareFreeVsPremium => 'Compare Free vs Premium features';

  @override
  String get freeTrial => 'Free (Trial)';

  @override
  String get access1Url => 'Access 1 URL';

  @override
  String get basicWebview => 'Basic WebView';

  @override
  String get customBrandingDisabled => 'Custom App Name / Logo / Color';

  @override
  String get multipleUrlsDisabled => 'Multiple URLs';

  @override
  String get premiumSubscriber => 'Premium (Subscriber)';

  @override
  String get unlimitedUrlAccess => 'Unlimited URL Access';

  @override
  String get fullWebviewFeatures => 'Full WebView Features';

  @override
  String get customAppName => 'Custom App Name (Branding)';

  @override
  String get customAppLogo => 'Custom App Logo';

  @override
  String get customAppColorTheme => 'Custom App Color Theme';

  @override
  String get pickFromCameraGallery => 'Pick from Camera / Gallery / Files';

  @override
  String get adFreeExperience => 'Ad-Free Experience';

  @override
  String get earlyAccessNewFeatures => 'Early Access to New Features';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get active => 'Active';

  @override
  String get expired => 'Expired';

  @override
  String get freeTrialPlan => 'Free Trial';

  @override
  String get monthly => 'Monthly';

  @override
  String get threeMonths => '3 Months';

  @override
  String get sixMonths => '6 Months';

  @override
  String get yearly => 'Yearly';

  @override
  String get bestValueBilled => 'Best value! Billed annually.';

  @override
  String get greatSavingsBilled => 'Great savings! Billed every 6 months.';

  @override
  String get saveMoreBilled => 'Save more! Billed every 3 months.';

  @override
  String get billedMonthly => 'Billed monthly. Cancel anytime.';

  @override
  String get loadingFromStore => 'Loading from store...';

  @override
  String get monthlyPlan => 'Monthly Plan';

  @override
  String get yearlyPlan => 'Yearly Plan';

  @override
  String get oneMonth => '1 month';

  @override
  String get threeMonthsDuration => '3 months';

  @override
  String get sixMonthsDuration => '6 months';

  @override
  String get oneYear => '1 year';

  @override
  String savePct(String pct) {
    return 'Save $pct';
  }

  @override
  String get paymentSecured => 'Payment secured by Google Play / App Store';

  @override
  String get processing => 'Processing...';

  @override
  String get success => 'Success!';

  @override
  String subscriptionNowActive(String planType) {
    return 'Your $planType subscription is now active!';
  }

  @override
  String get purchasesRestored => 'Purchases restored';

  @override
  String subscribe(String price) {
    return 'Subscribe $price';
  }

  @override
  String daysRemaining(int days) {
    return '$days days remaining';
  }

  @override
  String get subscriptionExpired => 'Subscription expired';

  @override
  String get customizeApp => 'Customize App';

  @override
  String get appName => 'App Name';

  @override
  String get enterAppName => 'Enter app name';

  @override
  String get appColor => 'App Color';

  @override
  String get appLogo => 'App Logo';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get resetToDefault => 'Reset to Default';

  @override
  String get brandingSaved =>
      'Branding saved! Restart app to see full changes.';

  @override
  String get resetToDefaultBranding => 'Reset to default branding.';

  @override
  String get chooseLogoImage => 'Choose Logo Image';

  @override
  String get takePhoto => 'Take Photo';

  @override
  String get useCamera => 'Use camera to take a new photo';

  @override
  String get photoGallery => 'Photo Gallery';

  @override
  String get chooseFromLibrary => 'Choose from photo library';

  @override
  String get browseFiles => 'Browse Files';

  @override
  String get chooseFromFiles => 'Choose from device files';

  @override
  String get chooseLogo => 'Choose Logo';

  @override
  String get removeCustomLogo => 'Remove Custom Logo';

  @override
  String get preview => 'Preview';

  @override
  String get noInternet =>
      'No internet connection.\nPlease check your network.';

  @override
  String get failedToLoadPage => 'Failed to load page.';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get chooseDifferentUrl => 'Choose Different URL';

  @override
  String get exit => 'Exit';

  @override
  String get exitConfirm => 'Do you want to go back to URL selection?';

  @override
  String get confirm => 'Confirm';

  @override
  String get refresh => 'Refresh';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get thai => 'ไทย';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String get failedToRegister => 'Failed to register';

  @override
  String get membershipExpired => 'Membership Expired';

  @override
  String get membershipExpiredMessage =>
      'Your membership has expired.\nPlease renew your package to continue using the app.';

  @override
  String get renewPackage => 'Renew Package';

  @override
  String get testCode => 'Test Code';

  @override
  String get enterTestCode => 'Enter test code';

  @override
  String get activateCode => 'Activate';

  @override
  String get invalidTestCode => 'Invalid or expired test code';

  @override
  String get testCodeActivated =>
      'Test code activated! Your subscription is now active.';

  @override
  String get haveTestCode => 'Have a test code?';

  @override
  String get activating => 'Activating...';

  @override
  String get verificationFailed =>
      'Purchase verification failed. Please try again.';

  @override
  String get tooManyOtpRequests =>
      'Too many OTP requests. Please wait a few minutes.';

  @override
  String get emailAlreadyRegistered =>
      'This email is already registered. OTP sent for login.';

  @override
  String get proPlans => 'Pro Plans';

  @override
  String get proMonthly => 'Pro Monthly';

  @override
  String get proYearly => 'Pro Yearly';

  @override
  String proDescription(int count) {
    return 'Use on up to $count devices with 1 account';
  }

  @override
  String get proBadge => 'PRO';

  @override
  String upToDevices(int count) {
    return 'Up to $count devices';
  }

  @override
  String get standardPlan => 'Standard';

  @override
  String get oneDevice => '1 device';

  @override
  String get deviceLimitReached => 'Device limit reached';

  @override
  String deviceLimitMessage(int count) {
    return 'Your plan allows maximum $count device(s). Please upgrade to Pro to use up to 5 devices.';
  }

  @override
  String get upgradeToPro => 'Upgrade to Pro';

  @override
  String get proMonthlyBilled => 'Pro plan billed monthly. Up to 5 devices.';

  @override
  String get proYearlyBilled =>
      'Best Pro value! Billed annually. Up to 5 devices.';

  @override
  String get deleteHistory => 'Delete History';

  @override
  String get deleteHistoryConfirm =>
      'Are you sure you want to delete this URL from history?';

  @override
  String get delete => 'Delete';
}
