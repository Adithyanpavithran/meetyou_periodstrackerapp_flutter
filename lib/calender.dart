import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  final String username;
  final String email;

  const CalendarPage({super.key, required this.username, required this.email});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime? selectedDate;

  void savePeriodDate(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection("USERDETAILS")
        .doc(user?.uid)
        .update({"LastPeriodDate": date.toIso8601String()});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Period date saved successfully"),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Period Tracker"),
        backgroundColor: Color(0xFFFF9A9E),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: selectedDate ?? DateTime.now(),
            selectedDayPredicate: (day) {
              return isSameDay(selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                selectedDate = selectedDay;
              });
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: selectedDate == null
                ? null
                : () {
                    savePeriodDate(selectedDate!);
                  },
            child: Text("Save Period Date"),
          ),
        ],
      ),
    );
  }
}
