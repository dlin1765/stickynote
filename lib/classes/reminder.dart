class Reminder {
  final int id;
  String title;
  String text;
  bool isDone;
  bool deleteOnCompletion;
  bool hasReminder;
  DateTime reminderTime; //Use DateTime for reminder time
  DateTime destroyTime;
  /*
  I want the note to be able to store other widgets inside, so might have to have fields not just a string for the data
  
  */
  Reminder({
    required this.id,
    required this.text,
    this.deleteOnCompletion = false,
    this.isDone = true,
    this.hasReminder = false,
    this.title = '',
    required this.reminderTime, // Add this parameter to the constructor
    required this.destroyTime,
  });
}
