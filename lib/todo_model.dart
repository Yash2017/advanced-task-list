import 'package:sqflite/sqflite.dart';
import 'package:flutter/material.dart';

class todo_model {
  late int? id;
  final String title;
  final String note;
  final String date;
  final String startTime;
  final String endTime;
  final int remind;
  final String repeat;
  final int status;
  final String color;
  todo_model(
      {this.id,
      required this.title,
      required this.note,
      required this.date,
      required this.startTime,
      required this.endTime,
      required this.remind,
      required this.repeat,
      required this.color,
      required this.status});

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      "note": note,
      "date": date,
      "startTime": startTime,
      "endTime": endTime,
      "remind": remind,
      "repeat": repeat,
      "color": color,
      "status": status,
    };
  }
}
