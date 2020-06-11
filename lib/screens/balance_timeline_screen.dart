import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart" as c;
import "package:provider/provider.dart";
import "package:timeline_list/timeline_model.dart";
import "package:student_app/screens/balance_detail_screen.dart";
import "package:student_app/screens/balance_preference_screen.dart";
import "package:student_app/services/transaction_service.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/providers/transaction_provider.dart";
import "package:student_app/widgets/timeline_widget.dart";
import "package:student_app/utils.dart";

class BalanceTimelineScreen extends StatelessWidget {
  TimelineCard _transactionCardBuilder(
      BuildContext context, Transaction transaction) {
    return TimelineCard(
      onTapHandler: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => BalanceDetailScreen(
                currentTransaction: transaction,
              ))),
      onLongPressHandler: () => showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: GestureDetector(
                  child: Container(child: Text("Delete")),
                  onTap: () {
                    // TODO: Change this
                    Provider.of<TransactionProvider>(context, listen: false)
                        .deleteTransaction(transaction.id);
                    Navigator.of(context).pop();
                  },
                ),
              )),
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
                  padding: const EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
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
                          TimeFormatHelper.formatToDayAndDate(
                            transaction.date,
                          ),
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
                          "HKD ${currencyFormat(transaction.amount)}",
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
    );
  }

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder(
        stream: TransactionService.getCollectionReference().snapshots(),
        builder: (
          BuildContext context,
          AsyncSnapshot<c.QuerySnapshot> snapshot,
        ) {
          List<Widget> child = [];

          if (snapshot.connectionState == ConnectionState.waiting)
            child.add(Center(child: CircularProgressIndicator()));
          else {
            final List<Transaction> transactions = snapshot.data.documents
                .map((document) => Transaction.fromJson(document.data))
                .toList();

            if (transactions.isEmpty)
              child.add(
                Center(child: Text("You have no recorded transactions")),
              );
            else
              child.add(Container(
                margin: const EdgeInsets.symmetric(horizontal: 10.0),
                child: TimelineWidget(
                    items: transactions,
                    builder: (BuildContext context, int index) => TimelineModel(
                          _transactionCardBuilder(context, transactions[index]),
                          isFirst: index == 0,
                          isLast: index == transactions.length,
                          icon: Icon(
                            transactionCategories[transactions[index].category],
                          ),
                          iconBackground: Theme.of(context).accentColor,
                        )),
              ));
          }

          return PageView(children: child);
        },
      ),
    );
  }
}
