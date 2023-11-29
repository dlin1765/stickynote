import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:myapp/classes/note.dart';
import 'package:myapp/classes/reminder.dart';
import 'package:myapp/classes/noteData.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/util/ReminderBox.dart';
import 'package:myapp/util/reminderwidget.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ReminderView extends StatefulWidget {
  final Note note;
  final NoteData noteData;

  ReminderView({
    super.key,
    required this.note,
    required this.noteData,
  });

  @override
  State<ReminderView> createState() => ReminderViewState();
}

class ReminderViewState extends State<ReminderView> {
  final _controller = TextEditingController();
  // add functionality to make the check box clickable
  void ClickedCheckBox(bool value, int index) {
    setState(() {
      var reminderTemp = widget.note.reminderList[index];
      reminderTemp.isDone = !reminderTemp.isDone;
    });
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return ReminderBox(
          controller: _controller,
          saveReminder: saveReminder,
          cancelReminder: cancelReminder,
        );
      },
    );
  }

  void saveReminder() {
    setState(() {
      widget.note.reminderList.add(Reminder(
          id: widget.note.reminderList.length,
          text: _controller.text,
          isDone: false,
          reminderTime: widget.note.reminderTime,
          destroyTime: DateTime(2020)));
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void cancelReminder() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        title: Text("Reminders"),
        backgroundColor: Colors.yellow[300],
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          /*
          widget.note.reminderList.add(Reminder(
              id: widget.note.reminderList.length,
              text: '',
              reminderTime: widget.note.reminderTime,
              destroyTime: DateTime(2020)));
          */
          createNewTask();
          // Provider.of<NoteData>(context));
        },
        child: Icon(Icons.add),
        focusColor: Colors.blueGrey[300],
      ),
      body: ListView.builder(
          itemCount: widget.note.reminderList.length,
          itemBuilder: (context, index) {
            return ReminderWidget(
              WidgetReminder: widget.note.reminderList[index],
              OnChanged: (value) => ClickedCheckBox(value!, index),
            );
          }
          /*
        children: [
          ReminderWidget( 
              WidgetReminder: Reminder(
                  id: 0,
                  text: "aye",
                  isDone: false,
                  reminderTime: DateTime(2020),
                  destroyTime: DateTime(2020)),
              OnChanged: (p0) {}),
        ],
        */
          ),
    );
  }
}
