import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/models/task_category.dart';
import 'package:todo_app/controller/task_category_controller.dart';

class CategoryDropdown extends StatelessWidget {
  final TaskCategory? selectedCategory;
  final Function(TaskCategory?) onChanged;

  CategoryDropdown({required this.selectedCategory, required this.onChanged});

  final TaskCategoryController _controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Tạo danh sách danh mục gồm "All" và các category từ controller
      final List<TaskCategory> categories = [
        TaskCategory(id: -1, title: "All"),
        ..._controller.categoryList,
      ];

      // Kiểm tra xem selectedCategory có hợp lệ không, nếu không, chọn "All"
      TaskCategory currentCategory = selectedCategory ?? categories[0];

      // Nếu selectedCategory không phải là một giá trị hợp lệ trong categories
      if (!categories.contains(currentCategory)) {
        currentCategory = categories[0]; // Chọn "All" mặc định
      }

      return DropdownButton<TaskCategory>(
        isExpanded: true,
        value: currentCategory, // Hiển thị giá trị đang chọn
        items:
            categories.map((category) {
              return DropdownMenuItem<TaskCategory>(
                value: category,
                child: Text(category.title ?? ''),
              );
            }).toList(),
        onChanged: (TaskCategory? newValue) {
          onChanged(newValue);
        },
      );
    });
  }
}
