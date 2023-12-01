import 'package:hive/hive.dart';
import 'package:myapp/classes/note.dart';

class NoteAdapter extends TypeAdapter<Note> {
  @override
  final typeId = 0;

  @override
  Note read(BinaryReader reader) {
    Note n;
    n = Note(
        id: 0, text: 'test', reminderTime: DateTime.now(), reminderList: []);

    return n = reader.read();
  }

  @override
  void write(BinaryWriter writer, Note obj) {
    writer.write(obj);
  }
}
