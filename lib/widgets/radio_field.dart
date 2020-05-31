import "package:flutter/material.dart";

class RadioField extends StatefulWidget {
  final List<RadioOption> radioList;
  final SelectRadio selectedRadio;
  final double horizontalMargin;

  RadioField({
    Key key,
    @required this.radioList,
    @required this.selectedRadio,
    this.horizontalMargin = 0.0,
  }) : super(key: key);

  @override
  _RadioFieldState createState() => _RadioFieldState();
}

class _RadioFieldState extends State<RadioField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: this.widget.horizontalMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this
            .widget
            .radioList
            .map((RadioOption option) => Row(
                  children: <Widget>[
                    Radio(
                        value: option.index,
                        groupValue: this.widget.selectedRadio.index,
                        onChanged: (int value) {
                          setState(
                            () => this.widget.selectedRadio.setIndex = value,
                          );
                        }),
                    Text(option.text),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

class RadioOption {
  final int index;
  final String text;

  RadioOption({
    @required this.index,
    @required this.text,
  });
}

class SelectRadio {
  int index;

  SelectRadio({@required this.index});

  set setIndex(int newIndex) => this.index = newIndex;
}
