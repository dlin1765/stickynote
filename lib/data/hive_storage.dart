import 'package:hive/hive.dart';
import 'package:myapp/classes/note.dart';
import 'package:myapp/classes/reminder.dart';

class HiveDatabase {
  final _myData = Hive.box('mydata');
  List notes = [];
  int length = 0;
  List<Reminder> ab = [];

  List<Note> loadNotes() {
    List<Note> currentSavedNotes = [];
    List<Reminder> currentSavedReminders = [];
    if (_myData.get("NOTES") != null) {
      print("something in hive");
      List<dynamic> savedNotes = _myData.get("NOTES");

      for (int i = 0; i < savedNotes.length; i++) {
        print('saved notes length: ' + savedNotes.length.toString());
        //List<dynamic> savedReminders =
        currentSavedReminders = [];
        for (int y = 0; y < savedNotes[i][3].length; y++) {
          print('reminder list length: ' + savedNotes[i][3].length.toString());
          Reminder idRemind = Reminder(
              id: savedNotes[i][3][y][0],
              text: savedNotes[i][3][y][1],
              isDone: savedNotes[i][3][y][2],
              deleteOnCompletion: savedNotes[i][3][y][3],
              hasReminder: savedNotes[i][3][y][4],
              reminderTime: DateTime(
                  savedNotes[i][3][y][9],
                  savedNotes[i][3][y][8],
                  savedNotes[i][3][y][7],
                  savedNotes[i][3][y][6],
                  savedNotes[i][3][y][5]),
              destroyTime: DateTime.now());
          currentSavedReminders.add(idRemind);
        }
        Note idNote = Note(
          id: savedNotes[i][0],
          title: savedNotes[i][1],
          text: savedNotes[i][2],
          reminderTime: DateTime.now(), //savedNotes[i][3],
          reminderList: currentSavedReminders, //savedNotes[i][3],
        );
        currentSavedNotes.add(idNote);
        //print(currentSavedNotes[i].title + '__' + currentSavedNotes[i].text);
      }
    } else {
      print("nothing in hive");
    }
    return currentSavedNotes;
  }

  void initData() {
    notes = [
      [0, "note1title", "note1data", DateTime.now(), []],
      [1, "note2title", "note2data", DateTime.now(), []]
    ];
    _myData.put("ALL_NOTES", notes);
  }

  void loadData() {
    //_myData.put("ALL_NOTES", notes);
    //_myData.put("ALL_NOTES", notes);
    notes = _myData.get("ALL_NOTES");
  }

  void updateData() {
    _myData.put("ALL_NOTES", notes);
  }

  void saveTheNotesReminders(List<Note> notes) {
    List<Note> tempList = [];
    if (_myData.get('ALLNOTES') != null) {
      for (var note in _myData.get('ALLNOTES')) {
        tempList.add(note);
        storeInHive(note);
      }
    }
    tempList.addAll(notes);
    _myData.put("ALLNOTES", tempList);
  }

  void storeInHive(Note noteToAdd) {
    _myData.put(noteToAdd.id, noteToAdd);
  }

  void printData(int leng) {
    length = leng;
    List<Note> testList = [];
    Note temp;
    print('from box: ');
    for (int i = 0; i < leng; i++) {
      temp = _myData.get(i);
      print(temp.text);
    }
  }

  void saveNotesReminders(List<Note> paramNotes) {
    List<List<dynamic>> hiveStorageNote = [];
    for (var n in paramNotes) {
      int id = n.id;
      String title = n.title;
      String text = n.text;
      List<dynamic> reminderList = []; // store all the fields of the
      print('title = ' + title);
      //List<Reminder> hiveStorageReminders = [];
      for (var reminder in n.reminderList) {
        int ids = reminder.id;
        String texts = reminder.text;
        bool isDone = reminder.isDone;
        bool deleteOnCompletion = reminder.deleteOnCompletion;
        bool hasReminder = reminder.hasReminder;
        int day = reminder.reminderTime.day;
        int month = reminder.reminderTime.month;
        int year = reminder.reminderTime.year;
        int hour = reminder.reminderTime.hour;
        int minute = reminder.reminderTime.minute;
        //DateTime reminderTimes = reminder.reminderTime;
        //DateTime destroyTime = reminder.destroyTime;
        reminderList.add([
          ids,
          texts,
          isDone,
          deleteOnCompletion,
          hasReminder,
          minute,
          hour,
          day,
          month,
          year,
        ]);
        print('title: ' + n.title);
        print('reminder title ' + texts);
      }

      hiveStorageNote.add([id, title, text, reminderList]);
    }
    _myData.put("NOTES", hiveStorageNote);
  }
}
