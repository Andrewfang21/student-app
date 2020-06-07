import "package:flutter/material.dart";
import "package:student_app/models/task.dart";

class ScheduleListScreen extends StatelessWidget {
  final List<Task> tasks;

  const ScheduleListScreen({
    @required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                dense: true,
                title: Text(tasks[index].name),
              );
            }),
      ),
    );
  }
}
