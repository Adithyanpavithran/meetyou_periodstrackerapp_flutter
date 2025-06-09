import 'package:flutter/material.dart';
import 'package:loginpage/Loginpage.dart';
import 'package:loginpage/Signuppage.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 7), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/spl.jpeg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 200), // Push from top
            Center(child: Image.asset("assets/logo.png", width: 200)),
            const SizedBox(height: 50),
            Center(
              child: Lottie.asset("assets/pp.json", width: 250, height: 250),
            ),
            const Spacer(), // Pushes the text to the bottom
            const Stack(
              alignment: Alignment.center,
              children: [
                // Text outline (stroke)
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
