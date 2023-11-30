import 'package:flutter/material.dart';
import 'package:myapp/classes/reminder.dart';

class AllRemindersPage extends StatefulWidget {
  final List<Reminder> reminders;

  AllRemindersPage({Key? key, required this.reminders}) : super(key: key);

  @override
  _AllRemindersPageState createState() => _AllRemindersPageState();
}

class _AllRemindersPageState extends State<AllRemindersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Reminders'),
      ),
      body: ListView.builder(
        itemCount: widget.reminders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(widget.reminders[index].title),
          );
        },
      ),
    );
  }
}
