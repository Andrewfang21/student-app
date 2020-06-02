import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/providers/transaction_provider.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/models/transaction_form.dart";
import "package:student_app/utils.dart";
import "package:student_app/widgets/radio_field.dart";

class BalanceDetailScreen extends StatefulWidget {
  final Transaction currentTransaction;

  BalanceDetailScreen({
    this.currentTransaction,
  });

  @override
  _BalanceDetailScreenState createState() => _BalanceDetailScreenState();
}

class _BalanceDetailScreenState extends State<BalanceDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<RadioOption> _transactionCategoryList = [
    RadioOption(index: 0, text: "Income"),
    RadioOption(index: 1, text: "Expense"),
  ];

  List<TransactionButtonField> transactionCategories = [];
  TransactionFormField transactionName;
  TransactionFormField transactionDescription;
  TransactionFormField transactionAmount;
  Transaction _transaction;
  SelectRadio _selectedCategory;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    categories.forEach((text, icon) {
      transactionCategories.add(TransactionButtonField(icon: icon, text: text));
    });

    if (widget.currentTransaction == null) {
      transactionName = TransactionFormField(labelText: "Name");
      transactionDescription = TransactionFormField(labelText: "Description");
      transactionAmount = TransactionFormField(labelText: "Amount (in HKD)");
      _transaction = Transaction();
      _selectedCategory = SelectRadio(index: 0);
    } else {
      transactionName = TransactionFormField(
        initialValue: widget.currentTransaction.name,
        labelText: "Name",
      );
      transactionDescription = TransactionFormField(
        initialValue: widget.currentTransaction.description,
        labelText: "Description",
      );
      transactionAmount = TransactionFormField(
        initialValue: widget.currentTransaction.amount.toStringAsFixed(2),
        labelText: "Amount (in HKD)",
      );

      _transaction = Transaction()
        ..clone(
          widget.currentTransaction,
        );

      _selectedCategory = SelectRadio(
        index: widget.currentTransaction.isIncome ? 0 : 1,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    transactionName..focusNode.dispose()..controller.dispose();
    transactionDescription..focusNode.dispose()..controller.dispose();
    transactionAmount..focusNode.dispose()..controller.dispose();
  }

  Future<void> _saveForm(BuildContext context) async {
    final bool isValid = _formKey.currentState.validate();
    if (!isValid) return;

    _formKey.currentState.save();

    // TODO: use try catch
    setState(() => _isLoading = true);
    if (_transaction.id != null) {
      _transaction.setIsIncomeStatus =
          _selectedCategory.index == 0 ? true : false;

      if (widget.currentTransaction == null)
        Provider.of<TransactionProvider>(context, listen: false)
            .addTransaction(_transaction);
      else
        Provider.of<TransactionProvider>(context, listen: false)
            .editTransaction(_transaction.id, _transaction);
    }
    setState(() => _isLoading = false);

    Scaffold.of(context).showSnackBar(SnackBar(
      content: widget.currentTransaction == null
          ? Text("Transaction added successfully")
          : Text("Transaction edited successfully"),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.currentTransaction == null
            ? Text("Add Transaction")
            : Text("Edit Transaction"),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                _saveForm(context);
              },
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: transactionName.labelText,
                        ),
                        initialValue: transactionName.initialValue,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(transactionDescription.focusNode),
                        validator: (value) =>
                            value.isEmpty ? "Name should not be empty" : null,
                        onSaved: (value) => _transaction.setName = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: transactionDescription.labelText,
                        ),
                        initialValue: transactionDescription.initialValue,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        focusNode: transactionDescription.focusNode,
                        onSaved: (value) => _transaction.setDescription = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: transactionAmount.labelText,
                        ),
                        initialValue: transactionAmount.initialValue,
                        keyboardType: TextInputType.number,
                        focusNode: transactionAmount.focusNode,
                        validator: (value) {
                          if (value.isEmpty)
                            return "Amount should not be empty";
                          if (double.tryParse(value) == null)
                            return "Amount should be a valid number";
                          if (double.tryParse(value) <= 0)
                            return "Amount should be greater than zero";
                          return null;
                        },
                        onSaved: (value) =>
                            _transaction.setAmount = double.parse(value),
                      ),
                      _buildFieldTitle("Transaction date"),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            _buildTransactionDateButton(
                              Transaction.transactionDateFormat
                                  .format(_transaction.date),
                              Icons.date_range,
                              () async {
                                final DateTime updatedDate =
                                    await _showDatePicker(context);
                                if (updatedDate != null)
                                  _updateDate(updatedDate);
                              },
                            ),
                            _buildTransactionDateButton(
                              Transaction.transactionTimeFormat
                                  .format(_transaction.date),
                              Icons.access_time,
                              () async {
                                final TimeOfDay updatedTime =
                                    await _showTimePicker(context);
                                if (updatedTime != null)
                                  _updateTime(updatedTime);
                              },
                            ),
                          ],
                        ),
                      ),
                      _buildFieldTitle("Category"),
                      DropdownButtonFormField(
                        hint: _iconWithText(
                          _transaction.category,
                          getCategoryIcon(_transaction.category),
                        ),
                        items: transactionCategories
                            .map((TransactionButtonField category) {
                          return DropdownMenuItem<TransactionButtonField>(
                            value: category,
                            child: _iconWithText(category.text, category.icon),
                          );
                        }).toList(),
                        onChanged: (TransactionButtonField selectedCategory) =>
                            setState(
                          () => _transaction.category = selectedCategory.text,
                        ),
                      ),
                      _buildFieldTitle("Status"),
                      RadioField(
                        radioList: _transactionCategoryList,
                        selectedRadio: _selectedCategory,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _iconWithText(String title, IconData icon) {
    return Row(
      children: <Widget>[
        Icon(icon),
        SizedBox(width: 10.0),
        Text(title, style: TextStyle(color: Colors.black)),
      ],
    );
  }

  Widget _buildTransactionDateButton(
    String text,
    IconData iconData,
    Function onPressHandler,
  ) {
    return FlatButton(
      child: Row(
        children: <Widget>[
          Icon(iconData),
          Container(
            margin: const EdgeInsets.only(left: 5.0),
            child: SizedBox(
              width: 80.0,
              child: Text(text),
            ),
          ),
          Container(child: Icon(Icons.chevron_right))
        ],
      ),
      color: Colors.grey[300],
      onPressed: onPressHandler,
    );
  }

  Widget _buildFieldTitle(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 15.0),
      child: Text(
        title,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
    );
  }

  void _updateDate(DateTime updatedDate) {
    setState(
      () => _transaction.setTransactionDate = updatedDate,
    );
  }

  void _updateTime(TimeOfDay updatedTime) {
    setState(
      () => _transaction.setTransactionTime = updatedTime,
    );
  }

  Future<DateTime> _showDatePicker(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: _transaction.date,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
  }

  Future<TimeOfDay> _showTimePicker(BuildContext context) {
    return showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _transaction.date.hour,
        minute: _transaction.date.minute,
      ),
    );
  }
}
