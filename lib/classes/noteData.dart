import 'package:flutter/material.dart';
import 'package:myapp/classes/reminder.dart';
import 'package:myapp/data/hive_storage.dart';
import 'note.dart';
//import 'package:provider/provider.dart';

class NoteData extends ChangeNotifier {
  final db = HiveDatabase();
  List<Reminder> ReminderList = [];
  List<Note> NoteList = [];

  void initHiveNotes() {
    NoteList = db.loadNotes();
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
