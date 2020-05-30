import "package:flutter/material.dart";
import "package:student_app/models/transaction.dart";

class BalanceDetailScreen extends StatelessWidget {
  final Transaction currentTransaction;

  const BalanceDetailScreen({
    @required this.currentTransaction,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Transaction"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                print("save button pressed");
                Navigator.of(context).pop();
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: "Name"),
                  initialValue: currentTransaction.name,
                  textInputAction: TextInputAction.next,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Description"),
                  initialValue: currentTransaction.description,
                  keyboardType: TextInputType.multiline,
                  maxLines: 4,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: "Amount"),
                  initialValue: currentTransaction.amount.toStringAsFixed(2),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
    );
  }
}
