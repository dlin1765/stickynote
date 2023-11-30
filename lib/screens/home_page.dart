import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myapp/classes/note.dart';
import 'package:myapp/classes/noteData.dart';
import 'package:myapp/classes/reminder.dart';
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
  // HOME PAGE SHOULD PROBABLY HAVE A LIST OF REMINDERS TOO

  // Initialize the notification plugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    // Initialize the notification plugin
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
    for (int i = 0; i < notes.length; i++) {
      temp1.addAll(notes[i].reminderList);
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

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(builder: (context, value, child) {
      // Clear and rebuild the List with notes from the NoteData
      notes.clear();
      notes.addAll(value.GetNoteList());
      reminders.addAll(value.GetReminders());
      // Sort notes based on time remaining
      // notes.sort((a, b) => a.reminderTime.compareTo(b.reminderTime));

      return Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(
          actions: [
            PopupMenuButton<String>(
                onSelected: (String result) {
                  if (result == 'allreminders') {
                    _navigateToAllReminders();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'allreminders',
                        child: Text('view all reminders'),
                      ),
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
              child: Text('Your Recent Notes'), // Title for Recent Notes
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(
                  notes.length,
                  (index) {
                    final note = notes[index];
                    DateTime now = DateTime.now();
                    Duration remainingDuration =
                        note.reminderTime.difference(now);
                    String timeRemaining = 'Time\'s up!';
                    if (!remainingDuration.isNegative) {
                      // Calculate and format the time remaining
                      timeRemaining = formatRemainingTime(remainingDuration);
                    }

                    return Card(
                      elevation: 10,
                      color: Colors.yellow[300],
                      child: Container(
                        height: 400,
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                note.title ?? '无标题',
                                overflow: TextOverflow.ellipsis,
                              ),
                              contentPadding: EdgeInsets.all(10.0),
                              // Display note title
                              subtitle: Text(
                                note.text,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Display note text
                            ),

                            Text(
                              'Time Remaining: $timeRemaining',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              // Display time remaining
                            ),

                            //THIS DISPLAYS THE ID OF THE NOTE JUST SO I CAN DEBUG
                            //Text(note.id.toString()),
                            Spacer(
                              flex: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                PopupMenuButton<String>(
                                  onSelected: (String result) {
                                    if (result == 'edit') {
                                      String temp = note.text;
                                      print('this is what the note has $temp');
                                      GoToEditNotePage(notes[index], false);
                                    } else if (result == 'delete') {
                                      Provider.of<NoteData>(context,
                                              listen: false)
                                          .DeleteNote(note);
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
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
