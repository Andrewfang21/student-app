import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import "package:provider/provider.dart";
import 'package:student_app/models/task.dart';
import "package:student_app/widgets/customized_app_bar.dart";
import "package:student_app/providers/user_provider.dart";
import "package:student_app/providers/task_provider.dart";
import "package:student_app/models/user.dart";

class ScheduleScreen extends StatelessWidget {
  List<Widget> _buildIntroSection(BuildContext context, User user) {
    return [
      Container(
        width: double.infinity,
        margin: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, .0),
        child: Text(
          "Hi ${user.displayName.split(' ')[0]}",
          style: TextStyle(
            color: Theme.of(context).primaryColorDark,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
        ),
        child: Text(
          "what's your plan?",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      )
    ];
  }

  Widget _buildModalBottomSheet(BuildContext context) {
    final List<Task> _todayTasks =
        Provider.of<TaskProvider>(context, listen: false)
            .getTasksDueAt(DateTime.now());

    return Expanded(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 25.0),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 2.5,
              )
            ]),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 15.0),
                child: Text(
                  "Today's Task",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              Container(
                height: 150,
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _todayTasks.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.grey[50],
                      child: ListTile(
                        dense: true,
                        leading: Icon(Icons.access_alarm),
                        title: Text(_todayTasks[index].name),
                        subtitle: Text(_todayTasks[index].dueAt.toString()),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User _currentUser =
        Provider.of<UserProvider>(context, listen: false).currentUser;

    final DateTime today = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomizedAppBar(title: "Schedule"),
        Container(
          child: Column(
            children: <Widget>[
              ..._buildIntroSection(context, _currentUser),
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 30.0,
                ),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorLight,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.5,
                        offset: Offset(0, 5.5),
                      ),
                      BoxShadow(
                        color: Theme.of(context).primaryColorDark,
                        blurRadius: .5,
                        offset: Offset(0, 2.5),
                      ),
                    ]),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: Text(DateFormat("EEEE").format(today)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 10.0),
                            child: Text(
                              DateFormat("MMMM dd").format(today).toString(),
                            ),
                          ),
                          Text(
                            "${DateFormat('HH:mm').format(DateTime.now())}",
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 20.0),
                        child: Text(
                          "Icon here",
                          textAlign: TextAlign.end,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 10.0,
          ),
          child: Text(
            "Category",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        Container(
          height: 120,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: 120,
                  child: Card(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.ac_unit),
                          Text("This is card $index"),
                          Text("10 tasks"),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        _buildModalBottomSheet(context),
      ],
    );
  }
}
