import 'package:hive/hive.dart';
import 'package:myapp/classes/reminder.dart';

class Note extends HiveObject {
  final int id;

  String title;
  DateTime reminderTime;
  String text;

  //DateTime reminderTime; //Use DateTime for reminder time

  List<Reminder> reminderList;
  /*
  I want the note to be able to store other widgets inside, so might have to have fields not just a string for the data
  
  */
  Note({
    required this.id,
    required this.text,
    this.title = '',
    required this.reminderTime, // Add this parameter to the constructor
    required this.reminderList,
  });
}
