import "package:flutter/material.dart";
import "package:charts_flutter/flutter.dart" as charts;
import "package:student_app/models/transaction.dart";
import "package:student_app/utils.dart";

class TimeSeriesTransaction {
  final DateTime date;
  double amount;

  TimeSeriesTransaction({@required this.date, @required this.amount});

  void addAmount(double anotherAmount) => this.amount += anotherAmount;
}

class TimeSeriesChart extends StatelessWidget {
  final List<charts.Series> seriesList;

  TimeSeriesChart(this.seriesList);

  static const String EXPENSE = "Expense";
  static const String INCOME = "Income";

  static List<TimeSeriesTransaction> serializeTransaction(
      List<Transaction> transactions, String status) {
    if (status == EXPENSE) {
      List<TimeSeriesTransaction> expenses = [];
      transactions.forEach((transaction) {
        if (transaction.isIncome) return;
        if (expenses.isEmpty)
          expenses.add(TimeSeriesTransaction(
            date: transaction.date,
            amount: transaction.amount,
          ));
        else if (expenses.isNotEmpty &&
            !isSameDate(expenses[expenses.length - 1].date, transaction.date))
          expenses.add(TimeSeriesTransaction(
              date: transaction.date, amount: transaction.amount));
        else
          expenses[expenses.length - 1].addAmount(transaction.amount);
      });

      return expenses;
    }

    List<TimeSeriesTransaction> income = [];
    transactions.forEach((transaction) {
      if (!transaction.isIncome) return;
      if (income.isEmpty)
        income.add(TimeSeriesTransaction(
          date: transaction.date,
          amount: transaction.amount,
        ));
      else if (income.isNotEmpty &&
          !isSameDate(income[income.length - 1].date, transaction.date))
        income.add(TimeSeriesTransaction(
            date: transaction.date, amount: transaction.amount));
      else
        income[income.length - 1].addAmount(transaction.amount);
    });

    return income;
  }

  static List<charts.Series<TimeSeriesTransaction, DateTime>> _toList(
    List<TimeSeriesTransaction> income,
    List<TimeSeriesTransaction> expenses,
  ) {
    return [
      charts.Series<TimeSeriesTransaction, DateTime>(
        id: "Income",
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (TimeSeriesTransaction transactions, _) => transactions.date,
        measureFn: (TimeSeriesTransaction transactions, _) =>
            transactions.amount,
        data: income,
      ),
      charts.Series<TimeSeriesTransaction, DateTime>(
        id: "Expense",
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (TimeSeriesTransaction transactions, _) => transactions.date,
        measureFn: (TimeSeriesTransaction transactions, _) =>
            transactions.amount,
        data: expenses,
      ),
    ];
  }

  factory TimeSeriesChart.withTransactions(List<Transaction> transactions) {
    transactions.sort((x, y) => x.date.compareTo(y.date));

    final List<TimeSeriesTransaction> expenses =
        serializeTransaction(transactions, EXPENSE);
    final List<TimeSeriesTransaction> income =
        serializeTransaction(transactions, INCOME);

    return TimeSeriesChart(_toList(income, expenses));
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      seriesList,
      animate: true,
      domainAxis: charts.EndPointsTimeAxisSpec(),
    );
  }
}
