import "package:flutter/material.dart";
import "package:table_calendar/table_calendar.dart";
import "package:student_app/widgets/customized_app_bar.dart";
import "package:student_app/widgets/calendar.dart";

class ScheduleScreen extends StatefulWidget {
  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomizedAppBar(title: "Schedule"),
          Calendar(),
        ],
      ),
    );
  }
}
