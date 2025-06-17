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
  List<DateTime> savedDates = [];

  @override
  void initState() {
    super.initState();
    loadSavedDates();
  }

  // Load saved dates from Firestore
  void loadSavedDates() async {
    User? user = FirebaseAuth.instance.currentUser;
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection("USERDETAILS")
        .doc(user?.uid)
        .get();

    if (snapshot.exists && snapshot.data() != null) {
      List<dynamic>? dateList = snapshot.get("PeriodDates");
      if (dateList != null) {
        setState(() {
          savedDates = dateList.map((e) => DateTime.parse(e)).toList();
        });
      }
    }
  }

  // Save new period date
  void savePeriodDate(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (!savedDates.contains(date)) {
      savedDates.add(date);
    }

    await FirebaseFirestore.instance
        .collection("USERDETAILS")
        .doc(user?.uid)
        .set({
          "PeriodDates": savedDates.map((e) => e.toIso8601String()).toList(),
        }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Period date saved successfully"),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {});
  }

  // Delete a saved date
  void deletePeriodDate(DateTime date) async {
    User? user = FirebaseAuth.instance.currentUser;
    savedDates.remove(date);

    await FirebaseFirestore.instance
        .collection("USERDETAILS")
        .doc(user?.uid)
        .set({
          "PeriodDates": savedDates.map((e) => e.toIso8601String()).toList(),
        }, SetOptions(merge: true));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Period date removed"),
        backgroundColor: Colors.red,
      ),
    );

    setState(() {});
  }

  // Predict next period (simple 28-day cycle)
  DateTime? getNextPeriodDate() {
    if (savedDates.isEmpty) return null;
    savedDates.sort();
    return savedDates.last.add(Duration(days: 28));
  }

  @override
  Widget build(BuildContext context) {
    DateTime? nextPeriod = getNextPeriodDate();

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
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (savedDates.any((d) => isSameDay(d, day))) {
                  return Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                if (nextPeriod != null && isSameDay(nextPeriod, day)) {
                  return Container(
                    margin: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${day.day}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
                return null;
              },
            ),
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
                : () => savePeriodDate(selectedDate!),
            child: Text("Save Period Date"),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: selectedDate == null
                ? null
                : () => deletePeriodDate(selectedDate!),
            child: Text("Remove This Date"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),

          if (nextPeriod != null) ...[
            SizedBox(height: 20),
            Text(
              "Predicted Next Period: ${nextPeriod.day}/${nextPeriod.month}/${nextPeriod.year}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
