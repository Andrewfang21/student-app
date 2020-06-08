import "dart:async";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:student_app/models/task.dart";
import "package:student_app/screens/schedule_calendar_screen.dart";
import "package:student_app/screens/schedule_detail_screen.dart";
import "package:student_app/screens/schedule_list_screen.dart";
import "package:student_app/screens/schedule_setting_screen.dart";
import "package:student_app/widgets/customized_app_bar.dart";
import "package:student_app/providers/user_provider.dart";
import "package:student_app/providers/task_provider.dart";
import "package:student_app/models/user.dart";
import "package:student_app/utils.dart";

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

  String _getTotalTasks(List<Task> tasks, String category) {
    int taskCount =
        tasks.where((Task task) => task.category == category).toList().length;
    return taskCount < 2 ? "$taskCount task" : "$taskCount tasks";
  }

  Widget _buildCategoryCarousel(BuildContext context) {
    final List<Task> _tasks =
        Provider.of<TaskProvider>(context, listen: false).tasks;

    return Container(
      height: 120,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: taskCategories.keys.length,
          itemBuilder: (BuildContext context, int index) {
            final String category = taskCategories.keys.toList()[index];
            final IconData categoryIcon = taskCategories.values.toList()[index];

            return Container(
              width: 120,
              child: Card(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => ScheduleListScreen(
                            category: category,
                            tasks: Provider.of<TaskProvider>(context)
                                .getTasksWithCategory(category))),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(categoryIcon),
                        Text(
                          category,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(_getTotalTasks(_tasks, category)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
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
                    return GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) =>
                                ScheduleDetailScreen(task: _todayTasks[index])),
                      ),
                      child: Card(
                        color: Colors.grey[50],
                        child: ListTile(
                          dense: true,
                          leading: Icon(
                            taskCategories[_todayTasks[index].category],
                          ),
                          title: Text(
                            _todayTasks[index].name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat("E, yyyy-MM-dd      HH:mm").format(
                              _todayTasks[index].dueAt,
                            ),
                          ),
                        ),
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomizedAppBar(title: "Schedule"),
        Container(
          child: Column(
            children: <Widget>[
              ..._buildIntroSection(context, _currentUser),
              TitleCard(),
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
        _buildCategoryCarousel(context),
        _buildModalBottomSheet(context),
      ],
    );
  }
}

class TitleCard extends StatefulWidget {
  TitleCard({Key key}) : super(key: key);

  @override
  _TitleCardState createState() => _TitleCardState();
}

class _TitleCardState extends State<TitleCard> {
  DateTime _currentTime;
  Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() => _currentTime = DateTime.now());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  AssetImage getAssetPathBasedOnTime(DateTime time) {
    String assetName = "";
    if (time.hour >= 6 && time.hour <= 11) {
      assetName = "morning";
    } else if (time.hour >= 12 && time.hour <= 15) {
      assetName = "noon";
    } else if (time.hour >= 15 && time.hour <= 18) {
      assetName = "afternoon";
    } else
      assetName = "night";

    return AssetImage("assets/images/$assetName-icon.png");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 35.0,
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
                  child: Text(
                    "${DateFormat('EEEE').format(_currentTime)}, ${DateFormat('MMMM dd').format(_currentTime)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey[100],
                    ),
                  ),
                ),
                Text(DateFormat('HH:mm').format(_currentTime),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.grey[100],
                    )),
                Row(
                  children: <Widget>[
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.bottomCenter,
                      icon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey[100],
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => ScheduleCalendarScreen()),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.bottomCenter,
                      icon: Icon(
                        Icons.settings,
                        color: Colors.grey[100],
                      ),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (_) => ScheduleSettingScreen()),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Image(image: getAssetPathBasedOnTime(_currentTime)),
          )
        ],
      ),
    );
  }
}
