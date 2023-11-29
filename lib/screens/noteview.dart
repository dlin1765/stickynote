import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:myapp/classes/note.dart';
import 'package:myapp/classes/noteData.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NoteView extends StatefulWidget {
  final Note note;
  final bool isNewNote;
  final NoteData noteData;

  NoteView({
    super.key,
    required this.note,
    required this.isNewNote,
    required this.noteData,
  });

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  late TextEditingController _titleController;
  late TextEditingController _textController;
  QuillController quillController = QuillController.basic();
  late TimeOfDay selectedTime;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _textController = TextEditingController(text: widget.note.text);

    tz.initializeTimeZones(); // Initialize the tz library

    if (widget.note.reminderTime != null) {
      selectedTime = TimeOfDay.fromDateTime(widget.note.reminderTime);
      selectedDate = widget.note.reminderTime;
    } else {
      selectedTime = TimeOfDay.now();
      selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Edit Note"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              widget.note.title = _titleController.text;
              widget.note.text = _textController.text;

              final selectedDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );

              widget.note.reminderTime = selectedDateTime;

              if (widget.isNewNote) {
                widget.noteData.CreateNewNote(widget.note);
              } else {
                widget.noteData.updateNote(
                  widget.note.id,
                  widget.note.text,
                  widget.note.reminderTime,
                );
              }

              _scheduleNotification(widget.note.reminderTime);

              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Container(
          padding: EdgeInsets.all(28),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'Enter title'),
              ),
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(hintText: 'Enter note text'),
                  maxLines: null,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text(
                  'Set Reminder Date',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(
                'Reminder Date: ${selectedDate.toLocal()}',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text(
                  'Set Reminder Time',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(
                'Reminder Time: ${selectedTime.format(context)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scheduleNotification(DateTime notificationTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'my_channel_id',
      'my_reminder',
      channelDescription: 'Receive reminders from noteapp',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'app_icon',
    );

    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'Your notification message here',
      tz.TZDateTime.from(notificationTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
