import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:percent_indicator/linear_percent_indicator.dart";
import "package:student_app/screens/schedule_detail_screen.dart";
import "package:student_app/models/task.dart";

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
