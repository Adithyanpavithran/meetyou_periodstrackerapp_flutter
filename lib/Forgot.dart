import 'package:flutter/material.dart';
import 'package:loginpage/Loginpage.dart';
import 'package:loginpage/Services.dart';

class Forgot extends StatefulWidget {
  const Forgot({super.key});

  @override
  State<Forgot> createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
   TextEditingController Emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min, // Centers content vertically
            children: [
              Image.asset("assets/lock.png", width: 100, height: 100),

              Text(
                "Forgot password?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              Text("No worries,we'll send you reset instrcutions."),
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: TextField(
                  
                  decoration: InputDecoration(
                    labelText: "Email ID",
                    hintText: "email",
                    filled: true,
                    fillColor: Colors.white,
                    
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
                                  ElevatedButton(
                      onPressed: () {
                        forget(email: Emailcontroller.text, context: context);
                      },
                      child: Text('Send Confirmation'),
                    ),

              SizedBox(height: 300),
              TextButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                icon: const Icon(Icons.arrow_back, size: 20),
                label: const Text("Back to login"),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.zero, // No padding between icon and text
                  tapTargetSize:
                      MaterialTapTargetSize.shrinkWrap, // Tighter layout
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
