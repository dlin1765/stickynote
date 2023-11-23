class Note {
  final int id;
  String title;
  String text;
  /*
  I want the note to be able to store other widgets inside, so might have to have fields not just a string for the data
  
  */
  Note({
    required this.id,
    required this.text,
    this.title = '',
  });
}
