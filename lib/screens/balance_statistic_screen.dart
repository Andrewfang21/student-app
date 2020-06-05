import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/providers/transaction_provider.dart";
import "package:student_app/widgets/pie_chart.dart";
import "package:student_app/widgets/time_series_chart.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/utils.dart";

class BalanceStatisticScreen extends StatefulWidget {
  @override
  _BalanceStatisticScreenState createState() => _BalanceStatisticScreenState();
}

class _BalanceStatisticScreenState extends State<BalanceStatisticScreen> {
  RangeDate _currentDate;

  @override
  void initState() {
    super.initState();
    _currentDate = RangeDate(DateTime.now());
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
                        "${TimeFormatHelper.formatToDateOnlyMinimized(_currentDate.left)} - ${TimeFormatHelper.formatToDateOnlyMinimized(_currentDate.right)}",
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
                  onPressed: () => setState(() => _currentDate.moveDate(31)),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right),
                  onPressed: () => setState(() => _currentDate.moveDate(-31)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildChartLabel(Color color, String label) {
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
    final List<Transaction> _currentTransactions =
        Provider.of<TransactionProvider>(context)
            .getTransactionsByDateRange(_currentDate.left, _currentDate.right);

    final double income = TransactionHelper.getIncome(_currentTransactions);
    final double expense = TransactionHelper.getExpense(_currentTransactions);

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
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
                _currentTransactions, income, TransactionHelper.INCOME),
            ..._buildPieChartSection(
                _currentTransactions, expense, TransactionHelper.EXPENSE),
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
                transactions: _currentTransactions,
                tickerCount: 10,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
              height: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _buildChartLabel(Colors.blue, TransactionHelper.INCOME),
                  SizedBox(width: 20),
                  _buildChartLabel(Colors.red, TransactionHelper.EXPENSE),
                ],
              ),
            )
          ],
        ),
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
