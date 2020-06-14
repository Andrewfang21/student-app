import "package:flutter/material.dart";
import "package:charts_flutter/flutter.dart" as charts;
import "package:student_app/models/transaction.dart";
import "package:student_app/utils.dart";

class PieChart extends StatelessWidget {
  final List<TransactionModel> transactions;
  final double totalAmount;

  const PieChart({
    @required this.transactions,
    @required this.totalAmount,
  });

  List<charts.Series<PieChartTransaction, String>> _buildPieChart() {
    List<PieChartTransaction> list = [];
    transactionCategories.keys.forEach((String category) {
      list.add(
        PieChartTransaction(
          category: category,
          percentage:
              TransactionHelper.getAmountByCategory(transactions, category) /
                  totalAmount *
                  100.0,
        ),
      );
    });

    return [
      charts.Series<PieChartTransaction, String>(
        id: "Transaction",
        domainFn: (PieChartTransaction transaction, _) => transaction.category,
        measureFn: (PieChartTransaction transaction, _) =>
            transaction.percentage,
        labelAccessorFn: (PieChartTransaction transaction, _) =>
            "${transaction.percentage.toStringAsFixed(2)}%",
        data: list,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return charts.PieChart(
      _buildPieChart(),
      animate: true,
      behaviors: [
        charts.DatumLegend(
          position: charts.BehaviorPosition.bottom,
          outsideJustification: charts.OutsideJustification.middle,
          horizontalFirst: false,
          desiredMaxRows: 3,
          cellPadding: const EdgeInsets.only(right: 10.0, bottom: 4.0),
          entryTextStyle: charts.TextStyleSpec(
            color: charts.MaterialPalette.cyan.shadeDefault,
            fontSize: 12,
          ),
        )
      ],
      defaultRenderer: charts.ArcRendererConfig(
        arcWidth: 50,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.outside,
          ),
        ],
      ),
    );
  }
}

class PieChartTransaction {
  final String category;
  final double percentage;

  PieChartTransaction({
    @required this.category,
    @required this.percentage,
  });
}
