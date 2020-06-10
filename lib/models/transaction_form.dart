import "package:flutter/material.dart";

class CustomFormField {
  TextEditingController controller = TextEditingController();
  FocusNode focusNode = FocusNode();
  String initialValue;
  String labelText;

  CustomFormField({
    controller,
    focusNode,
    this.initialValue = "",
    @required this.labelText,
  });
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
