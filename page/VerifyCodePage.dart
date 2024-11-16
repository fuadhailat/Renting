import 'package:flutter/material.dart';
import 'New_Password.dart';

class VerifyCodePage extends StatelessWidget {
  final String code; // استقبال الكود المُرسل من الصفحة السابقة
  final String email; // استقبال البريد الإلكتروني المدخل في الصفحة الأولى

  VerifyCodePage({required this.code, required this.email}); // استدعاء المُنشئ لاستقبال الكود والبريد الإلكتروني

  @override
  Widget build(BuildContext context) {
    List<TextEditingController> controllers = List.generate(4, (_) => TextEditingController());

    Widget inputBox(int index) => Container(
      height: 56,
      width: 56,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controllers[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1, // إدخال رقم واحد فقط في كل خانة
        decoration: InputDecoration(
          border: InputBorder.none,
          counterText: "", // إخفاء العداد
        ),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).nextFocus(); // الانتقال للخانة التالية تلقائيًا
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus(); // العودة للخانة السابقة إذا كانت فارغة
          }
        },
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
          padding: EdgeInsets.zero,
          constraints: BoxConstraints(),
          iconSize: 24,
          splashRadius: 24,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text("Verify Code", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Please enter the code we just sent to email",
              style: TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Text(
              email, // عرض البريد الإلكتروني المُرسل
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) => inputBox(index))
                  .expand((widget) => [widget, SizedBox(width: 15)])
                  .toList()
                ..removeLast(),
            ),
            SizedBox(height: 16),
            Text("Didn't receive OTP?", style: TextStyle(fontSize: 14, color: Colors.grey)),
            GestureDetector(
              onTap: () {}, // أضف منطق إعادة الإرسال هنا
              child: Text("Resend code", style: TextStyle(fontSize: 14, color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // تجميع القيم المدخلة في الخانات
                  String enteredCode = controllers.map((controller) => controller.text).join();
                  if (enteredCode == code) {
                    // الانتقال إلى صفحة كلمة المرور الجديدة إذا تطابق الكود
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => New_Password(email: email)),
                    );
                  } else {
                    // عرض رسالة خطأ إذا لم يتطابق الكود
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Incorrect code. Please try again.")),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Verify", style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
