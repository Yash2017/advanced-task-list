// ignore_for_file: prefer_const_constructors

import 'package:advance_todo_list/my_input.dart';
import 'package:advance_todo_list/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:advance_todo_list/database.dart';
import 'package:sqflite/sqlite_api.dart';

class task_options extends StatefulWidget {
  const task_options({Key? key}) : super(key: key);

  @override
  State<task_options> createState() => _task_optionsState();
}

class _task_optionsState extends State<task_options> {
  void _getEndTime() async {
    TimeOfDay? _selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
              data: (Theme.of(context).brightness == Brightness.light)
                  ? Theme.of(context).copyWith(
                      textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(primary: Colors.black)),
                      colorScheme: ColorScheme.light(
                          primary: Color(0xFF4e5ae8),
                          onPrimary: Colors.white,
                          onSurface: Colors.black))
                  : Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                          surface: Colors.black,
                          onSurface: Colors.white,
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          background: Colors.black,
                          secondary: Colors.black)),
              child: child ?? Text("hey"));
        });

    setState(() {
      _displayEndTime = DateFormat.Hm().format(applied(_selectedTime));
    });
  }

  void _getStartTime() async {
    TimeOfDay? _selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (context, child) {
          return Theme(
              data: (Theme.of(context).brightness == Brightness.light)
                  ? Theme.of(context).copyWith(
                      textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(primary: Colors.black)),
                      colorScheme: ColorScheme.light(
                          primary: Color(0xFF4e5ae8),
                          onPrimary: Colors.white,
                          onSurface: Colors.black))
                  : Theme.of(context).copyWith(
                      colorScheme: ColorScheme.dark(
                          surface: Colors.black,
                          onSurface: Colors.white,
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          background: Colors.black,
                          secondary: Colors.black)),
              child: child ?? Text("hey"));
        });

    setState(() {
      _displayStartTime = DateFormat.Hm().format(applied(_selectedTime));
    });
  }

  DateTime applied(TimeOfDay? current) {
    return DateTime(2022, 04, 11, current?.hour ?? 0, current?.minute ?? 0);
  }

  String? _displayStartTime;
  String? _displayEndTime;
  DateTime? _displayDate;
  String? _dropdownRemind;
  String? _dropdownRepeat;
  bool _checkedValue = false;
  int? _index = 0;
  String? title_hint;
  String? note_hint;
  void _getDate() async {
    DateTime? _selectedDate = await showDatePicker(
      helpText: "Select Task Date",
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2222),
      builder: (context, child) {
        return Theme(
            data: (Theme.of(context).brightness == Brightness.light)
                ? Theme.of(context).copyWith(
                    textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(primary: Colors.black)),
                    colorScheme: ColorScheme.light(
                        primary: Color(0xFF4e5ae8),
                        onPrimary: Colors.white,
                        onSurface: Colors.black))
                : Theme.of(context).copyWith(
                    colorScheme: ColorScheme.dark(
                        surface: Colors.black,
                        onSurface: Colors.white,
                        primary: Colors.white,
                        onPrimary: Colors.black,
                        background: Colors.black,
                        secondary: Colors.black)),
            child: child ?? Text("hey"));
      },
    );
    setState(() {
      _displayDate = _selectedDate;
    });
  }

  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  final form_key = GlobalKey<FormState>();
  BoxBorder datePickerBorder = Border.all(color: Colors.grey, width: 1);
  BoxBorder startTimeBorder = Border.all(color: Colors.grey, width: 1);
  BoxBorder endTimeBorder = Border.all(color: Colors.grey, width: 1);
  BoxBorder remindBorder = Border.all(color: Colors.grey, width: 1);
  BoxBorder repeatBorder = Border.all(color: Colors.grey, width: 1);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Create your Todo"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 10.0, right: 20),
          child: Form(
            key: form_key,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "Add Todo",
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              my_input(
                  title: "Title",
                  hintText: title_hint ?? "Enter you title.",
                  controller: title),
              my_input(
                  title: "Note",
                  hintText: note_hint ?? "Enter you note.",
                  controller: note),
              SizedBox(
                height: 15,
              ),
              Text(
                "Date",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                margin: EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                    border: _displayDate == null
                        ? datePickerBorder
                        : Border.all(color: Colors.grey, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  //margin: EdgeInsets.only(left: 10, right: 8, top: 8),
                  // width: double.infinity,
                  //height: 40,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _getDate();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 16),
                                child: Text(
                                  _displayDate == null
                                      ? datePickerBorder ==
                                              Border.all(
                                                  color: Colors.red, width: 1)
                                          ? "Please select a date"
                                          : 'May 27, 2022'
                                      : DateFormat.yMMMMd()
                                          .format(_displayDate!)
                                          .toString(),
                                  style: TextStyle(
                                    color: (_displayDate == null)
                                        ? datePickerBorder ==
                                                Border.all(
                                                    color: Colors.red, width: 1)
                                            ? Colors.red
                                            : Colors.grey
                                        : (Theme.of(context).brightness ==
                                                Brightness.light)
                                            ? Colors.black
                                            : Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 16),
                                  child: Icon(
                                    Icons.date_range,
                                    color: Colors.grey,
                                  ))
                            ],
                          ),
                        )
                      ]),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Start Time",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 116,
                  ),
                  Text(
                    "End Time",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Wrap(
                direction: Axis.horizontal,
                children: [
                  GestureDetector(
                    onTap: _getStartTime,
                    child: Container(
                        height: 50,
                        width: 180,
                        margin: EdgeInsets.only(top: 8, right: 10),
                        decoration: BoxDecoration(
                            border: _displayStartTime == null
                                ? startTimeBorder
                                : Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _displayStartTime == null
                                    ? startTimeBorder ==
                                            Border.all(
                                                color: Colors.red, width: 1)
                                        ? "Select Start Time"
                                        : '17:00'
                                    : _displayStartTime!,
                                style: TextStyle(
                                  color: (_displayStartTime == null)
                                      ? startTimeBorder ==
                                              Border.all(
                                                  color: Colors.red, width: 1)
                                          ? Colors.red
                                          : Colors.grey
                                      : (Theme.of(context).brightness ==
                                              Brightness.light)
                                          ? Colors.black
                                          : Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(Icons.access_time_rounded,
                                  color: startTimeBorder ==
                                              Border.all(
                                                  color: Colors.red,
                                                  width: 1) &&
                                          _displayStartTime == null
                                      ? Colors.red
                                      : Colors.grey)
                            ],
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: _getEndTime,
                    child: Container(
                        height: 50,
                        margin: EdgeInsets.only(
                          top: 8,
                        ),
                        width: 180,
                        decoration: BoxDecoration(
                            border: _displayEndTime == null
                                ? endTimeBorder
                                : Border.all(
                                    color: Colors.grey,
                                    width: 1,
                                  ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _displayEndTime == null
                                    ? endTimeBorder ==
                                            Border.all(
                                                color: Colors.red, width: 1)
                                        ? "Select End Time"
                                        : '21:00'
                                    : _displayEndTime!,
                                style: TextStyle(
                                  color: (_displayEndTime == null)
                                      ? endTimeBorder ==
                                              Border.all(
                                                  color: Colors.red, width: 1)
                                          ? Colors.red
                                          : Colors.grey
                                      : (Theme.of(context).brightness ==
                                              Brightness.light)
                                          ? Colors.black
                                          : Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(Icons.access_time_rounded,
                                  color: endTimeBorder ==
                                              Border.all(
                                                  color: Colors.red,
                                                  width: 1) &&
                                          _displayEndTime == null
                                      ? Colors.red
                                      : Colors.grey)
                            ],
                          ),
                        )),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Remind",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                  margin: EdgeInsets.only(top: 8),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      border: _dropdownRemind == null
                          ? remindBorder
                          : Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _dropdownRemind,
                          hint: remindBorder ==
                                  Border.all(color: Colors.red, width: 1)
                              ? Text(
                                  "Please Select a Remind Time",
                                  style: TextStyle(color: Colors.red),
                                )
                              : Text("5 minutes early",
                                  style: TextStyle(color: Colors.grey)),
                          icon: Icon(Icons.keyboard_arrow_down),
                          onChanged: (String? value) {
                            setState(() {
                              _dropdownRemind = value;
                            });
                          },
                          items: <String>[
                            "5 minutes early",
                            "10 minutes early",
                            "15 minutes early",
                            "20 minutes early"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                        ),
                      ))),
              SizedBox(
                height: 15,
              ),
              Text(
                "Repeat",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                  margin: EdgeInsets.only(top: 8),
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      border: _dropdownRepeat == null
                          ? repeatBorder
                          : Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 16),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _dropdownRepeat,
                          hint: repeatBorder ==
                                  Border.all(color: Colors.red, width: 1)
                              ? Text("Please Select a Repeat Time",
                                  style: TextStyle(color: Colors.red))
                              : Text(
                                  "None",
                                  style: TextStyle(color: Colors.grey),
                                ),
                          icon: Icon(Icons.keyboard_arrow_down),
                          onChanged: (String? value) {
                            setState(() {
                              _dropdownRepeat = value;
                            });
                          },
                          items: <String>["None", "Daily", "Weekly", "Monthly"]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                        ),
                      ))),
              SizedBox(
                height: 15,
              ),
              Text(
                "Color",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Wrap(
                        spacing: 10,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _index = 0;
                              });
                            },
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: Color(0xFF4e5ae8),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: _index == 0
                                    ? Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _index = 1;
                              });
                            },
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: Color(0xFFcb3753),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: _index == 1
                                    ? Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _index = 2;
                              });
                            },
                            child: CircleAvatar(
                              radius: 13,
                              backgroundColor: Color(0xFFc99139),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: _index == 2
                                    ? Icon(
                                        Icons.check,
                                        size: 20,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.only(
                                top: 12, bottom: 12, left: 20, right: 20)),
                        onPressed: () {
                          _validate();
                        },
                        child: Text("Create Task"),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ),
      ),
    ));
  }

  void _validate() async {
    if (title.value.text.isEmpty) {
      setState(() {
        title_hint = "Please enter the title";
      });
    } else if (note.value.text.isEmpty) {
      setState(() {
        note_hint = 'Please enter the note';
      });
    } else if (_displayDate == null) {
      setState(() {
        datePickerBorder = Border.all(color: Colors.red, width: 1);
      });
    } else if (_displayStartTime == null) {
      setState(() {
        startTimeBorder = Border.all(color: Colors.red, width: 1);
      });
    } else if (_displayEndTime == null) {
      setState(() {
        endTimeBorder = Border.all(color: Colors.red, width: 1);
      });
    } else if (_dropdownRemind == null) {
      setState(() {
        remindBorder = Border.all(color: Colors.red, width: 1);
      });
    } else if (_dropdownRepeat == null) {
      setState(() {
        repeatBorder = Border.all(color: Colors.red, width: 1);
      });
    } else {
      todo_model todo = todo_model(
          title: title.value.text.toString(),
          note: note.value.text.toString(),
          date: _displayDate!.toIso8601String(),
          startTime: _displayStartTime!,
          endTime: _displayEndTime!,
          remind: int.parse(_dropdownRemind!.substring(0, 2)),
          repeat: _dropdownRepeat!,
          color: _index == 0
              ? "0xFF4e5ae8"
              : _index == 1
                  ? "0xFFcb3753"
                  : "0xFFc99139",
          status: 0);
      database db = database();

      await db.insertTodo(todo);
      Navigator.pop(context);
    }
  }
}
