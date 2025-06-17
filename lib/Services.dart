import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loginpage/Homepage.dart';

// Register Function
Future<String?> Register({
  required String Username,
  required String Email,
  required String password,
  required BuildContext context,
}) async {
  try {
    UserCredential userd = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: Email, password: password);
    User? user = userd.user;

    // Save Name and Email in Firestore
    await FirebaseFirestore.instance.collection("USERDETAILS").doc(user?.uid).set({
      "Name": Username,
      "Email": Email,
    });

    return "Success"; // ✅ Return success
  } catch (e) {
    return e.toString(); // ✅ Return error
  }
}

// Login Function
Future<void> login({
  required String email,
  required String password,
  required BuildContext context,
}) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    User? user = userCredential.user;

    // Fetch data from Firestore after successful login
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection("USERDETAILS").doc(user?.uid).get();

    String username = userDoc.data()?['Name'] ?? "Unknown";
    String useremail = userDoc.data()?['Email'] ?? "Unknown";

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logged in successfully"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Homepage(username: username, email: useremail),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}


// Forget Password Function
Future<void> forget({
  required String email,
  required BuildContext context,
}) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Check your Email")),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(e.toString())),
    );
  }
}
