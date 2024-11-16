import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class New_Password extends StatefulWidget {
  final String email; // استقبال البريد الإلكتروني المدخل في الصفحة الأولى

  New_Password({required this.email});

  @override
  _NewPasswordScreenState createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<New_Password> {
  bool obscurePassword = true, obscureConfirmPassword = true;
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // وظيفة لتحديث كلمة المرور في قاعدة البيانات
  Future<void> updatePassword(String email, String newPassword) async {
    try {
      // البحث عن المستند الذي يحتوي على البريد الإلكتروني المطلوب
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users') // اسم المجموعة
          .where('email', isEqualTo: email) // البحث عن البريد الإلكتروني
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // تحديث كلمة المرور
        await querySnapshot.docs.first.reference.update({'password': newPassword});

        // عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Password updated successfully!")),
        );

        // العودة إلى الصفحة الرئيسية
        Navigator.popUntil(context, (route) => route.isFirst);
      } else {
        // إذا لم يتم العثور على البريد الإلكتروني
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Email not found in the database")),
        );
      }
    } catch (e) {
      // عرض رسالة خطأ إذا حدثت مشكلة
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update password. Please try again.")),
      );
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget passwordField(String label, TextEditingController controller, bool obscure, Function toggle) => TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => toggle()),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(context).pop(),
                splashRadius: 24,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "New Password",
              style: TextStyle(fontSize: 40),
            ),
            SizedBox(height: 8),
            Text(
              "Your new password must be different\nfrom previously used passwords.",
              style: TextStyle(fontSize: 20, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            passwordField("Password", passwordController, obscurePassword, () => obscurePassword = !obscurePassword),
            SizedBox(height: 16),
            passwordField("Confirm Password", confirmPasswordController, obscureConfirmPassword, () => obscureConfirmPassword = !obscureConfirmPassword),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;

                  if (password.isEmpty || confirmPassword.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please fill in all fields")),
                    );
                    return;
                  }

                  if (password != confirmPassword) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Passwords do not match")),
                    );
                    return;
                  }

                  // تحديث كلمة المرور
                  updatePassword(widget.email, password);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Create New Password", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
