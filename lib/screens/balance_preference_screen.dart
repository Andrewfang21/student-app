import "package:flutter/material.dart";

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
          buildListTitle("Sort by"),
          buildRadioButton(_transactionFields, _selectedTransactionField),
          buildListTitle("Sort order"),
          buildRadioButton(_transactionOrders, _selectedTransactionOrder),
        ],
      ),
    );
  }

  Widget buildListTitle(String title) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 5.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 20),
      ),
    );
  }

  Widget buildRadioButton(
      List<RadioItem> radioList, SelectedRadio selectedField) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: radioList
            .map((RadioItem item) => Row(
                  children: <Widget>[
                    Radio(
                      value: item.index,
                      groupValue: selectedField.index,
                      onChanged: (int value) {
                        setState(() => selectedField.setIndex(value));
                      },
                    ),
                    Text(item.text),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

class RadioItem {
  final int index;
  final String text;

  RadioItem({
    @required this.index,
    @required this.text,
  });
}

class SelectedRadio {
  int index;
  SelectedRadio({@required this.index});

  void setIndex(int newIndex) => this.index = newIndex;
}

final List<RadioItem> _transactionFields = [
  RadioItem(index: 1, text: "Transaction Date"),
  RadioItem(index: 2, text: "Amount"),
  RadioItem(index: 3, text: "Type"),
];
final SelectedRadio _selectedTransactionField = SelectedRadio(index: 1);

final List<RadioItem> _transactionOrders = [
  RadioItem(index: 1, text: "Descending"),
  RadioItem(index: 2, text: "Ascending"),
];
final SelectedRadio _selectedTransactionOrder = SelectedRadio(index: 1);
