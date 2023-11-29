import 'package:flutter/material.dart';
import 'package:myapp/classes/reminder.dart';

class ReminderWidget extends StatelessWidget {
  final Reminder widgetReminder;
  final Function(bool?)? onChanged;
  final Function(Reminder) onEdit;
  final Function(Reminder) onDelete;

  ReminderWidget({
    super.key,
    required this.widgetReminder,
    this.onChanged,
    required this.onEdit,
    required this.onDelete,
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
            PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'edit') {
                  onEdit(widgetReminder);
                } else if (result == 'delete') {
                  onDelete(widgetReminder);
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
