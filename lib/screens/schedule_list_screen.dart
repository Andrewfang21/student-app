import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:percent_indicator/linear_percent_indicator.dart";
import "package:provider/provider.dart";
import "package:timeline_list/timeline_model.dart";
import "package:student_app/providers/task_provider.dart";
import "package:student_app/screens/schedule_detail_screen.dart";
import "package:student_app/widgets/timeline_widget.dart";
import "package:student_app/models/task.dart";
import "package:student_app/utils.dart";

class ScheduleListScreen extends StatelessWidget {
  final List<Task> tasks;
  final String category;

  const ScheduleListScreen({
    @required this.category,
    @required this.tasks,
  });

  TimelineModel _taskCardBuilder(BuildContext context, int index) {
    final Task task = tasks[index];

    return TimelineModel(
      TimelineCard(
        onTapHandler: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (_) => ScheduleDetailScreen(
                  task: task,
                ))),
        onLongPressHandler: () => showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: GestureDetector(
                    child: Container(child: Text("Delete")),
                    onTap: () {
                      Provider.of<TaskProvider>(context, listen: false)
                          .deleteTask(task.id);
                      Navigator.of(context).pop();
                    },
                  ),
                )),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: const Radius.circular(8.0),
                topLeft: const Radius.circular(8.0),
              ),
              child: Container(
                height: 100,
                width: 120,
                child: Image(
                  image: AssetImage("assets/images/wallpaper-image.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, .0),
                    child: Text(
                      task.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15.0, 5.0, 10.0, .0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.calendar_today),
                        ),
                        Expanded(
                          child: Text(
                              DateFormat("E, yyyy-MM-dd").format(task.dueAt)),
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.only(right: 10.0),
                          child: Icon(Icons.linear_scale),
                        ),
                        Expanded(
                          child: LinearPercentIndicator(
                            width: 100,
                            padding: EdgeInsets.zero,
                            progressColor: priorityItems[task.priority].color,
                            percent: priorityItems[task.priority].percentage,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomRight: const Radius.circular(8.0),
                topRight: const Radius.circular(8.0),
              ),
              child: Container(
                width: 8,
                height: 100,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
        ),
      ),
      isFirst: index == 0,
      isLast: index == tasks.length,
      icon: Icon(taskCategories[task.category]),
      iconBackground: Theme.of(context).accentColor,
    );
  }

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
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TimelineWidget(
                items: tasks,
                builder: _taskCardBuilder,
              ),
            )
          ],
        ));
  }
}
