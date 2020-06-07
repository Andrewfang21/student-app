import "dart:core";

import "package:flutter/material.dart";
import "package:intl/intl.dart";
import "package:student_app/widgets/time_series_chart.dart";
import "package:student_app/models/transaction.dart";

String parseEnumString(String page) {
  return page.split(".")[1];
}

bool isSame(String pageName, String pageNameEnum) {
  return pageName == parseEnumString(pageNameEnum);
}

bool isSameDate(DateTime x, DateTime y) {
  return x.year == y.year && x.month == y.month && x.day == y.day;
}

bool isZero(double x) {
  const double eps = 1e-5;
  return (x - 0).abs() <= eps;
}

const Map<String, dynamic> categories = {
  "Entertainment": Icons.gamepad,
  "Gift": Icons.card_giftcard,
  "Hostel": Icons.hotel,
  "Meal": Icons.restaurant,
  "School": Icons.school,
  "Shopping": Icons.shopping_cart,
  "Transportation": Icons.directions_subway,
  "Work": Icons.work,
  "Others": Icons.folder,
};

const Map<String, dynamic> taskCategories = {
  "Meeting": Icons.contacts,
  "Personal": Icons.person,
  "Study": Icons.school,
  "Work": Icons.work,
  "Others": Icons.folder,
};

IconData getIconBasedOnCategory(String str) {
  return categories[str];
}

String currencyFormat(double value) {
  return NumberFormat("#,##0.00").format(value);
}

class TransactionHelper {
  static const String EXPENSE = "Expense";
  static const String INCOME = "Income";

  static List<dynamic> filterByStatus(
    List<Transaction> transactions,
    String status,
  ) {
    List<Transaction> selectedTransactions = [];

    transactions.forEach((Transaction transaction) {
      if (status == TransactionHelper.EXPENSE && !transaction.isIncome ||
          status == TransactionHelper.INCOME && transaction.isIncome) {
        selectedTransactions.add(transaction);
      }
    });
    return selectedTransactions;
  }

  static List<Transaction> filterByDateRange(
    List<Transaction> transactions,
    int days,
  ) {
    return transactions
        .where(
          (Transaction transaction) =>
              transaction.date.isAfter(
                DateTime.now().subtract(Duration(days: days)),
              ) &&
              transaction.date.isBefore(
                DateTime.now().add(Duration(days: 1)),
              ),
        )
        .toList();
  }

  static List<TimeSeriesTransaction> getSerializedTransactions(
    List<Transaction> transactions,
  ) {
    var transactionMap = {};
    transactions.forEach((Transaction transaction) {
      DateTime key = transaction.date;
      if (transactionMap.containsKey(key))
        transactionMap[key] += transaction.amount;
      else
        transactionMap[key] = transaction.amount;
    });

    List<TimeSeriesTransaction> serializedTransactions = transactionMap.entries
        .map(
          (entry) =>
              TimeSeriesTransaction(date: entry.key, amount: entry.value),
        )
        .toList();
    return serializedTransactions;
  }

  static double getAmountByCategory(
    List<Transaction> transactions,
    String category,
  ) {
    double amount = .0;
    transactions.forEach((Transaction transaction) {
      if (transaction.category == category) amount += transaction.amount;
    });
    return amount;
  }

  static List<Transaction> getTransactionsByStatus(
      List<Transaction> transactions, String status) {
    return [...transactions].where((Transaction transaction) {
      return (status == INCOME && transaction.isIncome ||
          status == EXPENSE && !transaction.isIncome);
    }).toList();
  }

  static double getIncome(List<Transaction> transactions) {
    double income = .0;
    transactions.forEach((Transaction transaction) =>
        transaction.isIncome ? income += transaction.amount : null);

    return income;
  }

  static double getExpense(List<Transaction> transactions) {
    double expense = .0;
    transactions.forEach((Transaction transaction) =>
        transaction.isIncome ? null : expense += transaction.amount);

    return expense;
  }

  static double getNetIncome(List<Transaction> transactions) {
    return getIncome(transactions) - getExpense(transactions);
  }
}

class TimeFormatHelper {
  static String formatToDayAndDate(DateTime date) {
    return DateFormat("E, yyyy-MM-dd").format(date);
  }

  static String formatToTimeOnly(DateTime date) {
    return DateFormat.Hm().format(date);
  }

  static String formatToDateOnlyMinimized(DateTime date) {
    return DateFormat("MMM dd, yy").format(date);
  }

  static String formatToDateOnly(DateTime date) {
    return DateFormat("dd-MM-yyyy").format(date);
  }

  static DateFormat dateAndTimeFormatter() {
    return DateFormat("yyyy-MM-dd hh:mm");
  }
}
