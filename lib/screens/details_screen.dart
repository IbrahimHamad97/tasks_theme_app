import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailsScreen extends StatelessWidget {
  final String payload;

  const DetailsScreen({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.theme.backgroundColor,
        elevation: 0,
        title: Text(
          payload.toString().split('|')[0],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.black : Colors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () => Get.back()),
      ),
      body: Center(
        child: Text(
          payload.toString().split('|')[1],
          style: TextStyle(
            color: Get.isDarkMode ? Colors.black : Colors.black,
          ),
        ),
      ),
    );
  }
}
