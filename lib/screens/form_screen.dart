import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:tasks_theme_app/controllers/task_controller.dart';
import 'package:tasks_theme_app/models/task_model.dart';
import 'package:tasks_theme_app/widgets/input_field.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({Key? key}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TaskController _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  String _endTime = '9:30 PM';
  int selectedRemind = 5;
  List reminds = [5, 10, 15, 20, 25];
  String selectedRepeat = "None";
  List repeats = ['None', 'Daily', 'Weekly', 'Monthly'];
  int selectedColorIndex = 0;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: Form(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyInputField(
                  title: "Add Task",
                  hint: "Enter Task Title Here",
                  controller: _titleController,
                ),
                SizedBox(height: 5),
                MyInputField(
                  title: "Add Note",
                  hint: "Enter Notes Here",
                  controller: _noteController,
                ),
                SizedBox(height: 5),
                MyInputField(
                  title: "Add Date",
                  hint: DateFormat.yMd().format(_selectedDate),
                  widget: IconButton(
                    icon: Icon(Icons.calendar_today_outlined),
                    onPressed: () {
                      _getDateFromUser();
                    },
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                        child: MyInputField(
                      widget: IconButton(
                        icon: Icon(Icons.access_time_outlined),
                        onPressed: () {
                          _getTimeFromUser(isStartTime: true);
                        },
                      ),
                      title: "Start Time",
                      hint: _startTime,
                    )),
                    SizedBox(width: 10),
                    Expanded(
                        child: MyInputField(
                            widget: IconButton(
                              icon: Icon(Icons.access_time_outlined),
                              onPressed: () {
                                _getTimeFromUser(isStartTime: false);
                              },
                            ),
                            title: "End Time",
                            hint: _endTime)),
                  ],
                ),
                SizedBox(height: 5),
                MyInputField(
                    title: "Reminder",
                    hint: "$selectedRemind minutes early",
                    widget: DropdownButton(
                      underline: Container(height: 0),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRemind = int.parse(newValue!);
                        });
                      },
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: reminds.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                          child: Text(e.toString()),
                          value: e.toString(),
                        );
                      }).toList(),
                    )),
                SizedBox(height: 5),
                MyInputField(
                    title: "Repeat",
                    hint: "$selectedRepeat",
                    widget: DropdownButton(
                      underline: Container(height: 0),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRepeat = newValue!;
                        });
                      },
                      icon: Icon(Icons.keyboard_arrow_down),
                      items: repeats.map<DropdownMenuItem<String>>((e) {
                        return DropdownMenuItem(
                          child: Text(e),
                          value: e,
                        );
                      }).toList(),
                    )),
                SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Color",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 5),
                        Wrap(
                          children: List<Widget>.generate(3, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColorIndex = index;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 8),
                                child: CircleAvatar(
                                  backgroundColor: index == 0
                                      ? Colors.yellow
                                      : index == 1
                                          ? Colors.pink
                                          : Colors.red,
                                  radius: 15,
                                  child: selectedColorIndex == index
                                      ? Icon(Icons.check)
                                      : Container(),
                                ),
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                    SizedBox(
                        width: 100,
                        height: 40,
                        child: ElevatedButton(
                            onPressed: () {
                              validateFields();
                            },
                            child: Text("Add")))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  validateFields() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else {
      Get.snackbar("Required", "All fields are needed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Get.isDarkMode ? Colors.white : Colors.red,
          colorText: Get.isDarkMode ? Colors.black : Colors.white,
          icon: Icon(Icons.warning_amber_outlined,
              color: Get.isDarkMode ? Colors.black : Colors.white));
    }
  }

  _addTaskToDb() async {
    var val  = await _taskController.addTask(
        task: Task(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      repeat: selectedRepeat,
      remind: selectedRemind,
          color: selectedColorIndex,
    ));
    print(val);
  }

  _appBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        Container(
          padding: EdgeInsets.only(right: 10),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/A2.png'),
          ),
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015),
        lastDate: DateTime(2030));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker();
    String _formattedTime = pickedTime.format(context);
    if (pickedTime == null) {
      print('meow');
    } else if (isStartTime == true) {
      setState(() {
        _startTime = _formattedTime;
      });
    } else if (isStartTime == false) {}
    setState(() {
      _endTime = _formattedTime;
    });
  }

  _showTimePicker() {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.input,
        context: context,
        initialTime: TimeOfDay(
          hour: int.parse(_startTime.split(':')[0]),
          minute: int.parse(_startTime.split(':')[1].split(' ')[0]),
        ),);
  }
}
