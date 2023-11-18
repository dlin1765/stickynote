import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/classes/note.dart';
import 'package:myapp/classes/noteData.dart';
import 'package:myapp/screens/noteview.dart';
import 'package:provider/provider.dart';
//import 'package:flutter_quill/flutter_quill.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Note createNewNotes() {
    int id = Provider.of<NoteData>(context, listen: false).GetNoteList().length;
    Note newNote = Note(id: id, text: 'added note');
    return newNote;
  }

  void CreateNewNote() {
    int id = Provider.of<NoteData>(context, listen: false).GetNoteList().length;
    Note newNote = Note(id: id, text: 'added note');
    Provider.of<NoteData>(context, listen: false).CreateNewNote(newNote);
    GoToEditNotePage(newNote, true);
  }

  void GoToEditNotePage(Note note, bool isNewNote) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NoteView(note: note, isNewNote: isNewNote)));
  }

  void deleteNote(Note note) {
    Provider.of<NoteData>(context, listen: false).DeleteNote(note);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NoteData>(
        builder: (context, value, child) => Scaffold(
            backgroundColor: Colors.amberAccent,
            appBar: AppBar(
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
                  child: Text(
                      'Your Recent Notes'), // figure out how to make this go to the left side
                ),
                Expanded(
                  child: GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(
                          value.GetNoteList().length,
                          (index) => Card(
                                elevation: 10,
                                child: Text(value.GetNoteList()[index].text),
                              ))),
                )
              ],
            )));
  }
}

/*


        */
