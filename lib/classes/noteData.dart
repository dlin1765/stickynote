import 'package:flutter/material.dart';
import 'note.dart';
//import 'package:provider/provider.dart';

class NoteData extends ChangeNotifier {
  List<Note> NoteList = [
    Note(id: 0, text: "test note"),
    Note(id: 1, text: "test note 2"),
  ];

  List<Note> GetNoteList() {
    return NoteList;
  }

  void CreateNewNote(Note addedNote) {
    NoteList.add(addedNote);
    notifyListeners();
  }

  // need a delete note function

  // need a function that loads the notes data (an update function maybe?)
}
