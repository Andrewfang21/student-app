import "package:flutter/material.dart";
import "package:timeline_list/timeline.dart";
import "package:timeline_list/timeline_model.dart";
import "package:student_app/models/task.dart";

class ScheduleListScreen extends StatelessWidget {
  final List<Task> tasks;
  final String category;

  const ScheduleListScreen({
    @required this.category,
    @required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.category),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: PageView(
          children: <Widget>[
            Container(
              child: Timeline.builder(
                itemCount: tasks.length,
                itemBuilder: (BuildContext context, int index) {
                  return TimelineModel(
                    Card(
                      child: Text("card $index"),
                    ),
                    isFirst: index == 0,
                    isLast: index == tasks.length,
                    icon: Icon(Icons.ac_unit),
                    iconBackground: Theme.of(context).accentColor,
                  );
                },
                physics: ClampingScrollPhysics(),
                position: TimelinePosition.Left,
              ),
            ),
          ],
        ));
  }
}
