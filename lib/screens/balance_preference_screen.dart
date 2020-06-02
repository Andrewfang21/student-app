import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/widgets/radio_field.dart";
import "package:student_app/providers/transaction_provider.dart";

class BalancePreferenceScreen extends StatefulWidget {
  @override
  _BalancePreferenceScreenState createState() =>
      _BalancePreferenceScreenState();
}

class _BalancePreferenceScreenState extends State<BalancePreferenceScreen> {
  void _handleSave(BuildContext context) {
    Provider.of<TransactionProvider>(context, listen: false)
        .sortTransactionByRule(
      _transactionFields[_selectedTransactionField.index].text,
      _selectedTransactionOrder.index == 0 ? true : false,
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Display Preferences"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () => _handleSave(context),
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
          _buildListTitle("Sort by"),
          RadioField(
            radioList: _transactionFields,
            selectedRadio: _selectedTransactionField,
            horizontalMargin: 25.0,
          ),
          _buildListTitle("Sort order"),
          RadioField(
            radioList: _transactionOrders,
            selectedRadio: _selectedTransactionOrder,
            horizontalMargin: 25.0,
          )
        ],
      ),
    );
  }

  Widget _buildListTitle(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}

final List<RadioOption> _transactionFields = [
  RadioOption(index: 0, text: "Transaction Date"),
  RadioOption(index: 1, text: "Amount"),
  RadioOption(index: 2, text: "Type"),
];
final SelectRadio _selectedTransactionField = SelectRadio(index: 0);

final List<RadioOption> _transactionOrders = [
  RadioOption(index: 0, text: "Ascending"),
  RadioOption(index: 1, text: "Descending"),
];
final SelectRadio _selectedTransactionOrder = SelectRadio(index: 1);
