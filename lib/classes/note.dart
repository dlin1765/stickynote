class Note {
  final int id;
  String title;
  String text;
  DateTime reminderTime; //Use DateTime for reminder time
  /*
  I want the note to be able to store other widgets inside, so might have to have fields not just a string for the data
  
  */
  Note({
    required this.id,
    required this.text,
    this.title = '',
    required this.reminderTime, // Add this parameter to the constructor
  });
}
