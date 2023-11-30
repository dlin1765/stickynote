import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/classes/note.dart';
import 'package:myapp/classes/reminder.dart';
import 'package:myapp/classes/noteData.dart';
import 'package:myapp/util/ReminderBox.dart';
import 'package:myapp/util/reminderwidget.dart';
import 'package:provider/provider.dart';

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

/*
   @override
  void initState() {
    super.initState();
    if (widget.note.reminderTime != null) {
      selectedTime = TimeOfDay.fromDateTime(widget.note.reminderTime);
      selectedDate = widget.note.reminderTime;
    } else {
      selectedTime = TimeOfDay.now();
      selectedDate = DateTime.now();
    }
  }
*/

  void ClickedCheckBox(bool value, int index) {
    setState(() {
      var reminderTemp = widget.note.reminderList[index];
      if (!reminderTemp.isDone && reminderTemp.deleteOnCompletion) {
        //delete reminderTemp.isDone = !reminderTemp.isDone;
        deleteReminder(widget.note.reminderList[index]);
      }
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

  void _selectDate(BuildContext context, Reminder currentReminder) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null && pickedDate != currentReminder.reminderTime) {
      setState(() {
        currentReminder.reminderTime = pickedDate;
      });
    }
  }

  void _selectTime(BuildContext context, Reminder currentReminder) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null &&
        pickedTime != TimeOfDay.fromDateTime(currentReminder.reminderTime)) {
      setState(() {
        var tempReminder = currentReminder.reminderTime;
        DateTime temp = DateTime(tempReminder.year, tempReminder.month,
            tempReminder.day, pickedTime.hour, pickedTime.minute);
        currentReminder.reminderTime = temp;
      });
    }
  }

  void _toggleAutoDelete(BuildContext context, Reminder currentReminder) {
    currentReminder.deleteOnCompletion = !currentReminder.deleteOnCompletion;
  }

  void editReminder(Reminder reminder) {
    _controller.text = reminder.text; // Set the current text in the controller
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Reminder'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(hintText: "Edit reminder text"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  reminder.text = _controller.text; // Update the reminder text
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              onPressed: () {},
              child: Text('Adjust time'),
            ),
          ],
        );
      },
    );
  }

  void deleteReminder(Reminder reminder) {
    setState(() {
      widget.note.reminderList.remove(reminder);
    });
    // Update the provider or database if needed
  }

  void EditReminderTime(Reminder reminder) {}

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
        onPressed: createNewTask,
        child: Icon(Icons.add),
        focusColor: Colors.blueGrey[300],
      ),
      body: ListView.builder(
        itemCount: widget.note.reminderList.length,
        itemBuilder: (context, index) {
          var reminder = widget.note.reminderList[index];
          return ReminderWidget(
            widgetReminder: reminder,
            onChanged: (value) => ClickedCheckBox(value!, index),
            onEdit: (Reminder r) => editReminder(r),
            onDelete: (Reminder r) => deleteReminder(r),
            onEditDate: (Reminder r) => _selectDate(context, reminder),
            onEditTime: (Reminder r) => _selectTime(context, reminder),
            toggleAutoDelete: (Reminder r) =>
                _toggleAutoDelete(context, reminder),
            toggleTimeView: (Reminder r) => _selectDate(context, reminder),
          );
        },
      ),
    );
  }
}
