import "package:flutter/material.dart";
import "package:student_app/widgets/radio_field.dart";

class BalancePreferenceScreen extends StatefulWidget {
  @override
  _BalancePreferenceScreenState createState() =>
      _BalancePreferenceScreenState();
}

class _BalancePreferenceScreenState extends State<BalancePreferenceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Display Preferences"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              print("Button is pressed");
              Navigator.of(context).pop();
            },
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
  RadioOption(index: 1, text: "Transaction Date"),
  RadioOption(index: 2, text: "Amount"),
  RadioOption(index: 3, text: "Type"),
];
final SelectRadio _selectedTransactionField = SelectRadio(index: 1);

final List<RadioOption> _transactionOrders = [
  RadioOption(index: 1, text: "Descending"),
  RadioOption(index: 2, text: "Ascending"),
];
final SelectRadio _selectedTransactionOrder = SelectRadio(index: 1);
