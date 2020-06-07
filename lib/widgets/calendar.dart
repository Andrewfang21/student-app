import "package:flutter/material.dart";
import "package:table_calendar/table_calendar.dart";

class Calendar extends StatefulWidget {
  Calendar({Key key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarController _calendarController;

  @override
  void initState() {
    super.initState();
    _calendarController = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: TableCalendar(
          initialCalendarFormat: CalendarFormat.twoWeeks,
          calendarController: _calendarController,
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
          onDaySelected: (date, events) {
            print(date.toIso8601String());
            print(events);
          },
          onDayLongPressed: (day, events) async {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      content: Text(
                          "You have long pressed this day ${day.toIso8601String()}"),
                    ));
          },
          builders: CalendarBuilders(
            selectedDayBuilder: (context, date, events) => Container(
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
            ),
          )),
    );
  }
}
