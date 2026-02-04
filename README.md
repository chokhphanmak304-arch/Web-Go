# Odoo WebView Application

แอปพลิเคชัน Flutter สำหรับเข้าถึง Odoo ผ่าน WebView พร้อมระบบยืนยันตัวตนด้วย Email OTP

## Features

✅ **ระบบสมาชิก**
- สมัครสมาชิก/เข้าสู่ระบบด้วย Email
- ยืนยันตัวตนด้วยรหัส OTP 6 หลัก
- ส่ง OTP ไปยัง Email (ใช้ EmailJS)
- Demo Mode สำหรับทดสอบ (ไม่ต้องตั้งค่า Email)

✅ **หน้า Splash Screen** - แสดง Logo พร้อม Animation
✅ **หน้ากรอก URL** - รองรับทุกขนาดหน้าจอ
✅ **บันทึกประวัติ URL** - จำ 5 รายการล่าสุด
✅ **WebView เต็มจอ** - พร้อม Loading Progress
✅ **ปุ่ม Logout** - ออกจากระบบและกลับหน้า Login
✅ **รองรับแนวตั้ง/แนวนอน**

### รองรับระบบปฏิบัติการ
- **Android**: API 21+ (Android 5.0+)
- **iOS**: 12.0+

## การตั้งค่า Email OTP (ไม่บังคับ)

แอปมี Demo Mode ที่สามารถใช้งานได้โดยไม่ต้องตั้งค่า Email

หากต้องการส่ง OTP ไปยัง Email จริง:

1. สมัครบัญชีที่ https://www.emailjs.com/ (ฟรี 200 emails/เดือน)
2. เพิ่ม Email Service (Gmail, Outlook, etc.)
3. สร้าง Email Template ด้วยเนื้อหา:

```
Subject: รหัส OTP สำหรับ Odoo App

สวัสดีคุณ {{to_email}}

รหัส OTP ของคุณคือ: {{otp_code}}

รหัสนี้จะหมดอายุใน 5 นาที

ขอบคุณที่ใช้งาน {{app_name}}
```

4. แก้ไขไฟล์ `lib/services/email_service.dart`:
```dart
static const String _serviceId = 'YOUR_SERVICE_ID';
static const String _templateId = 'YOUR_TEMPLATE_ID';
static const String _publicKey = 'YOUR_PUBLIC_KEY';
```

## วิธีติดตั้งและรัน

### ความต้องการ
- Flutter SDK 3.0.0 ขึ้นไป
- Android Studio หรือ VS Code
- Android SDK / Xcode (สำหรับ iOS)

### ขั้นตอน

1. เปิด Terminal และไปที่โฟลเดอร์โปรเจค:
```bash
cd C:\Users\theerapol\Desktop\odoo\odoo_app
```

2. ดึง dependencies:
```bash
flutter pub get
```

3. รันบน Emulator หรือเครื่องจริง:
```bash
flutter run
```

### Build APK (Android)
```bash
flutter build apk --release
```
ไฟล์ APK: `build/app/outputs/flutter-apk/app-release.apk`

### Build iOS
```bash
flutter build ios --release
```

## โครงสร้างโปรเจค

```
odoo_app/
├── lib/
│   ├── main.dart
│   ├── services/
│   │   ├── auth_service.dart      # จัดการ Authentication
│   │   └── email_service.dart     # ส่ง OTP Email
│   └── screens/
│       ├── splash_screen.dart     # หน้า Splash
│       ├── login_screen.dart      # หน้า Login/Register
│       ├── otp_verification_screen.dart  # หน้ายืนยัน OTP
│       ├── url_input_screen.dart  # หน้ากรอก URL
│       └── webview_screen.dart    # หน้า WebView
├── assets/
│   └── logo_odoo.png
└── pubspec.yaml
```


## Flow การใช้งาน

```
┌─────────────────┐
│  Splash Screen  │
│   (3 วินาที)     │
└────────┬────────┘
         │
         ▼
   ┌─────────────┐     ไม่ได้ Login
   │ ตรวจสอบ Login │─────────────────┐
   └─────────────┘                   │
         │ Login แล้ว                │
         ▼                           ▼
┌─────────────────┐        ┌─────────────────┐
│  URL Input Page │        │   Login Page    │
│  (กรอก URL)      │        │  (กรอก Email)   │
└────────┬────────┘        └────────┬────────┘
         │                          │
         │                          ▼
         │                 ┌─────────────────┐
         │                 │  OTP Verify     │
         │                 │ (กรอกรหัส 6 หลัก) │
         │                 └────────┬────────┘
         │                          │
         │◄─────────────────────────┘
         │
         ▼
┌─────────────────┐
│  WebView Page   │
│  (เปิด Odoo)     │
└─────────────────┘
```

## License

MIT License
