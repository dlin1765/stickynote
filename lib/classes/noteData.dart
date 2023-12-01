import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/classes/reminder.dart';
import 'package:myapp/data/hive_storage.dart';
import 'package:myapp/screens/noteview.dart';
import 'package:timezone/timezone.dart' as tz;
import 'note.dart';
//import 'package:provider/provider.dart';

class NoteData extends ChangeNotifier {
  final db = HiveDatabase();
  List<Reminder> ReminderList = [];
  List<Note> NoteList = [];

  void initHiveNotes() {
    NoteList = db.loadNotes();

    for (int i = 0; i < NoteList.length; i++) {
      if (NoteList[i].reminderTime.isAfter(DateTime.now())) {
        _scheduleNotification(NoteList[i].reminderTime, NoteList[i]);
      }
      for (int y = 0; y < NoteList[i].reminderList.length; y++) {
        scheduleNotification(NoteList[i].reminderList[y].reminderTime,
            NoteList[i].reminderList[y]);
      }
    }
  }

  Future<void> _scheduleNotification(
      DateTime notificationTime, Note remNote) async {
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
      'Sticky Note+',
      'Reminder for: ' + remNote.title,
      tz.TZDateTime.from(notificationTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> scheduleNotification(
      DateTime notificationTime, Reminder remNote) async {
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
      'Sticky Note+',
      'Reminder for: ' + remNote.text,
      tz.TZDateTime.from(notificationTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  List<Note> GetNoteList() {
    return NoteList;
  }

  void CreateNewNote(Note addedNote) {
    NoteList.add(addedNote);
    db.saveNotesReminders(NoteList);
    notifyListeners();
  }

  void DeleteNote(Note note) {
    //NoteList.removeWhere((n) => n.id == note.id);
    NoteList.remove(note);
    db.saveNotesReminders(NoteList);
    notifyListeners();
  }

  List<Reminder> GetReminders() {
    for (int i = 0; i < NoteList.length; i++) {
      ReminderList.addAll(NoteList[i].reminderList);
    }
    return ReminderList;
  }

  void updateNote(Note note, String newText) {
    // need to edit this function to update the reminders field in note
    for (int i = 0; i < NoteList.length; i++) {
      if (NoteList[i].id == note.id) {
        NoteList[i].text = newText;
      }
    }
    db.saveNotesReminders(NoteList);

    notifyListeners();
  }
}
