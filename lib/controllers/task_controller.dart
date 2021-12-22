import 'package:get/get.dart';
import 'package:tasks_theme_app/database/dbhelper.dart';
import 'package:tasks_theme_app/models/task_model.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => new Task.fromJSON(data)).toList());
  }

  void delete(Task task) async {
    DBHelper.delete(task);
  }

  void markTaskCompleted(int id, int status) async {
    await DBHelper.update(id, status);
  }

}