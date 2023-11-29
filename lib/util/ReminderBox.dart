import 'package:flutter/material.dart';

class ReminderBox extends StatelessWidget {
  final controller;
  VoidCallback saveReminder;
  VoidCallback cancelReminder;
  ReminderBox({
    super.key,
    required this.controller,
    required this.saveReminder,
    required this.cancelReminder,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[400],
      content: Container(
        height: 240,
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Tap to add reminder",
              ),
            ),
            Row(
              children: [
                MaterialButton(
                  onPressed: saveReminder,
                  child: Text("save "),
                ),
                MaterialButton(
                  onPressed: cancelReminder,
                  child: Text("cancel"),
                ),

                // need more buttons to implement the changing reminders
              ],
            )
          ],
        ),
      ),
    );
  }
}
