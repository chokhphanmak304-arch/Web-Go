import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th')
  ];

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @enterEmailToSignIn.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to sign in'**
  String get enterEmailToSignIn;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @invalidEmailFormat.
  ///
  /// In en, this message translates to:
  /// **'Invalid email format'**
  String get invalidEmailFormat;

  /// No description provided for @sendOtp.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtp;

  /// No description provided for @otpInfoMessage.
  ///
  /// In en, this message translates to:
  /// **'We will send a 6-digit OTP to your email.\n🎁 Get 15 days FREE trial!'**
  String get otpInfoMessage;

  /// No description provided for @demoMode.
  ///
  /// In en, this message translates to:
  /// **'Demo Mode'**
  String get demoMode;

  /// No description provided for @emailNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Email service not configured.\nYour OTP code is:'**
  String get emailNotConfigured;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @accessWebApps.
  ///
  /// In en, this message translates to:
  /// **'Access your web apps anywhere'**
  String get accessWebApps;

  /// No description provided for @connectToWebsite.
  ///
  /// In en, this message translates to:
  /// **'Connect to Website'**
  String get connectToWebsite;

  /// No description provided for @enterUrlToStart.
  ///
  /// In en, this message translates to:
  /// **'Enter any URL to get started'**
  String get enterUrlToStart;

  /// No description provided for @urlHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. example.com'**
  String get urlHint;

  /// No description provided for @pleaseEnterUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter URL'**
  String get pleaseEnterUrl;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @recent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get recent;

  /// No description provided for @subscriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Subscription Required'**
  String get subscriptionRequired;

  /// No description provided for @subscriptionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your subscription has expired. Please subscribe to continue using the app.'**
  String get subscriptionExpiredMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @viewPlans.
  ///
  /// In en, this message translates to:
  /// **'View Plans'**
  String get viewPlans;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signOutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirm;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account: {email}'**
  String account(String email);

  /// No description provided for @customize.
  ///
  /// In en, this message translates to:
  /// **'Customize'**
  String get customize;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @verifyOtp.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP'**
  String get verifyOtp;

  /// No description provided for @enterOtpSentTo.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to'**
  String get enterOtpSentTo;

  /// No description provided for @pleaseEnterAllDigits.
  ///
  /// In en, this message translates to:
  /// **'Please enter all 6 digits'**
  String get pleaseEnterAllDigits;

  /// No description provided for @invalidOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid OTP code'**
  String get invalidOtpCode;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @didntReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive code?'**
  String get didntReceiveCode;

  /// No description provided for @resend.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get resend;

  /// No description provided for @resendCountdown.
  ///
  /// In en, this message translates to:
  /// **'{seconds}s'**
  String resendCountdown(int seconds);

  /// No description provided for @newOtpSent.
  ///
  /// In en, this message translates to:
  /// **'New OTP sent to your email!'**
  String get newOtpSent;

  /// No description provided for @failedToResendOtp.
  ///
  /// In en, this message translates to:
  /// **'Failed to resend OTP'**
  String get failedToResendOtp;

  /// No description provided for @yourNewOtpCode.
  ///
  /// In en, this message translates to:
  /// **'Your new OTP code is:'**
  String get yourNewOtpCode;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @subscriptionPlans.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plans'**
  String get subscriptionPlans;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @securePayment.
  ///
  /// In en, this message translates to:
  /// **'Secure Payment via App Store / Play Store'**
  String get securePayment;

  /// No description provided for @whatYouGet.
  ///
  /// In en, this message translates to:
  /// **'What You Get'**
  String get whatYouGet;

  /// No description provided for @compareFreeVsPremium.
  ///
  /// In en, this message translates to:
  /// **'Compare Free vs Premium features'**
  String get compareFreeVsPremium;

  /// No description provided for @freeTrial.
  ///
  /// In en, this message translates to:
  /// **'Free (Trial)'**
  String get freeTrial;

  /// No description provided for @access1Url.
  ///
  /// In en, this message translates to:
  /// **'Access 1 URL'**
  String get access1Url;

  /// No description provided for @basicWebview.
  ///
  /// In en, this message translates to:
  /// **'Basic WebView'**
  String get basicWebview;

  /// No description provided for @customBrandingDisabled.
  ///
  /// In en, this message translates to:
  /// **'Custom App Name / Logo / Color'**
  String get customBrandingDisabled;

  /// No description provided for @multipleUrlsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Multiple URLs'**
  String get multipleUrlsDisabled;

  /// No description provided for @premiumSubscriber.
  ///
  /// In en, this message translates to:
  /// **'Premium (Subscriber)'**
  String get premiumSubscriber;

  /// No description provided for @unlimitedUrlAccess.
  ///
  /// In en, this message translates to:
  /// **'Unlimited URL Access'**
  String get unlimitedUrlAccess;

  /// No description provided for @fullWebviewFeatures.
  ///
  /// In en, this message translates to:
  /// **'Full WebView Features'**
  String get fullWebviewFeatures;

  /// No description provided for @customAppName.
  ///
  /// In en, this message translates to:
  /// **'Custom App Name (Branding)'**
  String get customAppName;

  /// No description provided for @customAppLogo.
  ///
  /// In en, this message translates to:
  /// **'Custom App Logo'**
  String get customAppLogo;

  /// No description provided for @customAppColorTheme.
  ///
  /// In en, this message translates to:
  /// **'Custom App Color Theme'**
  String get customAppColorTheme;

  /// No description provided for @pickFromCameraGallery.
  ///
  /// In en, this message translates to:
  /// **'Pick from Camera / Gallery / Files'**
  String get pickFromCameraGallery;

  /// No description provided for @adFreeExperience.
  ///
  /// In en, this message translates to:
  /// **'Ad-Free Experience'**
  String get adFreeExperience;

  /// No description provided for @earlyAccessNewFeatures.
  ///
  /// In en, this message translates to:
  /// **'Early Access to New Features'**
  String get earlyAccessNewFeatures;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @freeTrialPlan.
  ///
  /// In en, this message translates to:
  /// **'Free Trial'**
  String get freeTrialPlan;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @threeMonths.
  ///
  /// In en, this message translates to:
  /// **'3 Months'**
  String get threeMonths;

  /// No description provided for @sixMonths.
  ///
  /// In en, this message translates to:
  /// **'6 Months'**
  String get sixMonths;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @bestValueBilled.
  ///
  /// In en, this message translates to:
  /// **'Best value! Billed annually.'**
  String get bestValueBilled;

  /// No description provided for @greatSavingsBilled.
  ///
  /// In en, this message translates to:
  /// **'Great savings! Billed every 6 months.'**
  String get greatSavingsBilled;

  /// No description provided for @saveMoreBilled.
  ///
  /// In en, this message translates to:
  /// **'Save more! Billed every 3 months.'**
  String get saveMoreBilled;

  /// No description provided for @billedMonthly.
  ///
  /// In en, this message translates to:
  /// **'Billed monthly. Cancel anytime.'**
  String get billedMonthly;

  /// No description provided for @loadingFromStore.
  ///
  /// In en, this message translates to:
  /// **'Loading from store...'**
  String get loadingFromStore;

  /// No description provided for @monthlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Monthly Plan'**
  String get monthlyPlan;

  /// No description provided for @yearlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Yearly Plan'**
  String get yearlyPlan;

  /// No description provided for @oneMonth.
  ///
  /// In en, this message translates to:
  /// **'1 month'**
  String get oneMonth;

  /// No description provided for @threeMonthsDuration.
  ///
  /// In en, this message translates to:
  /// **'3 months'**
  String get threeMonthsDuration;

  /// No description provided for @sixMonthsDuration.
  ///
  /// In en, this message translates to:
  /// **'6 months'**
  String get sixMonthsDuration;

  /// No description provided for @oneYear.
  ///
  /// In en, this message translates to:
  /// **'1 year'**
  String get oneYear;

  /// No description provided for @savePct.
  ///
  /// In en, this message translates to:
  /// **'Save {pct}'**
  String savePct(String pct);

  /// No description provided for @paymentSecured.
  ///
  /// In en, this message translates to:
  /// **'Payment secured by Google Play / App Store'**
  String get paymentSecured;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing...'**
  String get processing;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @subscriptionNowActive.
  ///
  /// In en, this message translates to:
  /// **'Your {planType} subscription is now active!'**
  String subscriptionNowActive(String planType);

  /// No description provided for @purchasesRestored.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored'**
  String get purchasesRestored;

  /// No description provided for @subscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe {price}'**
  String subscribe(String price);

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days} days remaining'**
  String daysRemaining(int days);

  /// No description provided for @subscriptionExpired.
  ///
  /// In en, this message translates to:
  /// **'Subscription expired'**
  String get subscriptionExpired;

  /// No description provided for @customizeApp.
  ///
  /// In en, this message translates to:
  /// **'Customize App'**
  String get customizeApp;

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'App Name'**
  String get appName;

  /// No description provided for @enterAppName.
  ///
  /// In en, this message translates to:
  /// **'Enter app name'**
  String get enterAppName;

  /// No description provided for @appColor.
  ///
  /// In en, this message translates to:
  /// **'App Color'**
  String get appColor;

  /// No description provided for @appLogo.
  ///
  /// In en, this message translates to:
  /// **'App Logo'**
  String get appLogo;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @brandingSaved.
  ///
  /// In en, this message translates to:
  /// **'Branding saved! Restart app to see full changes.'**
  String get brandingSaved;

  /// No description provided for @resetToDefaultBranding.
  ///
  /// In en, this message translates to:
  /// **'Reset to default branding.'**
  String get resetToDefaultBranding;

  /// No description provided for @chooseLogoImage.
  ///
  /// In en, this message translates to:
  /// **'Choose Logo Image'**
  String get chooseLogoImage;

  /// No description provided for @takePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get takePhoto;

  /// No description provided for @useCamera.
  ///
  /// In en, this message translates to:
  /// **'Use camera to take a new photo'**
  String get useCamera;

  /// No description provided for @photoGallery.
  ///
  /// In en, this message translates to:
  /// **'Photo Gallery'**
  String get photoGallery;

  /// No description provided for @chooseFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Choose from photo library'**
  String get chooseFromLibrary;

  /// No description provided for @browseFiles.
  ///
  /// In en, this message translates to:
  /// **'Browse Files'**
  String get browseFiles;

  /// No description provided for @chooseFromFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose from device files'**
  String get chooseFromFiles;

  /// No description provided for @chooseLogo.
  ///
  /// In en, this message translates to:
  /// **'Choose Logo'**
  String get chooseLogo;

  /// No description provided for @removeCustomLogo.
  ///
  /// In en, this message translates to:
  /// **'Remove Custom Logo'**
  String get removeCustomLogo;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection.\nPlease check your network.'**
  String get noInternet;

  /// No description provided for @failedToLoadPage.
  ///
  /// In en, this message translates to:
  /// **'Failed to load page.'**
  String get failedToLoadPage;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @chooseDifferentUrl.
  ///
  /// In en, this message translates to:
  /// **'Choose Different URL'**
  String get chooseDifferentUrl;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @exitConfirm.
  ///
  /// In en, this message translates to:
  /// **'Do you want to go back to URL selection?'**
  String get exitConfirm;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @thai.
  ///
  /// In en, this message translates to:
  /// **'ไทย'**
  String get thai;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @failedToRegister.
  ///
  /// In en, this message translates to:
  /// **'Failed to register'**
  String get failedToRegister;

  /// No description provided for @membershipExpired.
  ///
  /// In en, this message translates to:
  /// **'Membership Expired'**
  String get membershipExpired;

  /// No description provided for @membershipExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your membership has expired.\nPlease renew your package to continue using the app.'**
  String get membershipExpiredMessage;

  /// No description provided for @renewPackage.
  ///
  /// In en, this message translates to:
  /// **'Renew Package'**
  String get renewPackage;

  /// No description provided for @testCode.
  ///
  /// In en, this message translates to:
  /// **'Test Code'**
  String get testCode;

  /// No description provided for @enterTestCode.
  ///
  /// In en, this message translates to:
  /// **'Enter test code'**
  String get enterTestCode;

  /// No description provided for @activateCode.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get activateCode;

  /// No description provided for @invalidTestCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired test code'**
  String get invalidTestCode;

  /// No description provided for @testCodeActivated.
  ///
  /// In en, this message translates to:
  /// **'Test code activated! Your subscription is now active.'**
  String get testCodeActivated;

  /// No description provided for @haveTestCode.
  ///
  /// In en, this message translates to:
  /// **'Have a test code?'**
  String get haveTestCode;

  /// No description provided for @activating.
  ///
  /// In en, this message translates to:
  /// **'Activating...'**
  String get activating;

  /// No description provided for @verificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase verification failed. Please try again.'**
  String get verificationFailed;

  /// No description provided for @tooManyOtpRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many OTP requests. Please wait a few minutes.'**
  String get tooManyOtpRequests;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. OTP sent for login.'**
  String get emailAlreadyRegistered;

  /// No description provided for @proPlans.
  ///
  /// In en, this message translates to:
  /// **'Pro Plans'**
  String get proPlans;

  /// No description provided for @proMonthly.
  ///
  /// In en, this message translates to:
  /// **'Pro Monthly'**
  String get proMonthly;

  /// No description provided for @proYearly.
  ///
  /// In en, this message translates to:
  /// **'Pro Yearly'**
  String get proYearly;

  /// No description provided for @proDescription.
  ///
  /// In en, this message translates to:
  /// **'Use on up to {count} devices with 1 account'**
  String proDescription(int count);

  /// No description provided for @proBadge.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get proBadge;

  /// No description provided for @upToDevices.
  ///
  /// In en, this message translates to:
  /// **'Up to {count} devices'**
  String upToDevices(int count);

  /// No description provided for @standardPlan.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get standardPlan;

  /// No description provided for @oneDevice.
  ///
  /// In en, this message translates to:
  /// **'1 device'**
  String get oneDevice;

  /// No description provided for @deviceLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Device limit reached'**
  String get deviceLimitReached;

  /// No description provided for @deviceLimitMessage.
  ///
  /// In en, this message translates to:
  /// **'Your plan allows maximum {count} device(s). Please upgrade to Pro to use up to 5 devices.'**
  String deviceLimitMessage(int count);

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToPro;

  /// No description provided for @proMonthlyBilled.
  ///
  /// In en, this message translates to:
  /// **'Pro plan billed monthly. Up to 5 devices.'**
  String get proMonthlyBilled;

  /// No description provided for @proYearlyBilled.
  ///
  /// In en, this message translates to:
  /// **'Best Pro value! Billed annually. Up to 5 devices.'**
  String get proYearlyBilled;

  /// No description provided for @deleteHistory.
  ///
  /// In en, this message translates to:
  /// **'Delete History'**
  String get deleteHistory;

  /// No description provided for @deleteHistoryConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this URL from history?'**
  String get deleteHistoryConfirm;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
