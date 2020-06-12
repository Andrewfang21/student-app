import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/providers/user_provider.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/models/transaction_form.dart";
import "package:student_app/services/transaction_service.dart";
import "package:student_app/widgets/date_form_button.dart";
import "package:student_app/widgets/icon_with_text.dart";
import "package:student_app/widgets/radio_field.dart";
import "package:student_app/utils.dart";

class BalanceDetailScreen extends StatefulWidget {
  final Transaction currentTransaction;

  BalanceDetailScreen({
    this.currentTransaction,
  });

  @override
  _BalanceDetailScreenState createState() => _BalanceDetailScreenState();
}

class _BalanceDetailScreenState extends State<BalanceDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<RadioOption> _transactionCategoryList = [
    RadioOption(index: 0, text: "Income"),
    RadioOption(index: 1, text: "Expense"),
  ];

  CustomFormField transactionName;
  CustomFormField transactionDescription;
  CustomFormField transactionAmount;
  Transaction _transaction;
  SelectRadio _selectedCategory;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    transactionName = CustomFormField(
      initialValue: widget.currentTransaction?.name,
      labelText: "Name",
    );
    transactionDescription = CustomFormField(
      initialValue: widget.currentTransaction?.description,
      labelText: "Description",
    );
    transactionAmount = CustomFormField(
      initialValue: widget.currentTransaction?.amount?.toStringAsFixed(2),
      labelText: "Amount (in HKD)",
    );

    _transaction = Transaction(
      creatorId:
          Provider.of<UserProvider>(context, listen: false).currentUserID,
    );
    if (widget.currentTransaction != null)
      _transaction.clone(widget.currentTransaction);

    _selectedCategory = widget.currentTransaction != null
        ? SelectRadio(index: widget.currentTransaction.isIncome ? 0 : 1)
        : SelectRadio(index: 0);
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

    setState(() => _isLoading = true);

    String snackBarMessage = "";
    try {
      _transaction.setIsIncomeStatus =
          _selectedCategory.index == 0 ? true : false;

      if (widget.currentTransaction == null) {
        await TransactionService.createTransaction(_transaction);
        snackBarMessage = "Transaction added successfully";
      } else {
        await TransactionService.updateTransaction(_transaction);
        snackBarMessage = "Transaction updated successfully";
      }
    } catch (e) {
      print(e.toString());
      snackBarMessage = "Error occurs, please try again later.";
    }

    setState(() => _isLoading = false);

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(snackBarMessage),
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
                      FormFieldTitle(text: "Transaction Date"),
                      DateFormButton(
                        date: _transaction.date,
                        onPressDateHandler: () async {
                          final DateTime newDate = await showDatePicker(
                            context: context,
                            initialDate: _transaction.date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (newDate != null) {
                            setState(
                              () => _transaction.setTransactionDate = newDate,
                            );
                          }
                        },
                        onPressTimeHandler: () async {
                          final TimeOfDay newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: _transaction.date.hour,
                                  minute: _transaction.date.minute));
                          if (newTime != null) {
                            setState(
                              () => _transaction.setTransactionTime = newTime,
                            );
                          }
                        },
                      ),
                      FormFieldTitle(text: "Category"),
                      DropdownButtonFormField(
                        hint: IconWithTextWidget(
                          child: IconWithText(
                            text: _transaction.category,
                            icon: transactionCategories[_transaction.category],
                          ),
                          marginWidth: 10.0,
                        ),
                        items: transactionCategories.entries
                            .map((e) => DropdownMenuItem<String>(
                                  value: e.key,
                                  child: IconWithTextWidget(
                                      child: IconWithText(
                                        text: e.key,
                                        icon: transactionCategories[e.key],
                                      ),
                                      marginWidth: 10.0),
                                ))
                            .toList(),
                        onChanged: (String e) {
                          setState(() => _transaction.category = e);
                        },
                      ),
                      FormFieldTitle(text: "Status"),
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
}
