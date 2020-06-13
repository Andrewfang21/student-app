import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:timeline_list/timeline_model.dart";
import "package:student_app/models/task.dart";
import "package:student_app/screens/schedule_detail_screen.dart";
import "package:student_app/services/task_service.dart";
import "package:student_app/widgets/task_card.dart";
import "package:student_app/widgets/timeline_widget.dart";
import "package:student_app/utils.dart";

class ScheduleListScreen extends StatelessWidget {
  final String category;
  final bool isPast;

  const ScheduleListScreen({
    @required this.category,
    this.isPast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isPast ? "$category History" : "$category"),
        actions: isPast
            ? null
            : <Widget>[
                IconButton(
                  icon: Icon(Icons.history),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ScheduleListScreen(
                            category: category,
                            isPast: true,
                          ))),
                )
              ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(
        children: <Widget>[
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: StreamBuilder(
                stream: isPast
                    ? TaskService.getAllPastTasksByCategory(category)
                        .snapshots()
                    : TaskService.getCollectionReferenceByCategory(category)
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
                      child: Text(isPast
                          ? "You have no past tasks for this category"
                          : "You have no upcoming tasks for this category"),
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
