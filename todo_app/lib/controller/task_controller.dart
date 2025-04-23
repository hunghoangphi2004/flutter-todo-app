import 'package:get/get.dart';
import 'package:todo_app/db/db_helper.dart';
import 'package:todo_app/models/task.dart';

class TaskController extends GetxController {
  @override
  void onReady() {
    super.onReady();
  }

  var taskList = <Task>[].obs; // Observable list of tasks

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((task) => Task.fromJson(task)).toList());
  }

  void delete(Task task) {
    DBHelper.delete(task);
    getTasks(); // Refresh the task list after deletion
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks(); // Refresh the task list after marking as completed
  }

  // void getTasksByCategory(String category) async {
  //   List<Map<String, dynamic>> tasks = await DBHelper.queryTasksByCategory(
  //     category,
  //   );
  //   taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  // }

  void getTasksByCategory(String category) async {
    List<Map<String, dynamic>> tasks;

    if (category == "All") {
      // Nếu chọn "All", lấy tất cả nhiệm vụ
      tasks = await DBHelper.query();
    } else {
      // Lọc nhiệm vụ theo danh mục
      tasks = await DBHelper.queryTasksByCategory(category);
    }

    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }
}
