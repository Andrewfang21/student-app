import "package:flutter/material.dart";
import "package:student_app/widgets/time_series_chart.dart";
import "package:student_app/models/user.dart";

class BalanceScreen extends StatefulWidget {
  final User currentUser;

  BalanceScreen({
    Key key,
    this.currentUser,
  }) : super(key: key);

  @override
  _BalanceScreenState createState() => _BalanceScreenState(currentUser);
}

class _BalanceScreenState extends State<BalanceScreen> {
  GlobalKey<ScaffoldState> scaffoldKey;
  final User currentUser;

  _BalanceScreenState(this.currentUser);

  @override
  Widget build(BuildContext context) {
    final Color themeColor = Theme.of(context).primaryColor;
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double deviceHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
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
                    "Balance",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  )
                ],
              ),
            ),
          ),
          Stack(
            children: <Widget>[
              ClipPath(
                clipper: CustomShapeClipper(),
                child: Container(
                  height: deviceHeight * 0.3,
                  decoration: BoxDecoration(color: themeColor),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
                child: Text(
                  "Welcome,\n${currentUser.displayName}",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 120.0,
                  right: 25.0,
                  left: 25.0,
                  bottom: 10.0,
                ),
                child: Container(
                  width: deviceWidth,
                  height: 270.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 25.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: double.infinity,
                                child: Text(
                                  "HKD 100",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child:
                                    Text("Your net income in the last 7 days"),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 100,
                          margin: const EdgeInsets.only(top: 10.0),
                          child: EndPointsAxisTimeSeriesChart.withSampleData(),
                        ),
                        Spacer(),
                        Container(
                          margin: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                  "More Info",
                                  textAlign: TextAlign.end,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.arrow_forward),
                                onPressed: () => print("button pressed"),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var _path = Path();
    _path.lineTo(0.0, 390.0 - 200);
    _path.quadraticBezierTo(size.width / 2, 275, size.width, 390.0 - 200);
    _path.lineTo(size.width, 0.0);
    _path.close();
    return _path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
