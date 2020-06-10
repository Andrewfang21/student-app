import "package:flutter/material.dart";
import "package:intl/intl.dart";

class DateFormButton extends StatefulWidget {
  final Function onPressDateHandler;
  final Function onPressTimeHandler;
  final DateTime date;

  DateFormButton({
    @required this.date,
    @required this.onPressDateHandler,
    @required this.onPressTimeHandler,
  });

  @override
  _DateFormButtonState createState() => _DateFormButtonState();
}

class _DateFormButtonState extends State<DateFormButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          FlatButton(
            onPressed: widget.onPressDateHandler,
            color: Colors.grey[300],
            child: Row(
              children: <Widget>[
                Icon(Icons.date_range),
                Container(
                  margin: const EdgeInsets.only(left: 5.0),
                  child: SizedBox(
                    width: 80.0,
                    child: Text(DateFormat("dd-MM-yyyy").format(widget.date)),
                  ),
                ),
                Container(child: Icon(Icons.chevron_right)),
              ],
            ),
          ),
          FlatButton(
            onPressed: widget.onPressTimeHandler,
            color: Colors.grey[300],
            child: Row(
              children: <Widget>[
                Icon(Icons.timer),
                Container(
                  margin: const EdgeInsets.only(left: 5.0),
                  child: SizedBox(
                    width: 80.0,
                    child: Text(DateFormat.Hm().format(widget.date)),
                  ),
                ),
                Container(child: Icon(Icons.chevron_right)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
