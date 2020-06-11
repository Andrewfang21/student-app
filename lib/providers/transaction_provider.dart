import "package:flutter/material.dart";
import "package:student_app/services/transaction_service.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/utils.dart";

class TransactionProvider with ChangeNotifier {
  List<Transaction> get transactions => [..._transactions];

  static String currentRule = "Transaction Date";
  static bool isAscending = false;

  int get length => _transactions.length;

  List<Transaction> getTransactionsByDateRange(DateTime left, DateTime right) {
    return [..._transactions]
        .where(
          (transaction) =>
              transaction.date.isAfter(left) &&
              transaction.date.isBefore(right.add(Duration(days: 1))),
        )
        .toList();
  }

  Future<void> addTransaction(Transaction transaction) async {
    await TransactionService.createTransaction(transaction);

    // _transactions.add(transaction);
    // sortTransactionByRule(currentRule, isAscending);

    notifyListeners();
  }

  void editTransaction(String id, Transaction updatedTransaction) {
    final index = _transactions.indexWhere(
      (transaction) => transaction.id == id,
    );
    if (index >= 0) {
      _transactions[index] = updatedTransaction;
      sortTransactionByRule(currentRule, isAscending);

      notifyListeners();
    }
  }

  void deleteTransaction(String id) {
    _transactions.removeWhere((transaction) => transaction.id == id);
    notifyListeners();
  }

  void sortTransactionByRule(String rule, bool isAscending) {
    if (rule == "Transaction Date") {
      isAscending
          ? _transactions.sort((x, y) => x.date.isBefore(y.date) ? -1 : 1)
          : _transactions.sort((x, y) => x.date.isBefore(y.date) ? 1 : -1);
    } else if (rule == "Amount") {
      isAscending
          ? _transactions.sort((x, y) => x.amount.compareTo(y.amount))
          : _transactions.sort((x, y) => y.amount.compareTo(x.amount));
    } else if (rule == "Type") {
      isAscending
          ? _transactions.sort((x, y) =>
              (x.isIncome && y.isIncome || !x.isIncome && !y.isIncome)
                  ? 0
                  : x.isIncome && !y.isIncome ? 1 : -1)
          : _transactions.sort((x, y) =>
              (x.isIncome && y.isIncome || !x.isIncome && !y.isIncome)
                  ? 0
                  : x.isIncome && !y.isIncome ? -1 : 1);
    }

    currentRule = rule;
    isAscending = isAscending;

    notifyListeners();
  }
}

List<Transaction> _transactions = [
  Transaction(
    id: "1",
    name: "Laptop",
    description: "Asus Laptop",
    category: "Entertainment",
    amount: 3000.0,
    date: TimeFormatHelper.dateAndTimeFormatter().parse("2020-06-01 21:40"),
    isIncome: false,
  ),
  Transaction(
    id: "2",
    name: "Computer",
    description: "Alienware",
    category: "Entertainment",
    amount: 2500.0,
    date: TimeFormatHelper.dateAndTimeFormatter().parse("2020-05-31 11:40"),
    isIncome: false,
  ),
  Transaction(
    id: "3",
    name: "Part-time Job",
    description: "Waiter Job",
    category: "Work",
    amount: 1500.0,
    date: TimeFormatHelper.dateAndTimeFormatter().parse("2020-05-30 20:40"),
    isIncome: true,
  ),
  Transaction(
    id: "4",
    name: "Internship",
    description: "Internship at Google",
    category: "Work",
    amount: 25000.0,
    date: TimeFormatHelper.dateAndTimeFormatter().parse("2020-05-29 11:20"),
    isIncome: true,
  ),
  Transaction(
    id: "5",
    name: "Goobne",
    description: "Lunch",
    category: "Meal",
    amount: 120.0,
    date: TimeFormatHelper.dateAndTimeFormatter().parse("2020-05-28 11:35"),
    isIncome: false,
  ),
  Transaction(
    id: "6",
    name: "Dimsum",
    description: "Dinner",
    category: "Meal",
    amount: 220.0,
    date: TimeFormatHelper.dateAndTimeFormatter().parse("2020-05-27 23:35"),
    isIncome: false,
  ),
  Transaction(
    id: "7",
    name: "PS4",
    description: "Buy PS4",
    category: "Entertainment",
    amount: 3120.0,
    date: TimeFormatHelper.dateAndTimeFormatter().parse("2020-05-27 10:35"),
    isIncome: false,
  ),
];
