import 'package:flutter/material.dart';
import 'package:myapp/classes/reminder.dart';

class ReminderWidget extends StatelessWidget {
  // ignore: non_constant_identifier_names
  final Reminder WidgetReminder;
  Function(bool?)? OnChanged;

  ReminderWidget({
    super.key,
    required this.WidgetReminder,
    required this.OnChanged,
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
            Checkbox(value: WidgetReminder.isDone, onChanged: OnChanged),
            Text(
              WidgetReminder.text,
              overflow: TextOverflow.ellipsis,
            ),
            Spacer(
              flex: 3,
            ),
            PopupMenuButton<String>(
              onSelected: (String result) {
                if (result == 'edit') {
                } else if (result == 'delete') {}
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

            /*
            itemBuilder: (BuildContext context) =>
                                    
                                  */
          ],
        ),
      ),
    );
  }
}
