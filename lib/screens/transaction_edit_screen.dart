import "package:flutter/material.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/screens/transaction_detail_screen.dart";
import "package:student_app/widgets/transaction_form.dart";

class TransactionEditScreen extends StatelessWidget {
  final TransactionModel currentTransaction;
  final CustomForm _form;

  TransactionEditScreen({
    @required this.currentTransaction,
  }) : _form = CustomForm();

  @override
  Widget build(BuildContext context) {
    return TransactionDetailScreen(
      context: "Edit",
      form: _form,
      transaction: currentTransaction,
    );
  }
}
