import "package:flutter/material.dart";
import "package:student_app/models/transaction.dart";
import "package:student_app/services/transaction_service.dart";
import "package:student_app/widgets/date_form_button.dart";
import "package:student_app/widgets/icon_with_text.dart";
import "package:student_app/widgets/radio_field.dart";
import "package:student_app/widgets/transaction_form.dart";
import "package:student_app/utils.dart";

class TransactionDetailScreen extends StatefulWidget {
  final CustomForm form;
  final TransactionModel transaction;
  final String context;

  const TransactionDetailScreen({
    @required this.context,
    @required this.form,
    @required this.transaction,
  });

  @override
  _TransactionDetailScreenState createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final List<RadioOption> _transactionCategoryList = [
    RadioOption(index: 0, text: "Income"),
    RadioOption(index: 1, text: "Expense"),
  ];

  SelectRadio _selectedCategory;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedCategory = SelectRadio(index: widget.transaction.isIncome ? 0 : 1);
  }

  Future<void> onSaveForm(BuildContext context) async {
    final bool isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }

    _formKey.currentState.save();
    setState(() => _isLoading = true);

    String snackBarMessage = "";
    try {
      widget.transaction.setIsIncomeStatus =
          _selectedCategory.index == 0 ? true : false;

      if (widget.context == "Add") {
        await TransactionService.createTransaction(widget.transaction);
        snackBarMessage = "Transaction added successfully";
      } else {
        await TransactionService.updateTransaction(widget.transaction);
        snackBarMessage = "Transaction updated successfully";
      }
    } catch (e) {
      snackBarMessage = e.toString();
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
        title: Text("${widget.context} Transaction"),
        actions: <Widget>[
          Builder(
              builder: (context) => IconButton(
                    icon: Icon(Icons.save),
                    onPressed: _isLoading
                        ? null
                        : () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            onSaveForm(context);
                          },
                  ))
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 10.0,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                          decoration: InputDecoration(
                            labelText: widget.form.nameLabelText,
                          ),
                          initialValue: widget.transaction.name,
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) => FocusScope.of(context)
                              .requestFocus(widget.form.descriptionFocusNode),
                          validator: (String value) =>
                              value.isEmpty ? "Name should not be empty" : null,
                          onSaved: (String value) {
                            widget.transaction.setName = value;
                          }),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: widget.form.descriptionLabelText,
                        ),
                        initialValue: widget.transaction.description,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        focusNode: widget.form.descriptionFocusNode,
                        onSaved: (String value) =>
                            widget.transaction.setDescription = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: widget.form.amountLabelText,
                        ),
                        initialValue:
                            widget.transaction.amount.toStringAsFixed(2),
                        keyboardType: TextInputType.number,
                        focusNode: widget.form.amountFocusNode,
                        validator: (String value) {
                          if (value.isEmpty)
                            return "Amount should not be empty";
                          if (double.tryParse(value) == null)
                            return "Amount should be a valid number";
                          if (double.tryParse(value) <= 0)
                            return "Amount should be greater than zero";

                          return null;
                        },
                        onSaved: (String value) =>
                            widget.transaction.setAmount = double.parse(value),
                      ),
                      FormFieldTitle(text: "Transaction Date"),
                      DateFormButton(
                        date: widget.transaction.date,
                        onPressDateHandler: () async {
                          final DateTime newDate = await showDatePicker(
                            context: context,
                            initialDate: widget.transaction.date,
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (newDate != null) {
                            setState(
                              () => widget.transaction.setTransactionDate =
                                  newDate,
                            );
                          }
                        },
                        onPressTimeHandler: () async {
                          final TimeOfDay newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: widget.transaction.date.hour,
                                  minute: widget.transaction.date.minute));
                          if (newTime != null) {
                            setState(
                              () => widget.transaction.setTransactionTime =
                                  newTime,
                            );
                          }
                        },
                      ),
                      FormFieldTitle(text: "Category"),
                      DropdownButtonFormField(
                        hint: IconWithTextWidget(
                          child: IconWithText(
                            text: widget.transaction.category,
                            icon: transactionCategories[
                                widget.transaction.category],
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
                        onChanged: (String c) {
                          setState(() => widget.transaction.category = c);
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
