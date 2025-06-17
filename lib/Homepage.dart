import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loginpage/Forgot.dart';
import 'package:loginpage/Loginpage.dart';
import 'package:loginpage/calender.dart';
import 'package:loginpage/chatbot.dart';
import 'package:loginpage/updateprofile.dart';

class Homepage extends StatefulWidget {
  final String email;
  final String username;
  const Homepage({super.key, required this.username, required this.email});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFF9A9E),
                Color(0xFFFAD0C4),
              ], // Customize your colors
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: SizedBox(
          width: 150,
          height: 150,
          child: Image.asset("assets/logo.png"),
        ),

        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF9A9E), Color(0xFFFAD0C4)],
                ),
              ),
              accountName: Text(
                widget.username,
                style: GoogleFonts.poppins(color: Colors.white, fontSize: 25),
              ),
              accountEmail: Text(
                widget.email,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),

              currentAccountPicture: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage("assets/p.jpeg"),
                ),
              ),
            ),

            ListTile(
              title: Text("Account"),
              leading: Icon(Icons.account_box),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileUpdatePage(
                      currentName: widget.username,
                      currentEmail: widget.email,
                    ),
                  ),
                );
              },
            ),
            ListTile(
  title: Text("Calendar"),
  leading: Icon(Icons.calendar_month),
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalendarPage(
          username: widget.username,
          email: widget.email,
        ),
      ),
    );
  },
),
            ListTile(title: Text("Your Cart"), leading: Icon(Icons.trolley)),
            ListTile(title: Text("Orders"), leading: Icon(Icons.done)),
            ListTile(title: Text("Settings"), leading: Icon(Icons.settings)),
            ListTile(
              title: Text("Logout"),
              leading: Icon(Icons.logout),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Chatbot()),
          );
        },
        backgroundColor: Color(0xFFFF9A9E),
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(20),
        ),
        child: Icon(Icons.smart_toy),
      ),
    );
  }
}
