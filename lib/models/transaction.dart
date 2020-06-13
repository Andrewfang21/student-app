import "package:flutter/material.dart";

class Transaction with ChangeNotifier {
  String id;
  String name;
  String description;
  String category;
  double amount;
  DateTime date;
  bool isIncome;
  String creatorId;

  Transaction({
    name,
    description,
    category,
    amount,
    date,
    isIncome,
    @required this.creatorId,
  })  : this.name = name ?? "",
        this.description = description ?? "",
        this.category = category ?? "Entertainment",
        this.amount = amount ?? 0.0,
        this.date = date ?? DateTime.now(),
        this.isIncome = isIncome ?? false;

  Transaction.fromJson(String id, Map<String, dynamic> json) {
    if (json != null) {
      this.id = id;
      this.name = json["name"];
      this.description = json["description"];
      this.category = json["category"];
      this.amount = json["amount"];
      this.date = DateTime.parse(json["date"].toDate().toString());
      this.isIncome = json["isIncome"];
      this.creatorId = json["creatorId"];
    }
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "category": category,
        "amount": amount,
        "date": date,
        "isIncome": isIncome,
        "creatorId": creatorId,
      };

  void clone(Transaction transaction) {
    this.id = transaction.id;
    this.name = transaction.name;
    this.description = transaction.description;
    this.category = transaction.category;
    this.amount = transaction.amount;
    this.date = transaction.date;
    this.isIncome = transaction.isIncome;
    this.creatorId = transaction.creatorId;
  }

  set setName(String name) => this.name = name;
  set setAmount(double amount) => this.amount = amount;
  set setDescription(String description) => this.description = description;
  set setCategory(String category) => this.category = category;
  set setTransactionDate(DateTime newDate) => this.date = DateTime(
        newDate.year,
        newDate.month,
        newDate.day,
        this.date.hour,
        this.date.minute,
      );
  set setTransactionTime(TimeOfDay newTime) => this.date = DateTime(
        this.date.year,
        this.date.month,
        this.date.day,
        newTime.hour,
        newTime.minute,
      );
  set setIsIncomeStatus(bool isIncome) => this.isIncome = isIncome;
}
