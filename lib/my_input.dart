import "package:flutter/material.dart";
import "package:flutter/widgets.dart";

class my_input extends StatefulWidget {
  final String title;
  String hintText;
  final TextEditingController controller;
  my_input(
      {Key? key,
      required this.title,
      required this.hintText,
      required this.controller})
      : super(key: key);

  @override
  State<my_input> createState() => _my_inputState();
}

class _my_inputState extends State<my_input> {
  @override
  Widget build(BuildContext context) {
    BoxBorder container_border = widget.hintText.contains("Please") &&
            widget.controller.value.text.isEmpty
        ? Border.all(color: Colors.red, width: 1)
        : Border.all(color: Colors.grey, width: 1);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
        height: 15,
      ),
      Text(
        widget.title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      SizedBox(
        height: 15,
      ),
      Container(
        decoration: BoxDecoration(
            border: container_border, borderRadius: BorderRadius.circular(10)),
        child: Container(
          margin: EdgeInsets.only(left: 8, right: 8),
          child: TextFormField(
            //cursorHeight: 30,
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  widget.hintText = "";
                });
              }
            },
            style: TextStyle(fontSize: 16),
            controller: widget.controller,
            cursorColor:
                (Theme.of(context).colorScheme.brightness == Brightness.light)
                    ? Colors.black
                    : Colors.white,
            //cursorHeight: 30,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(8),
                //floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                    color: widget.hintText.contains("Please")
                        ? Colors.red
                        : Colors.grey),
                border: InputBorder.none),
          ),
        ),
      )
    ]);
  }
}
