import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'VerifyCodePage.dart';

class ForgotPasswordPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();

  // جلب القيم من ملف .env
  final String? username = dotenv.env['EMAIL_USERNAME'];
  final String? password = dotenv.env['EMAIL_PASSWORD'];

  ForgotPasswordPage({super.key}) {
    // التحقق من القيم عند التهيئة
    if (username == null || password == null) {
      print("Error: EMAIL_USERNAME or EMAIL_PASSWORD is missing in the .env file.");
      throw Exception("Environment variables EMAIL_USERNAME or EMAIL_PASSWORD are missing");
    }
  }

  // وظيفة لإرسال البريد الإلكتروني
  Future<void> sendVerificationEmail(String email, String code) async {
    final smtpServer = gmail(username!, password!);

    final message = Message()
      ..from = Address(username!, 'Your App Name')
      ..recipients.add(email)
      ..subject = 'Verification Code'
      ..text = 'Your verification code is: $code';

    try {
      await send(message, smtpServer);
      print('Email sent successfully');
    } catch (e) {
      print('Failed to send email: $e');
      if (e.toString().contains('SocketException')) {
        throw Exception("Network issue: Unable to connect to SMTP server.");
      }
      throw Exception("Failed to send email. Please try again.");
    }
  }

  // وظيفة لتوليد رمز تحقق
  String generateCode() {
    return (1000 + Random().nextInt(9000)).toString(); // رمز عشوائي من 4 أرقام
  }

  // التحقق من صحة البريد الإلكتروني
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50),
                Text(
                  "Forgot Password",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                Text(
                  "Enter your email address to receive a verification code",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'example@gmail.com',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15.0,
                      horizontal: 20.0,
                    ),
                  ),
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    if (email.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter your email")),
                      );
                      return;
                    }

                    if (!isValidEmail(email)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please enter a valid email address")),
                      );
                      return;
                    }

                    try {
                      String code = generateCode();
                      await sendVerificationEmail(email, code);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VerifyCodePage(
                            code: code,
                            email: email,
                          ),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    }
                  },
                  child: Text(
                    "Confirm",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
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
