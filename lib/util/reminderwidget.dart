import 'package:flutter/material.dart';
import 'package:myapp/classes/reminder.dart';

class ReminderWidget extends StatelessWidget {
  final Reminder widgetReminder;
  final Function(bool?)? onChanged;
  final Function(Reminder) onEdit;
  final Function(Reminder) onDelete;
  final Function(Reminder) onEditDate;
  final Function(Reminder) onEditTime;
  final Function(Reminder) toggleTimeView;
  final Function(Reminder) toggleAutoDelete;
  late TimeOfDay selectedTime;
  late DateTime selectedDate;

  ReminderWidget({
    super.key,
    required this.widgetReminder,
    this.onChanged,
    required this.onEdit,
    required this.onDelete,
    required this.onEditDate,
    required this.onEditTime,
    required this.toggleTimeView,
    required this.toggleAutoDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        padding: EdgeInsets.all(25.0),
        decoration: BoxDecoration(color: Colors.yellow),
        child: Row(
          children: [
            Checkbox(value: widgetReminder.isDone, onChanged: onChanged),
            Text(
              widgetReminder.text,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(),
            Text((() {
              if (widgetReminder.hasReminder) {
                return widgetReminder.reminderTime.toString().substring(0, 16);
              } else {
                return " ";
              }
            })()),
            //widgetReminder.reminderTime.toString().substring(0, 16)
            PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'edit') {
                  onEdit(widgetReminder);
                } else if (result == 'delete') {
                  onDelete(widgetReminder);
                } else if (result == 'autodelete') {
                } else if (result == 'editdate') {
                  onEditDate(widgetReminder);
                } else if (result == 'edittime') {
                  onEditTime(widgetReminder);
                } else if (result == 'deletewhen') {
                  toggleAutoDelete(widgetReminder);
                } else if (result == 'viewreminder') {
                  widgetReminder.hasReminder = !widgetReminder.hasReminder;
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                const PopupMenuItem<String>(
                  value: 'edit',
                  child: Text('Edit'),
                ),
                const PopupMenuItem<String>(
                  value: 'delete',
                  child: Text('Delete'),
                ),
                const PopupMenuItem<String>(
                  value: 'autodelete',
                  child: Text('Set to auto delete'),
                ),
                const PopupMenuItem<String>(
                  value: 'editdate',
                  child: Text('set/edit reminder DATE'),
                ),
                const PopupMenuItem<String>(
                  value: 'edittime',
                  child: Text('set/edit reminder TIME'),
                ),
                const PopupMenuItem<String>(
                  value: 'viewreminder',
                  child: Text('View reminder time'),
                ),
                const PopupMenuItem<String>(
                  value: 'deletewhen',
                  child: Text('Auto delete when checked off'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //void setState(Null Function() param0) {}
}
