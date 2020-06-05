import "dart:math";

import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/screens/balance_detail_screen.dart";
import "package:student_app/screens/balance_statistic_screen.dart";
import "package:student_app/screens/balance_timeline_screen.dart";
import "package:student_app/widgets/customized_app_bar.dart";
import "package:student_app/widgets/time_series_chart.dart";
import "package:student_app/providers/transaction_provider.dart";
import "package:student_app/models/user.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/utils.dart";

class BalanceHomeScreen extends StatefulWidget {
  final User currentUser;

  BalanceHomeScreen({
    Key key,
    this.currentUser,
  }) : super(key: key);

  @override
  _BalanceHomeScreenState createState() => _BalanceHomeScreenState(currentUser);
}

class _BalanceHomeScreenState extends State<BalanceHomeScreen> {
  GlobalKey<ScaffoldState> scaffoldKey;
  List<Transaction> transactions;

  final User currentUser;

  _BalanceHomeScreenState(this.currentUser);

  @override
  Widget build(BuildContext context) {
    transactions =
        Provider.of<TransactionProvider>(context, listen: false).transactions;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomizedAppBar(title: "Balance"),
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: CustomShapeClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration:
                      BoxDecoration(color: Theme.of(context).primaryColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                child: Text(
                  "Welcome,\n${currentUser.displayName}",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 120.0,
                  right: 25.0,
                  left: 25.0,
                  bottom: 10.0,
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 260.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Consumer<TransactionProvider>(
                      builder: (_, provider, __) {
                        final List<Transaction> _recentTransactions =
                            TransactionHelper.filterByDateRange(
                                provider.transactions, 7);
                        final String _netIncome = currencyFormat(
                          TransactionHelper.getNetIncome(_recentTransactions),
                        );

                        return Column(
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              margin: const EdgeInsets.only(top: 25.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      "HKD $_netIncome",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    child: Text(
                                      "Your net income in the last 7 days",
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 100,
                              margin: const EdgeInsets.only(top: 10.0),
                              child: TimeSeriesChart(
                                transactions: _recentTransactions,
                                tickerCount: 5,
                              ),
                            ),
                            Spacer(),
                            Container(
                              margin: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      "More Info",
                                      textAlign: TextAlign.end,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.chevron_right),
                                    onPressed: () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            BalanceStatisticScreen(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        "Your Recent Transactions",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: RaisedButton.icon(
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BalanceTimelineScreen(),
                              ),
                            ),
                            icon: Icon(Icons.info_outline),
                            label: Text("See More"),
                            elevation: 0.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: transactions.length == 0
                ? Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "You have no recorded transactions",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : Consumer<TransactionProvider>(
                    builder: (_, provider, __) {
                      transactions = provider.transactions;

                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: min(provider.length, 5),
                          itemBuilder: transactionCardBuilder);
                    },
                  ),
            margin: const EdgeInsets.symmetric(vertical: 10.0),
            height: 180,
          ),
        ],
      ),
    );
  }

  Widget transactionCardBuilder(BuildContext context, int index) {
    final Transaction transaction = transactions[index];

    return Container(
      height: 100,
      width: 160.0,
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) =>
              BalanceDetailScreen(currentTransaction: transaction),
        )),
        child: Card(
          elevation: 2.0,
          child: Column(
            children: <Widget>[
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: const Radius.circular(4.0),
                  topRight: const Radius.circular(4.0),
                ),
                child: Image(
                  height: 100,
                  width: 160,
                  fit: BoxFit.fill,
                  image: AssetImage(transaction.isIncome
                      ? "assets/images/income.jpg"
                      : "assets/images/expense.jpg"),
                ),
              ),
              ListTile(
                dense: true,
                title: Text(
                  transaction.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(right: 5.0),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var _path = Path();
    _path.lineTo(0.0, 390.0 - 200);
    _path.quadraticBezierTo(size.width / 2, 275, size.width, 390.0 - 200);
    _path.lineTo(size.width, 0.0);
    _path.close();
    return _path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
