import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/providers/user_provider.dart";
import "package:student_app/screens/transaction_detail_screen.dart";
import "package:student_app/widgets/transaction_form.dart";

class TransactionCreateScreen extends StatelessWidget {
  final CustomForm _form = CustomForm();

  @override
  Widget build(BuildContext context) {
    final TransactionModel currentTransaction = TransactionModel(
      creatorId:
          Provider.of<UserProvider>(context, listen: false).currentUserID,
    );

    return TransactionDetailScreen(
      context: "Add",
      form: _form,
      transaction: currentTransaction,
    );
  }
}
