import "package:flutter/material.dart";
import "package:student_app/widgets/calendar.dart";

class ScheduleCalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Calendar(),
    );
  }
}
