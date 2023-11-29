import 'package:flutter/material.dart';
import 'package:myapp/classes/reminder.dart';
import 'note.dart';
//import 'package:provider/provider.dart';

class NoteData extends ChangeNotifier {
  List<Reminder> temps = [];
  List<Note> NoteList = [
    Note(
        id: 0,
        text: "test note",
        reminderTime: DateTime.now(),
        reminderList: []), // Include reminderTime
    Note(
        id: 1,
        text: "test note 2",
        reminderTime: DateTime.now(),
        reminderList: []), // Include reminderTime
  ];

  List<Note> GetNoteList() {
    return NoteList;
  }

  void CreateNewNote(Note addedNote) {
    NoteList.add(addedNote);
    notifyListeners();
  }

  void DeleteNote(Note note) {
    NoteList.removeWhere((n) => n.id == note.id);
    notifyListeners();
  }

  // void CreateReminder()

  void updateNote(int id, String newText, DateTime? reminderTime) {
    // need to edit this function to update the reminders field in note
    for (var note in NoteList) {
      if (note.id == id) {
        note.text = newText;
        if (reminderTime != null) {
          note.reminderTime = reminderTime; // Update reminder time if provided
        }
        break; // Stop the loop once the note is found and updated
      }
    }

    notifyListeners();
  }
}
