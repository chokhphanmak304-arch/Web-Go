// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get welcome => 'ยินดีต้อนรับ';

  @override
  String get enterEmailToSignIn => 'กรอกอีเมลเพื่อเข้าสู่ระบบ';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get pleaseEnterEmail => 'กรุณากรอกอีเมล';

  @override
  String get invalidEmailFormat => 'รูปแบบอีเมลไม่ถูกต้อง';

  @override
  String get sendOtp => 'ส่ง OTP';

  @override
  String get otpInfoMessage =>
      'เราจะส่งรหัส OTP 6 หลักไปยังอีเมลของคุณ\n🎁 ทดลองใช้ฟรี 15 วัน!';

  @override
  String get demoMode => 'โหมดทดลอง';

  @override
  String get emailNotConfigured => 'ยังไม่ได้ตั้งค่าอีเมล\nรหัส OTP ของคุณคือ:';

  @override
  String get continueBtn => 'ดำเนินการต่อ';

  @override
  String get accessWebApps => 'เข้าถึงเว็บแอปของคุณได้ทุกที่';

  @override
  String get connectToWebsite => 'เชื่อมต่อเว็บไซต์';

  @override
  String get enterUrlToStart => 'กรอก URL เพื่อเริ่มต้น';

  @override
  String get urlHint => 'เช่น example.com';

  @override
  String get pleaseEnterUrl => 'กรุณากรอก URL';

  @override
  String get connect => 'เชื่อมต่อ';

  @override
  String get recent => 'ล่าสุด';

  @override
  String get subscriptionRequired => 'ต้องสมัครสมาชิก';

  @override
  String get subscriptionExpiredMessage =>
      'การสมัครสมาชิกของคุณหมดอายุแล้ว กรุณาสมัครสมาชิกเพื่อใช้งานแอปต่อ';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get viewPlans => 'ดูแผน';

  @override
  String get signOut => 'ออกจากระบบ';

  @override
  String get signOutConfirm => 'คุณต้องการออกจากระบบหรือไม่?';

  @override
  String account(String email) {
    return 'บัญชี: $email';
  }

  @override
  String get customize => 'ปรับแต่ง';

  @override
  String get subscription => 'สมัครสมาชิก';

  @override
  String get verifyOtp => 'ยืนยัน OTP';

  @override
  String get enterOtpSentTo => 'กรอกรหัส 6 หลักที่ส่งไปยัง';

  @override
  String get pleaseEnterAllDigits => 'กรุณากรอกให้ครบ 6 หลัก';

  @override
  String get invalidOtpCode => 'รหัส OTP ไม่ถูกต้อง';

  @override
  String get verify => 'ยืนยัน';

  @override
  String get didntReceiveCode => 'ไม่ได้รับรหัส?';

  @override
  String get resend => 'ส่งอีกครั้ง';

  @override
  String resendCountdown(int seconds) {
    return '$seconds วิ';
  }

  @override
  String get newOtpSent => 'ส่ง OTP ใหม่ไปยังอีเมลของคุณแล้ว!';

  @override
  String get failedToResendOtp => 'ส่ง OTP อีกครั้งไม่สำเร็จ';

  @override
  String get yourNewOtpCode => 'รหัส OTP ใหม่ของคุณคือ:';

  @override
  String get ok => 'ตกลง';

  @override
  String get subscriptionPlans => 'แผนสมัครสมาชิก';

  @override
  String get restore => 'กู้คืน';

  @override
  String get securePayment => 'ชำระเงินอย่างปลอดภัยผ่าน App Store / Play Store';

  @override
  String get whatYouGet => 'สิ่งที่คุณจะได้รับ';

  @override
  String get compareFreeVsPremium => 'เปรียบเทียบฟีเจอร์ฟรี vs พรีเมียม';

  @override
  String get freeTrial => 'ฟรี (ทดลอง)';

  @override
  String get access1Url => 'เข้าถึง 1 URL';

  @override
  String get basicWebview => 'WebView พื้นฐาน';

  @override
  String get customBrandingDisabled => 'ตั้งชื่อแอป / โลโก้ / สี';

  @override
  String get multipleUrlsDisabled => 'หลาย URL';

  @override
  String get premiumSubscriber => 'พรีเมียม (สมาชิก)';

  @override
  String get unlimitedUrlAccess => 'เข้าถึง URL ไม่จำกัด';

  @override
  String get fullWebviewFeatures => 'ฟีเจอร์ WebView เต็มรูปแบบ';

  @override
  String get customAppName => 'ตั้งชื่อแอปเอง (แบรนดิ้ง)';

  @override
  String get customAppLogo => 'โลโก้แอปเอง';

  @override
  String get customAppColorTheme => 'ธีมสีแอปเอง';

  @override
  String get pickFromCameraGallery => 'เลือกจากกล้อง / แกลเลอรี / ไฟล์';

  @override
  String get adFreeExperience => 'ไม่มีโฆษณา';

  @override
  String get earlyAccessNewFeatures => 'เข้าถึงฟีเจอร์ใหม่ก่อนใคร';

  @override
  String get currentPlan => 'แผนปัจจุบัน';

  @override
  String get active => 'ใช้งานอยู่';

  @override
  String get expired => 'หมดอายุ';

  @override
  String get freeTrialPlan => 'ทดลองใช้ฟรี';

  @override
  String get monthly => 'รายเดือน';

  @override
  String get threeMonths => '3 เดือน';

  @override
  String get sixMonths => '6 เดือน';

  @override
  String get yearly => 'รายปี';

  @override
  String get bestValueBilled => 'คุ้มค่าที่สุด! เรียกเก็บรายปี';

  @override
  String get greatSavingsBilled => 'ประหยัดมาก! เรียกเก็บทุก 6 เดือน';

  @override
  String get saveMoreBilled => 'ประหยัดขึ้น! เรียกเก็บทุก 3 เดือน';

  @override
  String get billedMonthly => 'เรียกเก็บรายเดือน ยกเลิกได้ตลอด';

  @override
  String get loadingFromStore => 'กำลังโหลดจากสโตร์...';

  @override
  String get monthlyPlan => 'แผนรายเดือน';

  @override
  String get yearlyPlan => 'แผนรายปี';

  @override
  String get oneMonth => '1 เดือน';

  @override
  String get threeMonthsDuration => '3 เดือน';

  @override
  String get sixMonthsDuration => '6 เดือน';

  @override
  String get oneYear => '1 ปี';

  @override
  String savePct(String pct) {
    return 'ประหยัด $pct';
  }

  @override
  String get paymentSecured => 'การชำระเงินปลอดภัยโดย Google Play / App Store';

  @override
  String get processing => 'กำลังดำเนินการ...';

  @override
  String get success => 'สำเร็จ!';

  @override
  String subscriptionNowActive(String planType) {
    return 'การสมัคร$planTypeของคุณเปิดใช้งานแล้ว!';
  }

  @override
  String get purchasesRestored => 'กู้คืนการซื้อแล้ว';

  @override
  String subscribe(String price) {
    return 'สมัครสมาชิก $price';
  }

  @override
  String daysRemaining(int days) {
    return 'เหลืออีก $days วัน';
  }

  @override
  String get subscriptionExpired => 'การสมัครสมาชิกหมดอายุ';

  @override
  String get customizeApp => 'ปรับแต่งแอป';

  @override
  String get appName => 'ชื่อแอป';

  @override
  String get enterAppName => 'กรอกชื่อแอป';

  @override
  String get appColor => 'สีแอป';

  @override
  String get appLogo => 'โลโก้แอป';

  @override
  String get saveChanges => 'บันทึก';

  @override
  String get resetToDefault => 'รีเซ็ตเป็นค่าเริ่มต้น';

  @override
  String get brandingSaved =>
      'บันทึกแบรนดิ้งแล้ว! รีสตาร์ทแอปเพื่อดูการเปลี่ยนแปลง';

  @override
  String get resetToDefaultBranding => 'รีเซ็ตเป็นแบรนดิ้งเริ่มต้นแล้ว';

  @override
  String get chooseLogoImage => 'เลือกรูปโลโก้';

  @override
  String get takePhoto => 'ถ่ายรูป';

  @override
  String get useCamera => 'ใช้กล้องถ่ายรูปใหม่';

  @override
  String get photoGallery => 'แกลเลอรี';

  @override
  String get chooseFromLibrary => 'เลือกจากคลังรูปภาพ';

  @override
  String get browseFiles => 'เรียกดูไฟล์';

  @override
  String get chooseFromFiles => 'เลือกจากไฟล์ในเครื่อง';

  @override
  String get chooseLogo => 'เลือกโลโก้';

  @override
  String get removeCustomLogo => 'ลบโลโก้ที่กำหนดเอง';

  @override
  String get preview => 'ตัวอย่าง';

  @override
  String get noInternet =>
      'ไม่มีการเชื่อมต่ออินเทอร์เน็ต\nกรุณาตรวจสอบเครือข่าย';

  @override
  String get failedToLoadPage => 'โหลดหน้าเว็บไม่สำเร็จ';

  @override
  String get tryAgain => 'ลองอีกครั้ง';

  @override
  String get chooseDifferentUrl => 'เลือก URL อื่น';

  @override
  String get exit => 'ออก';

  @override
  String get exitConfirm => 'คุณต้องการกลับไปเลือก URL หรือไม่?';

  @override
  String get confirm => 'ยืนยัน';

  @override
  String get refresh => 'รีเฟรช';

  @override
  String get language => 'ภาษา';

  @override
  String get english => 'English';

  @override
  String get thai => 'ไทย';

  @override
  String get changeLanguage => 'เปลี่ยนภาษา';

  @override
  String get failedToRegister => 'ลงทะเบียนไม่สำเร็จ';

  @override
  String get membershipExpired => 'สมาชิกหมดอายุ';

  @override
  String get membershipExpiredMessage =>
      'การเป็นสมาชิกของคุณหมดอายุแล้ว\nกรุณาต่อแพ็กเกจเพื่อใช้งานแอปต่อ';

  @override
  String get renewPackage => 'ต่อแพ็กเกจ';

  @override
  String get testCode => 'รหัสทดสอบ';

  @override
  String get enterTestCode => 'กรอกรหัสทดสอบ';

  @override
  String get activateCode => 'เปิดใช้งาน';

  @override
  String get invalidTestCode => 'รหัสทดสอบไม่ถูกต้องหรือหมดอายุ';

  @override
  String get testCodeActivated =>
      'เปิดใช้รหัสทดสอบสำเร็จ! สมาชิกของคุณเปิดใช้งานแล้ว';

  @override
  String get haveTestCode => 'มีรหัสทดสอบ?';

  @override
  String get activating => 'กำลังเปิดใช้งาน...';

  @override
  String get verificationFailed => 'ตรวจสอบการซื้อไม่สำเร็จ กรุณาลองใหม่';

  @override
  String get tooManyOtpRequests => 'ส่ง OTP บ่อยเกินไป กรุณารอสักครู่';

  @override
  String get emailAlreadyRegistered =>
      'อีเมลนี้ลงทะเบียนแล้ว ส่ง OTP เพื่อเข้าสู่ระบบ';

  @override
  String get proPlans => 'แผน Pro';

  @override
  String get proMonthly => 'Pro รายเดือน';

  @override
  String get proYearly => 'Pro รายปี';

  @override
  String proDescription(int count) {
    return 'ใช้งานได้สูงสุด $count เครื่องด้วย 1 บัญชี';
  }

  @override
  String get proBadge => 'PRO';

  @override
  String upToDevices(int count) {
    return 'สูงสุด $count เครื่อง';
  }

  @override
  String get standardPlan => 'มาตรฐาน';

  @override
  String get oneDevice => '1 เครื่อง';

  @override
  String get deviceLimitReached => 'ถึงจำนวนเครื่องสูงสุดแล้ว';

  @override
  String deviceLimitMessage(int count) {
    return 'แผนของคุณรองรับได้สูงสุด $count เครื่อง กรุณาอัปเกรดเป็น Pro เพื่อใช้งานได้ถึง 5 เครื่อง';
  }

  @override
  String get upgradeToPro => 'อัปเกรดเป็น Pro';

  @override
  String get proMonthlyBilled => 'แผน Pro รายเดือน ใช้ได้ถึง 5 เครื่อง';

  @override
  String get proYearlyBilled =>
      'Pro คุ้มค่าสุด! เรียกเก็บรายปี ใช้ได้ถึง 5 เครื่อง';

  @override
  String get deleteHistory => 'ลบประวัติ';

  @override
  String get deleteHistoryConfirm =>
      'คุณต้องการลบ URL นี้ออกจากประวัติหรือไม่?';

  @override
  String get delete => 'ลบ';
}
