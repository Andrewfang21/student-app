import "package:flutter/material.dart";
import 'package:student_app/widgets/customized_app_bar.dart';

class ScheduleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomizedAppBar(title: "Schedule"),
        ],
      ),
    );
  }
}
