import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:provider/provider.dart";
import "package:table_calendar/table_calendar.dart";
import "package:timeline_list/timeline_model.dart";
import "package:student_app/models/task.dart";
import "package:student_app/providers/user_provider.dart";
import "package:student_app/screens/schedule_detail_screen.dart";
import "package:student_app/services/task_service.dart";
import "package:student_app/widgets/task_card.dart";
import "package:student_app/widgets/timeline_widget.dart";
import "package:student_app/utils.dart";

class ScheduleCalendarScreen extends StatelessWidget {
  Map<DateTime, List<dynamic>> _groupTasks(List<dynamic> allTasks) {
    Map<DateTime, List<dynamic>> data = {};
    allTasks.forEach((task) {
      DateTime date = DateTime(
        task.dueAt.year,
        task.dueAt.month,
        task.dueAt.day,
      );
      if (data[date] == null) data[date] = [];
      data[date].add(task);
    });

    return data;
  }

  @override
  Widget build(BuildContext context) {
    final String userID =
        Provider.of<UserProvider>(context, listen: false).currentUserID;

    return Scaffold(
        appBar: AppBar(title: Text("Calendar")),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
            stream: TaskService.getAllTasks(userID).snapshots(),
            builder: (
              BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              List<dynamic> allTasks = snapshot.data.documents
                  .map((document) =>
                      TaskModel.fromJson(document.documentID, document.data))
                  .toList();

              Map<DateTime, List<dynamic>> _tasks = {};
              if (allTasks.isNotEmpty) _tasks = _groupTasks(allTasks);

              return CalendarWidget(tasks: _tasks);
            },
          ),
        ));
  }
}

class CalendarWidget extends StatefulWidget {
  final Map<DateTime, List<dynamic>> tasks;

  const CalendarWidget({
    @required this.tasks,
  });

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  CalendarController _calendarController;
  List<dynamic> _selectedTasks = [];

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          child: TableCalendar(
            initialCalendarFormat: CalendarFormat.month,
            calendarController: _calendarController,
            events: widget.tasks,
            calendarStyle: CalendarStyle(
              todayColor: Theme.of(context).primaryColor,
            ),
            headerStyle: HeaderStyle(
              centerHeaderTitle: true,
              formatButtonDecoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
              formatButtonShowsNext: false,
            ),
            onDaySelected: (DateTime date, List<dynamic> tasks) {
              setState(() => _selectedTasks = tasks);
            },
            builders:
                CalendarBuilders(selectedDayBuilder: (context, date, events) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColorDark,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TimelineWidget(
              items: _selectedTasks,
              builder: (BuildContext context, int index) {
                final TaskModel task = _selectedTasks[index];

                return TimelineModel(
                    TimelineCard(
                      onTapHandler: () =>
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ScheduleDetailScreen(
                                    task: task,
                                    allowEdit: false,
                                  ))),
                      onLongPressHandler: null,
                      child: TaskCard(task: task),
                    ),
                    icon: Icon(taskCategories[task.category]),
                    iconBackground: Theme.of(context).accentColor,
                    isFirst: index == 0,
                    isLast: index == _selectedTasks.length);
              },
            ),
          ),
        ),
      ],
    );
  }
}
