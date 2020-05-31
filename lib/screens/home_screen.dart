import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/providers/app_state_provider.dart";
import "package:student_app/screens/balance_home_screen.dart";
import "package:student_app/screens/schedule_screen.dart";
import "package:student_app/models/user.dart";
import "package:student_app/utils.dart";
import "package:student_app/enums.dart";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _shouldLogout = false;

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

  List<Widget> _drawerNavigationViews(AppStateProvider appState) {
    final User currentUser = appState.getCurrentUser();
    final String activePageName = appState.getActivePageName();

    return [
      UserAccountsDrawerHeader(
        accountName: Text(
          currentUser.displayName,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        accountEmail: Text(currentUser.email),
        currentAccountPicture: CircleAvatar(
          backgroundImage: NetworkImage(currentUser.photoUrl),
        ),
      ),
      ListTile(
        title: Text(
          "Balance",
          style: isSame(activePageName, PageName.Balance.toString())
              ? TextStyle(fontWeight: FontWeight.bold)
              : null,
        ),
        dense: true,
        leading: const Icon(Icons.account_balance_wallet),
        selected: isSame(activePageName, PageName.Balance.toString()),
        onTap: () {
          if (activePageName != "Balance")
            appState.setActivePageName(PageName.Balance.toString());
          Navigator.of(context).pop();
        },
      ),
      Divider(),
      ListTile(
        title: Text(
          "Schedule",
          style: isSame(activePageName, PageName.Schedule.toString())
              ? TextStyle(fontWeight: FontWeight.bold)
              : null,
        ),
        dense: true,
        leading: const Icon(Icons.calendar_today),
        selected: isSame(activePageName, PageName.Schedule.toString()),
        onTap: () {
          if (activePageName != "Schedule")
            appState.setActivePageName(PageName.Schedule.toString());
          Navigator.of(context).pop();
        },
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
              Navigator.of(context)
                  .pushReplacementNamed(Routes.LoginScreen.toString());
            }
          });
        },
      ),
      Divider(),
    ];
  }

  FloatingActionButton customizedFloatingActionButton(String activePageName) {
    if (activePageName == "Balance") {
      return FloatingActionButton(
        onPressed: () {
          print("This is balance floating action button");
        },
        child: Icon(Icons.add),
      );
    }
    return FloatingActionButton(
      onPressed: () {
        print("This is schedule floating action button");
      },
      child: Icon(Icons.settings_backup_restore),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: use shared preference instead
    final User _currentUser =
        Provider.of<AppStateProvider>(context).getCurrentUser();
    final String _activePageName =
        Provider.of<AppStateProvider>(context).getActivePageName();
    final Color _themeColor = Theme.of(context).primaryColor;

    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: Theme.of(context).backgroundColor,
          body: child,
          drawer: Theme(
            data: Theme.of(context).copyWith(backgroundColor: _themeColor),
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: _drawerNavigationViews(appState),
              ),
            ),
          ),
          floatingActionButton: customizedFloatingActionButton(_activePageName),
        );
      },
      child: Builder(
        builder: isSame(_activePageName, PageName.Balance.toString())
            ? (context) => BalanceHomeScreen(currentUser: _currentUser)
            : (context) => ScheduleScreen(),
      ),
    );
  }
}
