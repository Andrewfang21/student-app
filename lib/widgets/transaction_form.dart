import "package:flutter/material.dart";

class CustomForm {
  final TextEditingController nameFieldController = TextEditingController();
  final TextEditingController descriptionFieldController =
      TextEditingController();
  final TextEditingController amountFieldController = TextEditingController();

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode amountFocusNode = FocusNode();

  final String nameLabelText = "Name";
  final String descriptionLabelText = "Description";
  final String amountLabelText = "Amount (in HKD)";
}

class FormFieldTitle extends StatelessWidget {
  final String text;

  const FormFieldTitle({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 15.0),
      child: Text(
        text,
        style: TextStyle(color: Colors.grey[600], fontSize: 13),
      ),
    );
  }
}
