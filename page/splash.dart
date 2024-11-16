import 'package:flutter/material.dart';
import 'dart:async';
import 'package:renting/page/welcome.dart'; // استبدل your_app_name باسم التطبيق الخاص بك

class splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // الانتقال إلى WelcomeScreen بعد 3 ثوانٍ
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => welcome()),
      );
    });

    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'OK AUTO',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
