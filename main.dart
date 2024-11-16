import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; // استيراد مكتبة dotenv
import 'package:renting/page/splash.dart'; // تعديل المسار حسب تطبيقك

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // تهيئة الويدجت

  // تحميل ملف .env
  try {
    await dotenv.load(fileName: ".env"); // تأكد من أن الملف موجود في الجذر
    print("Environment variables loaded successfully.");
  } catch (e) {
    print("Failed to load environment variables: $e");
    // يمكنك إظهار رسالة خطأ أو التعامل مع الخطأ
  }

  // تهيئة Firebase
  try {
    await Firebase.initializeApp();
    print("Firebase initialized successfully.");
  } catch (e) {
    print("Failed to initialize Firebase: $e");
    // يمكنك إظهار رسالة خطأ أو التعامل مع الخطأ
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: splash(), // الصفحة الرئيسية
    );
  }
}
