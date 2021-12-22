import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tasks_theme_app/controllers/task_controller.dart';
import 'package:tasks_theme_app/screens/form_screen.dart';
import 'package:tasks_theme_app/screens/themes.dart';
import 'package:tasks_theme_app/services/notifications_service.dart';
import 'package:tasks_theme_app/widgets/task_tile.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  _TasksScreenState createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  var notifyHelper;
  var date = DateTime.now();
  final _taskController = Get.put(TaskController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _taskBar(),
        SizedBox(height: 10),
        _datePicker(),
        SizedBox(height: 10),
        _showTasks(),
      ],
    );
  }

  _taskBar() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(DateFormat.yMMMMd().format(DateTime.now()),
                  style: textStyleSmol),
              SizedBox(height: 5),
              Text("Today", style: textStyleBig),
            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                await Get.to(() => FormScreen());
                _taskController.getTasks();
              },
              child: Text("Add Task", style: TextStyle(fontSize: 12)),
            ),
          )
        ],
      ),
    );
  }

  _datePicker() {
    return Container(
      child: DatePicker(
        DateTime.now(),
        height: 120,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.blue,
        selectedTextColor: Colors.white,
        dayTextStyle: GoogleFonts.lato(
            textStyle:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
        monthTextStyle: GoogleFonts.lato(
            textStyle:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
        dateTextStyle: GoogleFonts.lato(
            textStyle:
                TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
        onDateChange: (d) {
          setState(() {
            date = d;
          });
        },
      ),
    );
  }

  _showTasks() {
    return Expanded(child: Obx(() {
      return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (context, index) {
            var task = _taskController.taskList[index];
            if (task.repeat == "Daily") {
              notifyHelper.scheduledNotification(
                int.parse(task.startTime.toString().split(':')[0]),
                int.parse(task.startTime.toString().split(':')[1].split(' ')[0]),
                task,
              );
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                    child: FadeInAnimation(
                      child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task)),
                    )),
              );
            }
            if (task.date == DateFormat.yMd().format(date)) {
              return AnimationConfiguration.staggeredList(
                position: index,
                child: SlideAnimation(
                    child: FadeInAnimation(
                  child: GestureDetector(
                      onTap: () {
                        _showBottomSheet(context, task);
                      },
                      child: TaskTile(task)),
                )),
              );
            } else {
              return Container();
            }
          });
    }));
  }

  _showBottomSheet(context, task) {
    Get.bottomSheet(Container(
        color: Get.isDarkMode ? Colors.white : Colors.black,
        padding: EdgeInsets.only(top: 20),
        height: MediaQuery.of(context).size.height * 0.32,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[200]),
            ),
            SizedBox(height: 30),
            Container(
                width: MediaQuery.of(context).size.width * 0.9,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.blue),
                    onPressed: () {
                      task.isCompleted == 1
                          ? _taskController.markTaskCompleted(task.id, 0)
                          : _taskController.markTaskCompleted(task.id, 1);
                      _taskController.getTasks();
                      Get.back();
                    },
                    child: Text(
                        task.isCompleted == 1
                            ? "Mark task as incomplete"
                            : "mark task as complete",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        )))),
            SizedBox(height: 10),
            Container(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      _taskController.delete(task);
                      _taskController.getTasks();
                      Get.back();
                    },
                    child: Text(
                      "Delete Task",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
            SizedBox(height: 30),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Get.isDarkMode ? Colors.black : Colors.white),
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Close Task",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              Get.isDarkMode ? Colors.white : Colors.black))),
            ),
          ],
        )));
  }

  _showStaggeredList(index, task) {
    return AnimationConfiguration.staggeredList(
      position: index,
      child: SlideAnimation(
          child: FadeInAnimation(
        child: GestureDetector(
            onTap: () {
              _showBottomSheet(context, task);
            },
            child: TaskTile(task)),
      )),
    );
  }
}
