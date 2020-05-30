import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:timeline_list/timeline.dart";
import "package:timeline_list/timeline_model.dart";
import "package:student_app/screens/balance_detail_screen.dart";
import "package:student_app/screens/balance_preference_screen.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/utils.dart";

class BalanceTimelineScreen extends StatefulWidget {
  final List<Transaction> transactions;

  BalanceTimelineScreen({
    Key key,
    @required this.transactions,
  }) : super(key: key);

  @override
  _BalanceTimelineScreenState createState() => _BalanceTimelineScreenState();
}

class _BalanceTimelineScreenState extends State<BalanceTimelineScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Widget> _pages = [
      widget.transactions.length == 0
          ? Center(child: Text("You have no recorded transactions"))
          : Container(
              child: timelineModel(TimelinePosition.Left),
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
            ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions History"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => BalancePreferenceScreen()),
                );
              })
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: PageView(children: _pages),
    );
  }

  Widget timelineModel(TimelinePosition position) => Timeline.builder(
        itemBuilder: timelineBuilder,
        itemCount: widget.transactions.length,
        physics: ClampingScrollPhysics(),
        position: position,
      );

  TimelineModel timelineBuilder(BuildContext context, int index) {
    final Transaction transaction = widget.transactions[index];

    return TimelineModel(
      GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => BalanceDetailScreen(
            currentTransaction: transaction,
          ),
        )),
        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          clipBehavior: Clip.antiAlias,
          child: Container(
            width: double.infinity,
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    topLeft: Radius.circular(8.0),
                  ),
                  child: Container(
                    height: 100,
                    width: 120,
                    child: Image(
                      image: AssetImage(transaction.isIncome
                          ? "assets/images/income.jpg"
                          : "assets/images/expense.jpg"),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
                        child: Text(
                          transaction.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 0.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.calendar_today),
                            ),
                            Expanded(
                              child: Text(
                                DateFormat(
                                  "E, yyyy-MM-dd",
                                ).format(transaction.date),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(15.0, 5.0, 10.0, 5.0),
                        child: Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(Icons.attach_money),
                            ),
                            Expanded(
                              child: Text(
                                "HKD ${NumberFormat('#,##0.00', 'en_US').format(transaction.amount)}",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8.0),
                    topRight: Radius.circular(8.0),
                  ),
                  child: Container(
                    width: 8,
                    height: 100,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isFirst: index == 0,
      isLast: index == widget.transactions.length,
      icon: Icon(getCategoryIcon(transaction.category)),
      iconBackground: Theme.of(context).accentColor,
    );
  }
}
