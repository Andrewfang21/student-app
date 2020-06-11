import "package:flutter/material.dart";
import "package:uuid/uuid.dart";

class Transaction with ChangeNotifier {
  String id;
  String name;
  String description;
  String category;
  double amount;
  DateTime date;
  bool isIncome;

  Transaction({
    id,
    name,
    description,
    category,
    amount,
    date,
    isIncome,
  })  : this.id = id ?? Uuid().v4(),
        this.name = name ?? "",
        this.description = description ?? "",
        this.category = category ?? "Entertainment",
        this.amount = amount ?? 0.0,
        this.date = date ?? DateTime.now(),
        this.isIncome = isIncome ?? false;

  Transaction.fromJson(Map<String, dynamic> json) {
    if (json != null) {
      id = json["id"];
      name = json["name"];
      description = json["description"];
      category = json["category"];
      amount = json["amount"];
      date = DateTime.parse(json["date"].toDate().toString());
      isIncome = json["isIncome"];
    }
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "category": category,
        "amount": amount,
        "date": date,
        "isIncome": isIncome,
      };

  void clone(Transaction transaction) {
    this.id = transaction.id;
    this.name = transaction.name;
    this.description = transaction.description;
    this.category = transaction.category;
    this.amount = transaction.amount;
    this.date = transaction.date;
    this.isIncome = transaction.isIncome;
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
        this.date.hour,
        this.date.day,
        newTime.hour,
        newTime.minute,
      );
  set setIsIncomeStatus(bool isIncome) => this.isIncome = isIncome;
}
