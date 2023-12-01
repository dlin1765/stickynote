import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Reminder extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String text;

  @HiveField(2)
  bool isDone;

  @HiveField(3)
  bool deleteOnCompletion;

  @HiveField(4)
  bool hasReminder;

  @HiveField(5)
  DateTime reminderTime;

  @HiveField(6) //Use DateTime for reminder time
  DateTime destroyTime;
  /*
  I want the note to be able to store other widgets inside, so might have to have fields not just a string for the data
  
  */
  Reminder({
    required this.id,
    required this.text,
    this.isDone = false,
    this.deleteOnCompletion = false,
    this.hasReminder = false,
    required this.reminderTime, // Add this parameter to the constructor
    required this.destroyTime,
  });
}
