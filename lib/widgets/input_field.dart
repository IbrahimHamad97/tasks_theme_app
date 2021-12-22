import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks_theme_app/screens/themes.dart';

class MyInputField extends StatefulWidget {
  final String title;
  final String hint;
  final TextEditingController? controller;
  final Widget? widget;

  const MyInputField(
      {Key? key,
      required this.title,
      required this.hint,
      this.widget,
      this.controller})
      : super(key: key);

  @override
  State<MyInputField> createState() => _MyInputFieldState();
}

class _MyInputFieldState extends State<MyInputField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: widget.controller,
                        readOnly: widget.widget == null ? false : true,
                        cursorColor:
                            Get.isDarkMode ? Colors.grey[100] : Colors.grey[700],
                        validator: (val) => val!.isEmpty ? "Enter An Email" : null,
                        onChanged: (val) {
                          setState(() {});
                        },
                        decoration: inputDec.copyWith(hintText: widget.hint),
                      ),
                    ),
                    widget.widget == null
                        ? Container()
                        : Container(
                      child: widget.widget,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
