import "package:flutter/material.dart";

class CustomizedAppBar extends StatelessWidget {
  final String title;

  CustomizedAppBar({
    @required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final Color themeColor = Theme.of(context).primaryColor;

    return Container(
      width: deviceWidth,
      decoration: BoxDecoration(
        color: themeColor,
        border: Border.all(color: themeColor),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 30.0,
          left: 5.0,
          right: 15.0,
        ),
        child: Row(
          children: <Widget>[
            IconButton(
              alignment: Alignment.centerLeft,
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
              color: Colors.black87,
              iconSize: 30.0,
            ),
            SizedBox(width: 10.0),
            Text(
              this.title,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
