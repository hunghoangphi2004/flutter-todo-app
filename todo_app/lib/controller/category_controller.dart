import 'package:get/get.dart';
import 'package:todo_app/db/db_helper.dart';

class CategoryController extends GetxController {
  // Observable list để chứa danh sách categories
  var categoryList = <Map<String, dynamic>>[].obs;

  @override
  void onReady() {
    super.onReady();
    getCategories(); // Lấy danh sách categories khi controller được tạo
  }

  // Phương thức để thêm category mới
  Future<void> addCategory({required String name, required String description, required String color}) async {
    try {
      await DBHelper.insertCategory(name, description, color);
      getCategories(); // Lấy lại danh sách categories sau khi thêm
    } catch (e) {
      print("Error adding category: $e");
      // Có thể thêm thông báo lỗi cho người dùng nếu cần
    }
  }

  // Phương thức để lấy tất cả categories
  void getCategories() async {
    try {
      List<Map<String, dynamic>> categories = await DBHelper.queryCategories();
      categoryList.assignAll(categories); // Cập nhật danh sách category
    } catch (e) {
      print("Error fetching categories: $e");
      // Thêm thông báo lỗi cho người dùng nếu cần
    }
  }

  // Phương thức để xóa một category
  Future<void> deleteCategory(int id) async {
    try {
      await DBHelper.deleteCategory(id);
      getCategories(); // Lấy lại danh sách categories sau khi xóa
    } catch (e) {
      print("Error deleting category: $e");
      // Thêm thông báo lỗi cho người dùng nếu cần
    }
  }

  // Phương thức để cập nhật category
  Future<void> updateCategory(int id, String name, String description, String color) async {
    try {
      await DBHelper.updateCategory(id, name, description, color);
      getCategories(); // Lấy lại danh sách categories sau khi cập nhật
    } catch (e) {
      print("Error updating category: $e");
      // Thêm thông báo lỗi cho người dùng nếu cần
    }
  }
}
