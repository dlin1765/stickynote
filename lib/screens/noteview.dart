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
  late TextEditingController _titleController;
  late TextEditingController _textController;
  QuillController quillController = QuillController.basic();
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _textController = TextEditingController(text: widget.note.text);
  }

  void LoadExistingNote() {}
  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Note"),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Logic to save the edited note
              widget.note.title = _titleController.text;
              widget.note.text = _textController.text;
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(hintText: 'Enter title'),
            ),
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(hintText: 'Enter note text'),
                maxLines: null, // Allows for multiple lines
              ),
            ),
          ],
        ),
      ),
    );
  }
}
