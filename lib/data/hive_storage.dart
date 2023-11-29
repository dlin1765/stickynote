import 'package:hive/hive.dart';
import 'package:myapp/classes/note.dart';

class HiveDatabase {
  final _myData = Hive.box('mydata');

  List<Note> loadNotes() {
    List<Note> currentSavedNotes = [];

    if (_myData.get("ALL_NOTES") != null) {
      List<dynamic> savedNotes = _myData.get("ALL_NOTES");
      for (int i = 0; i < currentSavedNotes.length; i++) {
        Note currentNote = Note(
            id: savedNotes[i][0],
            text: savedNotes[i][1],
            reminderTime: savedNotes[i][2],
            reminderList: [] // REMINDER LIST MUST BE UPDATED
            );
      }
    }
    return currentSavedNotes;
  }
}
