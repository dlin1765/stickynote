import 'package:flutter/material.dart';
import 'package:myapp/noteview.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.amberAccent,
        appBar: AppBar(
          elevation: 0.0,
          title: const Text("Sticky Note+"),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 204, 173, 60),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const NoteView()));
          },
          child: const Icon(Icons.add),
        ),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Recent Notes",
              ),
              SizedBox(
                height: 20.0,
              ),
              //GridView.builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), itemBuilder: itemBuilder);
            ],
          ),
        ));
  }
}
