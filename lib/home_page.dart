import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            onPressed: () {},
            child: Text('write'),
            color: Colors.blue,
          ),
          MaterialButton(
            onPressed: () {},
            child: Text('read'),
            color: Colors.blue,
          ),
          MaterialButton(
            onPressed: () {},
            child: Text('delete'),
            color: Colors.blue,
          ),
        ],
      )),
    );
  }
}
