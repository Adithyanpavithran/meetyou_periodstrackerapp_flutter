import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/Homepage.dart';

Future<void> Register({
  required String Username,
  required String Email,
  required String password,
  required BuildContext context,
}) async {
  try {
    UserCredential userd = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: Email, password: password);
    User? user = userd.user;
    await FirebaseFirestore.instance
        .collection("USERDETAILS")
        .doc(user?.uid)
        .set({"Name": Username, "Email": Email});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("User creation successful"),
        backgroundColor: Colors.green, 
        behavior: SnackBarBehavior.floating, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: const Color.fromARGB(
          255,
          241,
          19,
          19,
        ), // ✅ Change color
        behavior: SnackBarBehavior.floating, // ✅ Floating above screen
        shape: RoundedRectangleBorder(
          // ✅ Rounded corners
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

Future<void> login({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logged in successful"),
        backgroundColor: Colors.green, // ✅ Change color
        behavior: SnackBarBehavior.floating, // ✅ Floating above screen
        shape: RoundedRectangleBorder(
          // ✅ Rounded corners
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Homepage()),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: const Color.fromARGB(
          255,
          241,
          19,
          19,
        ), // ✅ Change color
        behavior: SnackBarBehavior.floating, // ✅ Floating above screen
        shape: RoundedRectangleBorder(
          // ✅ Rounded corners
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
Future<void> forget({
  required String email,
  required BuildContext context,
}) async {
  {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Check your Email")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
}
