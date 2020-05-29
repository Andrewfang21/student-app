import "dart:math";

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/providers/app_state_provider.dart";
import "package:student_app/screens/balance_screen.dart";
import "package:student_app/models/user.dart";
import 'package:student_app/utils.dart';
import "package:student_app/enums.dart";

enum ActivePageName { Balance }

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Widget> _navigationViews = [];
  User currentUser;

  bool _shouldLogout = false;
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      currentUser = Provider.of<AppStateProvider>(context, listen: false)
          .getCurrentUser();

      final String activePageName =
          Provider.of<AppStateProvider>(context, listen: false)
              .getActivePageName();

      _navigationViews = <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(
            currentUser.displayName,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          accountEmail: Text(
            currentUser.email.replaceFirst(
              currentUser.email[0],
              currentUser.email[0].toUpperCase(),
            ),
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: NetworkImage(currentUser.photoUrl),
          ),
        ),
        ListTile(
          title: Text(
            "Balance",
            style: activePageName == getPageString(PageName.Balance.toString())
                ? TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
          dense: true,
          leading: const Icon(Icons.account_balance_wallet),
          selected:
              activePageName == getPageString(PageName.Balance.toString()),
          onTap: () => print("Balance tile is pressed"),
        ),
        Divider(),
        ListTile(
          title: Text(
            "Schedule",
            style: activePageName == getPageString(PageName.Schedule.toString())
                ? TextStyle(fontWeight: FontWeight.bold)
                : null,
          ),
          dense: true,
          leading: const Icon(Icons.calendar_today),
          selected:
              activePageName == getPageString(PageName.Schedule.toString()),
          onTap: () => print("Schedule tile is pressed"),
        ),
        Divider(),
        ListTile(
          title: Text("Logout"),
          dense: true,
          leading: const Icon(Icons.exit_to_app),
          onTap: () {
            _handleLogout().then((_) async {
              if (_shouldLogout) {
                await FirebaseAuth.instance.signOut();
                Provider.of<AppStateProvider>(context, listen: false)
                    .deleteCurrentUser();
                Navigator.of(context)
                    .pushReplacementNamed(Routes.LoginScreen.toString());
              }
            });
          },
        ),
        Divider(),
      ];
    }
  }

  Future<bool> _handleLogout() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Are You Sure"),
        content: Text("Do you want to logout from the application?"),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              setState(() => _shouldLogout = true);
              Navigator.of(context).pop();
            },
            child: Text("Yes"),
          ),
          FlatButton(
            onPressed: () {
              setState(() => _shouldLogout = false);
              Navigator.of(context).pop();
            },
            child: Text("No"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color themeColor = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Builder(
        builder: (context) => BalanceScreen(currentUser: currentUser),
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(backgroundColor: themeColor),
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: _navigationViews.toList(),
          ),
        ),
      ),
    );
  }
}
