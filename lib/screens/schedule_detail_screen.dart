import "package:flutter/material.dart";
import "package:student_app/models/task.dart";

class ScheduleDetailScreen extends StatelessWidget {
  final Task task;

  const ScheduleDetailScreen({
    @required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          Text(task.name),
          Text(task.description),
          Text(task.category),
        ],
      ),
    );
  }
}
