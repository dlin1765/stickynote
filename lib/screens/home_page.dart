import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:myapp/classes/note.dart';
import 'package:myapp/classes/noteData.dart';
import 'package:myapp/classes/reminder.dart';
import 'package:myapp/data/hive_storage.dart';
import 'package:myapp/screens/noteview.dart';
import 'package:myapp/screens/reminderview.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:myapp/screens/allreminderpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = []; // Use a List for notes
  List<Reminder> reminders = [];
  List<Note> tempList = [];

  // Initialize the notification plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    Provider.of<NoteData>(context, listen: false).initHiveNotes();
    _initializeNotifications();
  }

  // Function to initialize notifications
  void _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon'); // Replace with your icon
    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (
        int id,
        String? title,
        String? body,
        String? payload,
      ) async {},
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _scheduleNotification(DateTime notificationTime, Note remNote) async {
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

  void CreateNewNote() {
    int id =
        DateTime.now().millisecondsSinceEpoch; // Unique ID based on timestamp
    Note newNote =
        Note(id: id, text: '', reminderTime: DateTime.now(), reminderList: []);

    GoToEditNotePage(newNote, true);
  }

  void GoToEditNotePage(Note note, bool isNewNote) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteView(
                  note: note,
                  isNewNote: isNewNote,
                  noteData: Provider.of<NoteData>(context, listen: false),
                )));
  }

  void GoToReminderPage(Note note) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReminderView(
                  note: note,
                  noteData: Provider.of<NoteData>(context, listen: false),
                )));
  }

  void deleteNote(Note note) {
    Provider.of<NoteData>(context, listen: false).DeleteNote(note);
  }

  // Function to format remaining time as days, hours, minutes, and seconds
  String formatRemainingTime(Duration remainingDuration) {
    final days = remainingDuration.inDays;
    final hours = remainingDuration.inHours.remainder(24);
    final minutes = remainingDuration.inMinutes.remainder(60);
    final seconds = remainingDuration.inSeconds.remainder(60);

    if (days > 0) {
      return '$days days ${hours}h ${minutes}m ${seconds}s';
    } else {
      return '${hours}h ${minutes}m ${seconds}s';
    }
  }

  void _navigateToAllReminders() {
    List<Reminder> temp1 = [];
    for (int i = 0;
        i < Provider.of<NoteData>(context, listen: false).GetNoteList().length;
        i++) {
      temp1.addAll(Provider.of<NoteData>(context, listen: false)
          .GetNoteList()[i]
          .reminderList);
    }
    Note(id: -1, text: '', reminderTime: DateTime.now(), reminderList: temp1);
    Note note1;
    final noteData = Provider.of<NoteData>(context, listen: false);
    noteData.GetReminders();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReminderView(
                note: Note(
                    id: -1,
                    text: '',
                    reminderTime: DateTime.now(),
                    reminderList: temp1),
                noteData: noteData)));
  }

  Future<void> _selectDate(BuildContext context, Note idNote) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null && pickedDate != idNote.reminderTime) {
      setState(() {
        idNote.reminderTime = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, Note idNote) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null &&
        pickedTime != TimeOfDay.fromDateTime(idNote.reminderTime)) {
      setState(() {
        var tempReminder = idNote.reminderTime;
        DateTime temp = DateTime(tempReminder.year, tempReminder.month,
            tempReminder.day, pickedTime.hour, pickedTime.minute);
        idNote.reminderTime = temp;
      });
    }
    _scheduleNotification(idNote.reminderTime, idNote);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
      builder: (context, value, child) => Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
                onSelected: (String result) {
                  if (result == 'allreminders') {
                    _navigateToAllReminders();
                  } else if (result == 'delete all') {
                    for (var note in value.GetNoteList()) {
                      Provider.of<NoteData>(context, listen: false)
                          .DeleteNote(note);
                    }
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'allreminders',
                        child: Text('view all reminders'),
                      ),
                      const PopupMenuItem<String>(
                          value: 'delete all', child: Text('Debug'))
                    ]),
          ],
          elevation: 0.0,
          title: const Text("Sticky Note+"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 204, 173, 60),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: CreateNewNote,
          child: const Icon(Icons.add),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Your Recent Notes'), //
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(
                  value.GetNoteList().length,
                  (index) => Card(
                    elevation: 10,
                    color: Colors.yellow[300],
                    child: Container(
                      height: 400,
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(
                              value.GetNoteList()[index].title,
                              overflow: TextOverflow.ellipsis,
                            ),
                            contentPadding: EdgeInsets.all(10),
                            subtitle: Text(
                              value.GetNoteList()[index].text,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              PopupMenuButton<String>(
                                onSelected: (String result) {
                                  if (result == 'edit') {
                                    String temp =
                                        value.GetNoteList()[index].text;
                                    GoToEditNotePage(
                                        value.GetNoteList()[index], false);
                                  } else if (result == 'delete') {
                                    Provider.of<NoteData>(context,
                                            listen: false)
                                        .DeleteNote(value.GetNoteList()[index]);
                                  } else if (result == 'setdate') {
                                    _selectDate(
                                        context, value.GetNoteList()[index]);
                                  } else if (result == 'settime') {
                                    _selectTime(
                                        context, value.GetNoteList()[index]);
                                  }
                                },
                                itemBuilder: (BuildContext context) =>
                                    <PopupMenuEntry<String>>[
                                  const PopupMenuItem<String>(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Text('Delete'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'setdate',
                                    child: Text('Set Date'),
                                  ),
                                  const PopupMenuItem<String>(
                                    value: 'settime',
                                    child: Text('Set Time'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
