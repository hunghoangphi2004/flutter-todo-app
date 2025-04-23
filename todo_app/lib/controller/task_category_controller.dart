import 'package:get/get.dart';
import 'package:todo_app/db/db_helper.dart';
import 'package:todo_app/models/task_category.dart';
import 'package:todo_app/controller/task_controller.dart';

class TaskCategoryController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    getCategories();
  }

  var categoryList = <TaskCategory>[].obs; // Observable list of task categories
  final TaskController _taskController = Get.find<TaskController>();

  Future<int> addCategory(TaskCategory taskCategory) async {
    return await DBHelper.insertCategory(
      taskCategory,
    ); // Sử dụng taskCategory thay vì category
  }

  void getCategories() async {
    List<Map<String, dynamic>> categories = await DBHelper.queryCategories();
    categoryList.assignAll(
      categories.map((category) => TaskCategory.fromJson(category)).toList(),
    );
  }

  void deleteCategory(int id) async {
    await DBHelper.deleteCategory(id);
    getCategories(); // Refresh the category list after deletion
  }

  void updateCategory(TaskCategory category) async {
    await DBHelper.updateCategory(category);
    getCategories(); // Refresh the category list after update
  }

  void filterTasksByCategory(String? categoryTitle) {
    if (categoryTitle == null || categoryTitle == "All") {
      _taskController.getTasks();
    } else {
      _taskController.getTasksByCategory(categoryTitle);
    }
  }
}
