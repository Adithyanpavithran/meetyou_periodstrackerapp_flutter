import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  TextEditingController Messagecontroller = TextEditingController();

  bool isloading = false;
  bool cansent = false;
  List<Map<String, String>> messages = [];

  Future<void> sendMessage(String userMessage) async {
    setState(() {
      messages.add({'role': 'user', 'text': userMessage});
      isloading = true;
      cansent = false;
    });

    final uri = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=AIzaSyCGoUBbHWUsj1BMSnyDdszAtufjtDAYxzw',
    );

    final headers = {'Content-Type': 'application/json'};

    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {'text': userMessage},
          ],
        },
      ],
    });

    try {
      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final botReply = data['candidates'][0]['content']['parts'][0]['text'];

        setState(() {
          messages.add({'role': 'bot', 'text': botReply});
        });
      } else {
        setState(() {
          messages.add({
            'role': 'bot',
            'text': 'Something went wrong. Please try again later.',
          });
        });
      }
    } catch (e) {
      setState(() {
        messages.add({'role': 'bot', 'text': 'Error: $e'});
      });
    } finally {
      setState(() {
        isloading = false;
        Messagecontroller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 173, 175),
        foregroundColor: Colors.white,
        title: Text(
          "ChatBot",
          style: GoogleFonts.eagleLake(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          Icon(Icons.chat_bubble_outline),
          Padding(padding: EdgeInsetsGeometry.only(right: 20)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              reverse: true,
              itemBuilder: (context, Index) =>
                  message(messages.reversed.toList()[Index]),
              itemCount: messages.length,
            ),
          ),
          if (isloading)
            CircularProgressIndicator(
              color: const Color.fromARGB(255, 7, 7, 7),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: Messagecontroller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "How can i help you?",
                      filled: true,
                      fillColor: Color.fromARGB(255, 252, 181, 183),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: const Color.fromARGB(255, 4, 4, 4),
                          width: 5,
                        ),
                      ),
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    sendMessage(Messagecontroller.text.trim());
                  },
                  icon: Icon(Icons.send, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget message(Map<String, String> buildmessage) {
    bool user = buildmessage["role"] == "user";
    return Align(
      alignment: user ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        child: Text(
          buildmessage["text"] ?? '',
          style: TextStyle(
            color: user ? const Color.fromARGB(255, 1, 1, 1) : Colors.black,
            fontSize: 24,
          ),
        ),

        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: user ? Color(0xFFFAD0C4) : Color(0xFFFAD0C4),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}
