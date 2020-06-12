import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart" as c;
import "package:intl/intl.dart";
import "package:provider/provider.dart";
import "package:student_app/services/transaction_service.dart";
import "package:student_app/widgets/pie_chart.dart";
import "package:student_app/widgets/time_series_chart.dart";
import "package:student_app/providers/user_provider.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/utils.dart";

class BalanceStatisticScreen extends StatefulWidget {
  @override
  _BalanceStatisticScreenState createState() => _BalanceStatisticScreenState();
}

class _BalanceStatisticScreenState extends State<BalanceStatisticScreen> {
  final RangeDate _currentRangeDate = RangeDate(DateTime.now());

  String formatDate(DateTime date) {
    return DateFormat("MMM dd, yy").format(date);
  }

  Widget _buildNavigationPanel(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 1.5,
            offset: Offset(0, .5),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2.0, left: 10.0),
            child: SizedBox(
                width: 140,
                height: double.infinity,
                child: Column(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      child: Text(
                        "Last 30 days",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      width: double.infinity,
                      child: Text(
                        "${formatDate(_currentRangeDate.left)} - ${formatDate(_currentRangeDate.right)}",
                      ),
                    ))
                  ],
                )),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 30),
                IconButton(
                  icon: Icon(Icons.chevron_left),
                  onPressed: () =>
                      setState(() => _currentRangeDate.moveDate(31)),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () =>
                      setState(() => _currentRangeDate.moveDate(-31)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  List<Widget> _buildPieChartSection(
    List<Transaction> currentTransactions,
    double amount,
    String status,
  ) {
    final String imageSrc = status == TransactionHelper.INCOME
        ? "assets/images/sad-emoji.png"
        : "assets/images/happy-emoji.png";

    return [
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          status,
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
      ),
      Container(
        height: 250,
        margin: const EdgeInsets.only(bottom: 20.0),
        child: isZero(amount)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage(imageSrc),
                      width: 50,
                    ),
                    SizedBox(height: 15),
                    Text(
                      "You have no ${status.toLowerCase()} in this period",
                    ),
                  ],
                ),
              )
            : PieChart(
                transactions: TransactionHelper.getTransactionsByStatus(
                  currentTransactions,
                  status,
                ),
                totalAmount: amount,
              ),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions Statistics"),
        elevation: .0,
        bottom: PreferredSize(
          child: _buildNavigationPanel(context),
          preferredSize: Size(double.infinity, 50),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: StreamBuilder(
          stream: TransactionService.getCollectionReference().snapshots(),
          builder: (
            BuildContext context,
            AsyncSnapshot<c.QuerySnapshot> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return PageView(
                children: <Widget>[
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ],
              );
            }

            final List<Transaction> recentTransactions = snapshot.data.documents
                .map((document) =>
                    Transaction.fromJson(document.documentID, document.data))
                .where((document) =>
                    document.creatorId ==
                        Provider.of<UserProvider>(context, listen: false)
                            .currentUserID &&
                    document.date.isAfter(_currentRangeDate.left) &&
                    document.date.isBefore(_currentRangeDate.right))
                .toList();
            final double income =
                TransactionHelper.getIncome(recentTransactions);
            final double expense =
                TransactionHelper.getExpense(recentTransactions);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Total Income"),
                              Text(
                                "HKD ${currencyFormat(income)}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text("Total Expense"),
                              Text(
                                "HKD ${currencyFormat(expense)}",
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ..._buildPieChartSection(
                      recentTransactions, income, TransactionHelper.INCOME),
                  ..._buildPieChartSection(
                      recentTransactions, expense, TransactionHelper.EXPENSE),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      "Time Series Chart",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  Container(
                    height: 300,
                    margin: const EdgeInsets.only(bottom: 20.0),
                    child: TimeSeriesChart(
                      transactions: recentTransactions,
                      tickerCount: 10,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    height: 15,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        ChartLegend(
                            label: TransactionHelper.INCOME,
                            color: Colors.blue),
                        SizedBox(width: 20),
                        ChartLegend(
                            label: TransactionHelper.EXPENSE,
                            color: Colors.red),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class ChartLegend extends StatelessWidget {
  final String label;
  final Color color;

  const ChartLegend({
    @required this.label,
    @required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 5.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 30,
            margin: const EdgeInsets.only(right: 5.0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Container(
              child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.cyanAccent.shade700,
            ),
          )),
        ],
      ),
    );
  }
}

class RangeDate {
  DateTime left;
  DateTime right;

  RangeDate(DateTime time) {
    this.right = time;
    this.left = this.right.subtract(Duration(days: 30));
  }

  void moveDate(int days) {
    this.right = this.right.subtract(Duration(days: days));
    this.left = this.left.subtract(Duration(days: days));
  }
}
