import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/classes/note.dart';
import 'package:myapp/classes/noteData.dart';
import 'package:myapp/screens/noteview.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  //const HomePage({Key? key}) : super(key: key);
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Note createNewNotes() {
    Note newNote = Note(id: 1, text: 'added note');
    return newNote;
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
              onPressed: () {
                Provider.of<NoteData>(context, listen: false)
                    .CreateNewNote(createNewNotes());
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NoteView()));
              },
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
