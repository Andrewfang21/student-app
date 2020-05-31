import "package:flutter/material.dart";
import "package:intl/intl.dart";

class Transaction with ChangeNotifier {
  String id;
  String name;
  String description;
  String category;
  double amount;
  DateTime date;
  bool isIncome;

  static DateFormat transactionDateFormat = DateFormat("dd-MM-yyyy");
  static DateFormat transactionTimeFormat = DateFormat.Hm();
  static DateFormat transactionTimestampFormat = DateFormat("yyyy-MM-dd hh:mm");
  static DateFormat transactionDateAndDayFormat = DateFormat("E, yyyy-MM-dd");
  static NumberFormat currencyFormat = NumberFormat("#,##0.00");

  Transaction({
    this.id,
    this.name,
    this.description,
    this.category,
    this.amount,
    this.date,
    this.isIncome,
  });

  void clone(Transaction transaction) {
    this.id = transaction.id;
    this.name = transaction.name;
    this.description = transaction.description;
    this.category = transaction.category;
    this.amount = transaction.amount;
    this.date = transaction.date;
    this.isIncome = transaction.isIncome;
  }

  set updateName(String name) => this.name = name;
  set updateAmount(double amount) => this.amount = amount;
  set updateDescription(String description) => this.description = description;
  set updateCategory(String category) => this.category = category;
  set updateTransactionDate(DateTime updatedDate) => this.date = DateTime(
        updatedDate.year,
        updatedDate.month,
        updatedDate.day,
        this.date.hour,
        this.date.minute,
      );
  set updateTransactionTime(TimeOfDay updatedTime) => this.date = DateTime(
        this.date.year,
        this.date.hour,
        this.date.day,
        updatedTime.hour,
        updatedTime.minute,
      );
  set updateIsIncomeStatus(bool isIncome) => this.isIncome = isIncome;
}
