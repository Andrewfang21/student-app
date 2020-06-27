import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/providers/app_state_provider.dart";
import "package:student_app/providers/user_provider.dart";
import "package:student_app/screens/transaction_create_screen.dart";
import "package:student_app/screens/transaction_home_screen.dart";
import "package:student_app/screens/task_create_screen.dart";
import "package:student_app/screens/task_home_screen.dart";
import "package:student_app/services/user_shared_preference.dart";
import "package:student_app/models/user.dart";
import "package:student_app/utils.dart";
import "package:student_app/enums.dart";

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel currentUser;
  bool _shouldLogout = false;

  Future<bool> _handleLogout() {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Are You Sure"),
        content: Text("Do you want to logout from the application?"),
        actions: <Widget>[
          FlatButton(
            onPressed: () async {
              setState(() => _shouldLogout = true);
              await UserSharedPreference.deleteActiveUser();

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
    final String activePageName = appState.activePageName;

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
          style: isSame(activePageName, PageName.Transaction.toString())
              ? TextStyle(fontWeight: FontWeight.bold)
              : null,
        ),
        dense: true,
        leading: const Icon(Icons.account_balance_wallet),
        selected: isSame(activePageName, PageName.Transaction.toString()),
        onTap: () {
          if (activePageName != "Transaction")
            appState.activePageName = PageName.Transaction.toString();
          Navigator.of(context).pop();
        },
      ),
      Divider(),
      ListTile(
        title: Text(
          "Task",
          style: isSame(activePageName, PageName.Task.toString())
              ? TextStyle(fontWeight: FontWeight.bold)
              : null,
        ),
        dense: true,
        leading: const Icon(Icons.calendar_today),
        selected: isSame(activePageName, PageName.Task.toString()),
        onTap: () {
          if (activePageName != "Task")
            appState.activePageName = PageName.Task.toString();
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
    return FloatingActionButton(
      onPressed: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => activePageName == "Transaction"
            ? TransactionCreateScreen()
            : TaskCreateScreen(),
      )),
      child: Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String _activePageName =
        Provider.of<AppStateProvider>(context).activePageName;
    final Color _themeColor = Theme.of(context).primaryColor;

    currentUser = Provider.of<UserProvider>(context, listen: false).currentUser;

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
        builder: isSame(_activePageName, PageName.Transaction.toString())
            ? (context) => TransactionHomeScreen(currentUser: currentUser)
            : (context) => TaskScreen(),
      ),
    );
  }
}
