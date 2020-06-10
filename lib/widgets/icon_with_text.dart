import "package:flutter/material.dart";

class IconWithTextWidget extends StatelessWidget {
  final IconWithText child;
  final double marginWidth;

  const IconWithTextWidget({
    @required this.child,
    @required this.marginWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(child.icon),
        SizedBox(width: marginWidth),
        Text(
          child.text,
          style: TextStyle(color: Colors.black),
        )
      ],
    );
  }
}

class IconWithText {
  final String text;
  final IconData icon;

  const IconWithText({
    @required this.text,
    @required this.icon,
  });
}
