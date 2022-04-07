import 'package:advance_todo_list/database.dart';
import 'package:advance_todo_list/individual_task.dart';
import 'package:advance_todo_list/notification_service.dart';
import 'package:advance_todo_list/task_options.dart';
import 'package:advance_todo_list/todo_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

class MyHomePage extends StatefulWidget {
  final VoidCallback callback;
  const MyHomePage({Key? key, required this.callback}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedDate = DateTime.now();
  database db = database();
  late Future<List<todo_model>> data;
  Future<List<todo_model>> getData() async {
    var dat = await db.getTodo();
    return dat;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = getData();
  }

  void _onTap(todo_model todo) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0, left: 24, right: 24),
              child: Column(children: [
                Divider(
                  color: Theme.of(context).colorScheme.brightness ==
                          Brightness.light
                      ? Colors.black
                      : Colors.white,
                  height: 20,
                  thickness: 0.7,
                  endIndent: 50,
                  indent: 50,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color(0xFF4e5ae8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          padding: EdgeInsets.only(
                              top: 12, bottom: 12, left: 20, right: 20)),
                      onPressed: () async {
                        await db.updateTodoStatus(todo);
                        setState(() {
                          data = getData();
                        });
                      },
                      child: Text("Task Completed")),
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 174, 47, 38),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          padding: EdgeInsets.only(
                              top: 12, bottom: 12, left: 20, right: 20)),
                      onPressed: () async {
                        await db.deleteTodo(todo.note);
                        setState(() {
                          data = getData();
                        });
                      },
                      child: Text("Delete Task")),
                ),
                SizedBox(
                  height: 70,
                ),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)),
                          padding: EdgeInsets.only(
                              top: 12, bottom: 12, left: 20, right: 20)),
                      onPressed: () {},
                      child: Text("Close")),
                )
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.mode_night_rounded),
            onPressed: widget.callback,
            splashRadius: 0.0001,
          ),
          title: const Text("Todo App")),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3),
                      child: Text("Today",
                          style: const TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        padding: EdgeInsets.only(
                            top: 10, bottom: 10, left: 20, right: 25)),
                    onPressed: () {
                      Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => task_options()))
                          .then((value) {
                        setState(() {
                          data = getData();
                        });
                      });
                    },
                    label: Text("Add Task"),
                    icon: Icon(Icons.add))
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: DatePicker(
                DateTime.now(),
                initialSelectedDate: DateTime.now(),
                height: 96,
                width: 76,
                selectionColor: Theme.of(context).brightness == Brightness.light
                    ? Color(0xFF4e5ae8)
                    : Colors.black,
                selectedTextColor: Colors.white,
                dayTextStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 15),
                dateTextStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
                monthTextStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.light
                        ? Colors.black
                        : Colors.white,
                    fontSize: 15),
                onDateChange: (DateTime? date) {
                  setState(() {
                    _selectedDate = date!;
                  });
                },
              ),
            ),
            FutureBuilder(
                future: data,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          DateTime _parsedDate =
                              DateTime.parse(snapshot.data[index].date);
                          if (_selectedDate == _parsedDate ||
                              (_selectedDate.isAfter(_parsedDate) &&
                                  snapshot.data[index].repeat == "Daily")) {
                            print('Daily');
                            DateTime etime =
                                DateTime.parse(snapshot.data[index].date).add(
                                    Duration(
                                        hours: int.parse(snapshot
                                            .data[index].startTime
                                            .substring(0, 2)),
                                        minutes: int.parse(snapshot
                                            .data[index].startTime
                                            .substring(3))));
                            DateTime? sTime;
                            if (snapshot.data[index].remind == 5) {
                              print('hey');
                              sTime = etime.subtract(Duration(minutes: 5));
                            } else if (snapshot.data[index].remind == 10) {
                              sTime = etime.subtract(Duration(minutes: 10));
                            } else if (snapshot.data[index].remind == 15) {
                              sTime = etime.subtract(Duration(minutes: 15));
                            } else {
                              sTime = etime.subtract(Duration(minutes: 20));
                            }
                            if (int.parse(snapshot.data[index].startTime.substring(0, 2)) >=
                                    int.parse(DateFormat.H()
                                        .format(DateTime.now())) &&
                                ((int.parse(snapshot.data[index].startTime.substring(3)) >
                                        int.parse(DateFormat.Hm()
                                            .format(DateTime.now())
                                            .toString()
                                            .substring(3))) &&
                                    (int.parse(snapshot.data[index].startTime
                                                .substring(3)) -
                                            int.parse(DateFormat.Hm()
                                                .format(DateTime.now())
                                                .toString()
                                                .substring(3)) >
                                        5))) {
                              print("hey2");
                              NotificationService().scheduleNotifications(
                                snapshot.data[index].title,
                                snapshot.data[index].note,
                                sTime,
                              );
                            }
                            return individual_task(
                              id: snapshot.data[index].id,
                              title: snapshot.data[index].title,
                              note: snapshot.data[index].note,
                              date: snapshot.data[index].date,
                              startTime: snapshot.data[index].startTime,
                              endTime: snapshot.data[index].endTime,
                              remind: snapshot.data[index].remind,
                              repeat: snapshot.data[index].repeat,
                              color: snapshot.data[index].color,
                              status: snapshot.data[index].status,
                              onTap: _onTap,
                            );
                          } else if (_selectedDate.isAfter(_parsedDate) &&
                              (DateFormat.EEEE().format(_selectedDate) ==
                                  DateFormat.EEEE().format(_parsedDate)) &&
                              (snapshot.data[index].repeat == "Weekly")) {
                            print('Daily');
                            DateTime etime =
                                DateTime.parse(snapshot.data[index].date).add(
                                    Duration(
                                        hours: int.parse(snapshot
                                            .data[index].startTime
                                            .substring(0, 2)),
                                        minutes: int.parse(snapshot
                                            .data[index].startTime
                                            .substring(3))));
                            DateTime? sTime;
                            if (snapshot.data[index].remind == 5) {
                              print('hey');
                              sTime = etime.subtract(Duration(minutes: 5));
                            } else if (snapshot.data[index].remind == 10) {
                              sTime = etime.subtract(Duration(minutes: 10));
                            } else if (snapshot.data[index].remind == 15) {
                              sTime = etime.subtract(Duration(minutes: 15));
                            } else {
                              sTime = etime.subtract(Duration(minutes: 20));
                            }
                            if (int.parse(snapshot.data[index].startTime.substring(0, 2)) >=
                                    int.parse(DateFormat.H()
                                        .format(DateTime.now())) &&
                                ((int.parse(snapshot.data[index].startTime.substring(3)) >
                                        int.parse(DateFormat.Hm()
                                            .format(DateTime.now())
                                            .toString()
                                            .substring(3))) &&
                                    (int.parse(snapshot.data[index].startTime
                                                .substring(3)) -
                                            int.parse(DateFormat.Hm()
                                                .format(DateTime.now())
                                                .toString()
                                                .substring(3)) >
                                        5))) {
                              print("hey2");
                              NotificationService().scheduleNotifications(
                                snapshot.data[index].title,
                                snapshot.data[index].note,
                                sTime,
                              );
                            }
                            return individual_task(
                              id: snapshot.data[index].id,
                              title: snapshot.data[index].title,
                              note: snapshot.data[index].note,
                              date: snapshot.data[index].date,
                              startTime: snapshot.data[index].startTime,
                              endTime: snapshot.data[index].endTime,
                              remind: snapshot.data[index].remind,
                              repeat: snapshot.data[index].repeat,
                              color: snapshot.data[index].color,
                              status: snapshot.data[index].status,
                              onTap: _onTap,
                            );
                          } else if (_selectedDate.isAfter(_parsedDate) &&
                              (DateFormat.d().format(_selectedDate) ==
                                  DateFormat.d().format(_parsedDate)) &&
                              (snapshot.data[index].repeat == "Monthly")) {
                            print('Daily');
                            DateTime etime =
                                DateTime.parse(snapshot.data[index].date).add(
                                    Duration(
                                        hours: int.parse(snapshot
                                            .data[index].startTime
                                            .substring(0, 2)),
                                        minutes: int.parse(snapshot
                                            .data[index].startTime
                                            .substring(3))));
                            DateTime? sTime;
                            if (snapshot.data[index].remind == 5) {
                              print('hey');
                              sTime = etime.subtract(Duration(minutes: 5));
                            } else if (snapshot.data[index].remind == 10) {
                              sTime = etime.subtract(Duration(minutes: 10));
                            } else if (snapshot.data[index].remind == 15) {
                              sTime = etime.subtract(Duration(minutes: 15));
                            } else {
                              sTime = etime.subtract(Duration(minutes: 20));
                            }
                            if (int.parse(snapshot.data[index].startTime.substring(0, 2)) >=
                                    int.parse(DateFormat.H()
                                        .format(DateTime.now())) &&
                                ((int.parse(snapshot.data[index].startTime.substring(3)) >
                                        int.parse(DateFormat.Hm()
                                            .format(DateTime.now())
                                            .toString()
                                            .substring(3))) &&
                                    (int.parse(snapshot.data[index].startTime
                                                .substring(3)) -
                                            int.parse(DateFormat.Hm()
                                                .format(DateTime.now())
                                                .toString()
                                                .substring(3)) >
                                        5))) {
                              print("hey2");
                              NotificationService().scheduleNotifications(
                                snapshot.data[index].title,
                                snapshot.data[index].note,
                                sTime,
                              );
                            }
                            return individual_task(
                              id: snapshot.data[index].id,
                              title: snapshot.data[index].title,
                              note: snapshot.data[index].note,
                              date: snapshot.data[index].date,
                              startTime: snapshot.data[index].startTime,
                              endTime: snapshot.data[index].endTime,
                              remind: snapshot.data[index].remind,
                              repeat: snapshot.data[index].repeat,
                              color: snapshot.data[index].color,
                              status: snapshot.data[index].status,
                              onTap: _onTap,
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        });
                  } else {
                    return Text("Could Not Load Data");
                  }
                })
          ]),
        ),
      ),
    );
  }
}
