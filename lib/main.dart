import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:provider/provider.dart";
import "package:student_app/providers/app_state_provider.dart";
import "package:student_app/providers/transaction_provider.dart";
import "package:student_app/screens/home_screen.dart";
import "package:student_app/screens/login_screen.dart";
import "package:student_app/screens/splash_screen.dart";
import "package:student_app/enums.dart";

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppStateProvider()),
        ChangeNotifierProvider(create: (context) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: "StudentApp",
        theme: ThemeData(
          backgroundColor: Color(0xFFFFF8E8),
          primaryColorLight: Color(0xFFFFE5B1),
          primaryColorDark: Color(0xFFCD8A05),
          buttonColor: Color(0xFFFFE5B1),
          primarySwatch: MaterialColor(0xFFFFA500, {
            50: Color(0xFFFFF8E8),
            100: Color(0xFFFAEBCC),
            200: Color(0xFFFFE5B1),
            300: Color(0xFFF9DBA0),
            400: Color(0xFFF6D28A),
            500: Color(0xFFF2C771),
            600: Color(0xFFF6C461),
            700: Color(0xFFEFB239),
            800: Color(0xFFDF9E1A),
            900: Color(0xFFCD8A05),
          }),
          fontFamily: "Signika",
        ),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          (Routes.LoginScreen.toString()): (BuildContext context) =>
              LoginScreen(),
          (Routes.HomeScreen.toString()): (BuildContext context) =>
              HomeScreen(),
        },
      ),
    );
  }
}

void main() => runApp(MyApp());
