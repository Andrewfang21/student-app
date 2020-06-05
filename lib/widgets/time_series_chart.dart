import "package:flutter/material.dart";
import "package:charts_flutter/flutter.dart" as charts;
import "package:student_app/models/transaction.dart";
import "package:student_app/utils.dart";

class TimeSeriesChart extends StatelessWidget {
  final List<Transaction> transactions;
  final int tickerCount;

  const TimeSeriesChart({
    @required this.transactions,
    @required this.tickerCount,
  });

  List<charts.Series<TimeSeriesTransaction, DateTime>> _buildSeriesList() {
    List<charts.Series<TimeSeriesTransaction, DateTime>> list = []
      ..add(
        charts.Series<TimeSeriesTransaction, DateTime>(
            id: TransactionHelper.INCOME,
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (TimeSeriesTransaction transaction, _) =>
                transaction.date,
            measureFn: (TimeSeriesTransaction transaction, _) =>
                transaction.amount,
            data: TransactionHelper.getSerializedTransactions(
              TransactionHelper.filterByStatus(
                  transactions, TransactionHelper.INCOME),
            )),
      )
      ..add(
        charts.Series<TimeSeriesTransaction, DateTime>(
            id: TransactionHelper.EXPENSE,
            colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
            domainFn: (TimeSeriesTransaction transaction, _) =>
                transaction.date,
            measureFn: (TimeSeriesTransaction transaction, _) =>
                transaction.amount,
            data: TransactionHelper.getSerializedTransactions(
              TransactionHelper.filterByStatus(
                  transactions, TransactionHelper.EXPENSE),
            )),
      );

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return charts.TimeSeriesChart(
      _buildSeriesList(),
      animate: true,
      domainAxis: charts.DateTimeAxisSpec(
        tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
        tickFormatterSpec: charts.AutoDateTimeTickFormatterSpec(
          day: charts.TimeFormatterSpec(
            format: 'dd MMM',
            transitionFormat: 'dd MMM',
          ),
        ),
        showAxisLine: true,
      ),
      primaryMeasureAxis: charts.NumericAxisSpec(
        tickProviderSpec: charts.BasicNumericTickProviderSpec(
          desiredTickCount: tickerCount,
        ),
        showAxisLine: true,
      ),
    );
  }
}

class TimeSeriesTransaction {
  final DateTime date;
  final double amount;

  TimeSeriesTransaction({
    @required this.date,
    @required this.amount,
  });
}
