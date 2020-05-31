import "package:flutter/material.dart";

class TransactionFormField {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  String initialValue;
  String labelText;

  TransactionFormField({
    controller,
    focusNode,
    @required this.initialValue,
    @required this.labelText,
  });
}

class TransactionButtonField {
  String text;
  IconData icon;

  TransactionButtonField({
    @required this.text,
    @required this.icon,
  });
}
