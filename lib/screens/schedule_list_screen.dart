import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:intl/intl.dart";
import "package:percent_indicator/linear_percent_indicator.dart";
import "package:timeline_list/timeline_model.dart";
import "package:student_app/models/task.dart";
import "package:student_app/screens/schedule_detail_screen.dart";
import "package:student_app/services/task_service.dart";
import "package:student_app/widgets/timeline_widget.dart";
import "package:student_app/utils.dart";

class ScheduleListScreen extends StatelessWidget {
  final String category;

  const ScheduleListScreen({
    @required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(this.category)),
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: StreamBuilder(
                stream: TaskService.getCollectionReferenceByCategory(category)
                    .snapshots(),
                builder: (
                  BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot,
                ) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator());

                  List<Task> tasks = snapshot.data.documents
                      .map((document) =>
                          Task.fromJson(document.documentID, document.data))
                      .toList();

                  if (tasks.isEmpty)
                    return Center(
                      child:
                          Text("You have no upcoming tasks for this category"),
                    );

                  return TimelineWidget(
                      items: tasks,
                      builder: (BuildContext context, int index) {
                        final Task task = tasks[index];

                        return TimelineModel(
                            TimelineCard(
                              child: TaskCard(task: task),
                              onTapHandler: () =>
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => ScheduleDetailScreen(
                                            task: task,
                                          ))),
                              onLongPressHandler: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  content: GestureDetector(
                                    child: Container(child: Text("Delete")),
                                    onTap: () async {
                                      Navigator.of(context).pop(true);
                                      await TaskService.deleteTask(task);
                                    },
                                  ),
                                ),
                              ),
                            ),
                            icon: Icon(taskCategories[task.category]),
                            iconBackground: Theme.of(context).accentColor,
                            isFirst: index == 0,
                            isLast: index == tasks.length);
                      });
                },
              ))
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final Task task;

  const TaskCard({
    @required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
                      child:
                          Text(DateFormat("E, yyyy-MM-dd").format(task.dueAt)),
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
    );
  }
}
