import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:myapp/classes/note.dart';
import 'package:myapp/classes/reminder.dart';
import 'package:myapp/classes/noteData.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:myapp/screens/reminderview.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class NoteView extends StatefulWidget {
  final Note note;
  final bool isNewNote;
  final NoteData noteData;

  NoteView({
    super.key,
    required this.note,
    required this.isNewNote,
    required this.noteData,
  });

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  final FocusNode _focusNode = FocusNode();
  late TextEditingController _titleController;
  late TextEditingController _textController;
  QuillController quillController = QuillController.basic();
  late TimeOfDay selectedTime;
  late DateTime selectedDate;

  @override
  void initState() {
    super.initState();
    LoadExistingNote();
    _titleController = TextEditingController(text: widget.note.title);
    _textController = TextEditingController(text: widget.note.text);

    tz.initializeTimeZones(); // Initialize the tz library

    if (widget.note.reminderTime != null) {
      selectedTime = TimeOfDay.fromDateTime(widget.note.reminderTime);
      selectedDate = widget.note.reminderTime;
    } else {
      selectedTime = TimeOfDay.now();
      selectedDate = DateTime.now();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _textController.dispose();
    //quillController.dispose();

    super.dispose();
  }

  void LoadExistingNote() {
    final doc = Document()..insert(0, widget.note.text);

    setState(() {
      quillController = QuillController(
          document: doc, selection: const TextSelection.collapsed(offset: 0));
    });
  }

  void GoToReminderPage(Note note, NoteData noteData) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReminderView(
                  note: note,
                  noteData: Provider.of<NoteData>(context, listen: false),
                )));
  }

  void addNewNote(int i) {
    String text = quillController.document.toPlainText();
    Provider.of<NoteData>(context, listen: false).CreateNewNote(
      Note(
          id: i,
          title: widget.note.title,
          text: text,
          reminderTime: widget.note.reminderTime,
          reminderList: []),
    ); // date time is temporary
  }

  void updateNote() {
    String newText = quillController.document.toPlainText();
    Provider.of<NoteData>(context, listen: false)
        .updateNote(widget.note.id, newText, widget.note.reminderTime);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> _addEditList(BuildContext context, {Document? document}) async {
    final isEditing = document != null;
    final quillEditorController = QuillController(
      document: document ?? Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
          titlePadding: const EdgeInsets.only(left: 16, top: 8),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${isEditing ? 'Edit' : 'Add'} note'),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              )
            ],
          ),
          content: QuillProvider(
            configurations: QuillConfigurations(
              controller: quillEditorController,
              sharedConfigurations: const QuillSharedConfigurations(
                locale: Locale('de'),
              ),
            ),
            child: QuillEditor.basic(),
          )),
    );

    if (quillEditorController.document.isEmpty()) return;

    final block = BlockEmbed.custom(
      NotesBlockEmbed.fromDocument(quillEditorController.document),
    );
    final controller = quillController;
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;

    if (isEditing) {
      final offset =
          getEmbedNode(controller, controller.selection.start).offset;
      controller.replaceText(
          offset, 1, block, TextSelection.collapsed(offset: offset));
    } else {
      controller.replaceText(index, length, block, null);
    }
  }

  Widget customElementsEmbedBuilder(
    BuildContext context,
    QuillController controller,
    CustomBlockEmbed block,
    bool readOnly,
    void Function(GlobalKey videoContainerKey)? onVideoInit,
  ) {
    switch (block.type) {
      case 'notes':
        final notes = NotesBlockEmbed(block.data).document;

        return Material(
          color: Colors.transparent,
          child: ListTile(
            title: Text(
              notes.toPlainText().replaceAll('\n', ' '),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            leading: const Icon(Icons.notes),
            onTap: () => _addEditList(context, document: notes),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.grey),
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    //final notes = NotesBlockEmbed(node.value.data).document;

    return Scaffold(
      backgroundColor: Colors.yellow[200],
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Edit Note"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            widget.note.title = _titleController.text;
            if ((widget.isNewNote && !quillController.document.isEmpty()) ||
                (widget.note.title.isNotEmpty && widget.isNewNote)) {
              addNewNote(Provider.of<NoteData>(context, listen: false)
                  .GetNoteList()
                  .length);
            } else {
              updateNote();
            }

            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              widget.note.title = _titleController.text;
              widget.note.text = _textController.text;

              final selectedDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );

              widget.note.reminderTime = selectedDateTime;

              if (widget.isNewNote) {
                widget.noteData.CreateNewNote(widget.note);
              } else {
                widget.noteData.updateNote(
                  widget.note.id,
                  widget.note
                      .text, // maybe not correct maybe have to use the text
                  widget.note.reminderTime,
                );
              }

              _scheduleNotification(widget.note.reminderTime);

              Navigator.pop(context);
            },
          ),
          IconButton(
            onPressed: () => GoToReminderPage(widget.note, widget.noteData),
            icon: Icon(Icons.note_add),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        //var QuillEditor,

        child: Container(
          padding: EdgeInsets.all(28),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(hintText: 'Enter title'),
              ),
              /*
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: InputDecoration(hintText: 'Enter note text'),
                  maxLines: null,
                ),
              ),
              */
              QuillProvider(
                configurations: QuillConfigurations(
                  controller: quillController,
                  sharedConfigurations: const QuillSharedConfigurations(
                    locale: Locale('de'),
                  ),
                ),
                child: Column(
                  children: [
                    QuillBaseToolbar(
                      configurations: QuillBaseToolbarConfigurations(
                          toolbarSize: 15 * 2,
                          multiRowsDisplay: false,
                          childrenBuilder: (context) {
                            final controller = quillController;
                            return [
                              QuillToolbarHistoryButton(
                                controller: controller,
                                options: const QuillToolbarHistoryButtonOptions(
                                    isUndo: true),
                              ),
                              QuillToolbarHistoryButton(
                                controller: controller,
                                options: const QuillToolbarHistoryButtonOptions(
                                    isUndo: false),
                              ),

                              //QuillToolbarCustomButtonExtraOptions(controller: controller, context: context, onPressed: onPressed)
                            ];
                          }),
                    ),
                    SizedBox(
                      height: 150, // size of the box
                      child: QuillEditor(
                        focusNode: _focusNode,

                        //customElementsEmbedBuilder: customElementsEmbedBuilder,oned
                        scrollController: ScrollController(),
                        configurations:
                            const QuillEditorConfigurations(readOnly: false),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: Text(
                  'Set Reminder Date',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(
                'Reminder Date: ${selectedDate.toLocal()}',
                style: TextStyle(fontSize: 16),
              ),
              ElevatedButton(
                onPressed: () {
                  _selectTime(context);
                },
                child: Text(
                  'Set Reminder Time',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Text(
                'Reminder Time: ${selectedTime.format(context)}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _scheduleNotification(DateTime notificationTime) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'my_channel_id',
      'my_reminder',
      channelDescription: 'Receive reminders from noteapp',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'app_icon',
    );

    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      'Reminder',
      'Your notification message here',
      tz.TZDateTime.from(notificationTime, tz.local),
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    //print('times up');
  }
}

class NotesBlockEmbed extends CustomBlockEmbed {
  const NotesBlockEmbed(String value) : super(noteType, value);

  static const String noteType = 'notes';

  static NotesBlockEmbed fromDocument(Document document) =>
      NotesBlockEmbed(jsonEncode(document.toDelta().toJson()));

  Document get document => Document.fromJson(jsonDecode(data));
}
