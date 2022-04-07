// ignore_for_file: prefer_const_constructors

import 'package:advance_todo_list/main_state.dart';
import 'package:advance_todo_list/notification_service.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return main_state();
  }
}
