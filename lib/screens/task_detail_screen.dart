import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:percent_indicator/linear_percent_indicator.dart";
import "package:intl/intl.dart";
import "package:student_app/models/task.dart";
import "package:student_app/screens/task_edit_screen.dart";
import "package:student_app/services/task_service.dart";

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;
  final bool allowEdit;

  TaskDetailScreen({
    @required this.task,
    this.allowEdit = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: StreamBuilder(
        stream: TaskService.getDocumentReference(task.id).snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<DocumentSnapshot> snapshot,
        ) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );

          return CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                expandedHeight: 300,
                backgroundColor: Theme.of(context).backgroundColor,
                leading: Container(),
                flexibleSpace: FlexibleSpaceBar(
                  background: ClipPath(
                    clipper: CustomShapeClipper(),
                    child: Image(
                      image: AssetImage("assets/images/wallpaper-image.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    task.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  titlePadding: const EdgeInsets.fromLTRB(20.0, .0, 80.0, 25.0),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              child: Icon(Icons.date_range),
                              margin: const EdgeInsets.only(right: 10.0),
                            ),
                            Text(
                              DateFormat("EEEE, dd MMMM").format(task.dueAt),
                            ),
                            SizedBox(width: 60.0),
                            Container(
                              child: Icon(Icons.access_time),
                              margin: const EdgeInsets.only(right: 10.0),
                            ),
                            Text(
                              DateFormat("HH:mm").format(task.dueAt),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Container(
                            child: Icon(Icons.linear_scale),
                            margin: const EdgeInsets.only(right: 15.0),
                          ),
                          LinearPercentIndicator(
                            width: 150,
                            padding: EdgeInsets.zero,
                            progressColor: priorityItems[task.priority].color,
                            percent: priorityItems[task.priority].percentage,
                          ),
                        ],
                      ),
                      Divider(color: Colors.grey),
                      Text(
                        "Description",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Container(
                        margin:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 30.0),
                        child: Text(
                          task.description,
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: allowEdit
          ? FloatingActionButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => TaskEditScreen(
                        currentTask: task,
                      ))),
              child: Icon(Icons.edit),
            )
          : null,
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
      size.width / 4,
      size.height,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(
      size.width - size.width / 20,
      size.height,
      size.width,
      size.height - 100,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class PriorityItem {
  final double percentage;
  final Color color;

  PriorityItem({
    @required this.percentage,
    @required this.color,
  });
}

final List<PriorityItem> priorityItems = [
  PriorityItem(percentage: .0, color: Colors.grey),
  PriorityItem(percentage: .33, color: Colors.green),
  PriorityItem(percentage: .66, color: Colors.amber[600]),
  PriorityItem(percentage: 1.0, color: Colors.red),
];
