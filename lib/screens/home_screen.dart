import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tasks_theme_app/screens/tasks_screen.dart';
import 'package:tasks_theme_app/services/notifications_service.dart';
import 'package:tasks_theme_app/services/theme_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var notifyHelper;

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
    return Scaffold(
      backgroundColor: context.theme.backgroundColor,
      appBar: _appBar(),
      body: TasksScreen(),
    );
  }

  _appBar() {
    return AppBar(
      backgroundColor: context.theme.backgroundColor,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed!",
              body: Get.isDarkMode ? "White Theme" : "Dark Theme");
        },
        child: Icon(
          ThemeService().theme.toString() == 'ThemeMode.dark'
              ? Icons.wb_sunny_outlined
              : Icons.dark_mode_outlined,
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
}
