import 'package:advance_todo_list/todo_model.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

class individual_task extends StatelessWidget {
  final int id;
  final String title;
  final String note;
  final String date;
  final String startTime;
  final String endTime;
  final int remind;
  final String repeat;
  final int status;
  final String color;
  final Function onTap;
  individual_task({
    Key? key,
    required this.id,
    required this.title,
    required this.note,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.remind,
    required this.repeat,
    required this.color,
    required this.status,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          onTap(todo_model(
              title: title,
              note: note,
              date: date,
              startTime: startTime,
              endTime: endTime,
              remind: remind,
              repeat: repeat,
              color: color,
              status: 1));
        },
        child: Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Color(int.parse(color)),
          ),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 15, horizontal: 13),
            child: Row(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  flex: 7,
                  fit: FlexFit.tight,
                  child: Wrap(direction: Axis.vertical, spacing: 10, children: [
                    Text(title,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22)),
                    Text(note,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15)),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 5,
                      children: [
                        Icon(
                          Icons.access_time,
                          color: Colors.white,
                        ),
                        Text(startTime,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 13)),
                        Text(endTime,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                fontSize: 13))
                      ],
                    ),
                  ]),
                ),
                Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Container(
                        height: 100,
                        //color: Colors.red,
                        child: Wrap(
                            direction: Axis.vertical,
                            alignment: WrapAlignment.center,
                            children: [
                              VerticalDivider(
                                color: Colors.white,
                                thickness: 1.2,
                                indent: 4,
                                endIndent: 4,
                              ),
                              RotatedBox(
                                quarterTurns: -1,
                                child: Text(status == 0 ? "Todo" : "Completed",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15)),
                              )
                            ])))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
