import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:myapp/classes/note.dart';

class NoteView extends StatefulWidget {
  Note note;
  bool isNewNote;
  NoteView({
    super.key,
    required this.note,
    required this.isNewNote,
  });

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  QuillController quillController = QuillController.basic();
  @override
  void initState() {}

  void LoadExistingNote() {}

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("new note"),
      ),
    );
  }
}
