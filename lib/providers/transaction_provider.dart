import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:student_app/models/transaction.dart";

class TransactionProvider with ChangeNotifier {
  List<Transaction> get transactions => [..._transactions];

  int get transactionsCount => _transactions.length;

  void editTransaction(String id, Transaction updatedTransaction) {
    final index = _transactions.indexWhere(
      (transaction) => transaction.id == id,
    );
    if (index >= 0) {
      _transactions[index] = updatedTransaction;
      notifyListeners();
    }
  }
}

final DateFormat dateFormat = Transaction.transactionTimestampFormat;

List<Transaction> _transactions = [
  Transaction(
    id: "1",
    name: "Laptop",
    description: "Asus Laptop",
    category: "Entertainment",
    amount: 3000.0,
    date: dateFormat.parse("2020-04-19 21:40"),
    isIncome: false,
  ),
  Transaction(
    id: "2",
    name: "Computer",
    description: "Alienware",
    category: "Entertainment",
    amount: 25000.0,
    date: dateFormat.parse("2020-02-9 11:40"),
    isIncome: false,
  ),
  Transaction(
    id: "3",
    name: "Part-time Job",
    description: "Waiter Job",
    category: "Work",
    amount: 15000.0,
    date: dateFormat.parse("2020-01-9 20:40"),
    isIncome: true,
  ),
  Transaction(
    id: "4",
    name: "Internship",
    description: "Internship at Google",
    category: "Work",
    amount: 25000.0,
    date: dateFormat.parse("2019-12-18 11:20"),
    isIncome: true,
  ),
  Transaction(
    id: "5",
    name: "Goobne",
    description: "Lunch",
    category: "Meal",
    amount: 120.0,
    date: dateFormat.parse("2019-11-19 11:35"),
    isIncome: false,
  ),
  Transaction(
    id: "6",
    name: "Dimsum",
    description: "Dinner",
    category: "Meal",
    amount: 220.0,
    date: dateFormat.parse("2019-11-17 23:35"),
    isIncome: false,
  ),
  Transaction(
    id: "7",
    name: "PS4",
    description: "Buy PS4",
    category: "Entertainment",
    amount: 3120.0,
    date: dateFormat.parse("2019-11-15 10:35"),
    isIncome: false,
  ),
];
