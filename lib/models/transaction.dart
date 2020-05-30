import "package:flutter/foundation.dart";
import "package:student_app/enums.dart";

class Transaction {
  final String id;
  final String name;
  final String description;
  final String category;
  final double amount;
  final DateTime date;
  final bool isIncome;

  Transaction({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.category,
    @required this.amount,
    @required this.date,
    @required this.isIncome,
  });
}
