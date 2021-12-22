import 'package:flutter/material.dart';

class TaskWidget extends StatefulWidget {
  final String? title;
  final String? note;
  final String? startTime;
  final String? endTime;

  const TaskWidget(
      {Key? key,
      required this.title,
      required this.note,
      required this.startTime,
      required this.endTime})
      : super(key: key);

  @override
  _TaskWidgetState createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.fromLTRB(10, 10, 0, 10),
        width: double.maxFinite,
        decoration: BoxDecoration(
          color: Colors.pink[100],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title ?? "hi"),
                Row(
                  children: [
                    Text(widget.startTime ?? "hi"),
                    SizedBox(width: 5),
                    Text("-"),
                    SizedBox(width: 5),
                    Text(widget.endTime ?? "hi"),
                  ],
                ),
                Text(widget.note ?? "hi")
              ],
            ),
          ],
        ));
  }
}
