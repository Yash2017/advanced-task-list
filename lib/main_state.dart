import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:advance_todo_list/notification_service.dart';
import 'home_page.dart';
import 'package:google_fonts/google_fonts.dart';

class main_state extends StatefulWidget {
  const main_state({Key? key}) : super(key: key);

  @override
  State<main_state> createState() => _main_stateState();
}

class _main_stateState extends State<main_state> {
  @override
  bool _isDark = false;
  void onChange() async {
    setState(() {
      _isDark = !_isDark;
    });
    await NotificationService().showNotifications(_isDark
        ? "You changed the theme from light to dark"
        : "You changed the theme from dark to light");
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.white,
            onPrimary: Colors.black,
            // Colors that are not relevant to AppBar in DARK mode:
            secondary: Color.fromRGBO(78, 90, 232, 1),
            onSecondary: Colors.black,
            background: Colors.black,
            onBackground: Colors.black,
            surface: Colors.black,
            onSurface: Colors.black,
            error: Colors.black,
            onError: Colors.black,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Color(0xFF4e5ae8)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white))),
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context)
              .textTheme
              .apply(displayColor: Colors.black, bodyColor: Colors.black))),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          surface: Colors.grey.shade900,
          onSurface: Colors.white,
          // Colors that are not relevant to AppBar in DARK mode:
          primary: Colors.black,
          onPrimary: Colors.white,
          secondary: Colors.red,
          onSecondary: Colors.red,
          background: Colors.red,
          onBackground: Colors.red,
          error: Colors.red,
          onError: Colors.red,
        ),
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context)
            .textTheme
            .apply(displayColor: Colors.white, bodyColor: Colors.white)),
        buttonTheme: ButtonThemeData(
            buttonColor: Color(0xFF4e5ae8), textTheme: ButtonTextTheme.primary),
      ),
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(callback: onChange),
    );
  }
}
