import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:todo_app/controller/task_category_controller.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/input_field.dart';
import 'package:todo_app/models/task_category.dart';

class AddTaskCategory extends StatefulWidget {
  const AddTaskCategory({Key? key}) : super(key: key);

  @override
  State<AddTaskCategory> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskCategory> {
  final TaskCategoryController _categoryController = Get.put(
    TaskCategoryController(),
  );
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  Color _selectedColor = Colors.blue; // Màu mặc định

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Add Category Task", style: headingStyle),
              MyInputField(
                title: "Category Name",
                hint: "Enter category name here.",
                controller: _titleController,
              ),
              MyInputField(
                title: "Description",
                hint: "Enter description here.",
                controller: _descController,
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Color", style: titleStyle),
                      SizedBox(height: 8),
                      _colorPicker(),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 20),
                      MyButton(
                        label: "Create category",
                        onTap: () {
                          _validateCategoryData();
                          print(
                            'Category created with color: ${_selectedColor.toString()}',
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _colorPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            // Mở hộp chọn màu
            _pickColor();
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Center(child: Icon(Icons.edit, color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Choose a Color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor = color; // Cập nhật màu khi chọn
                });
              },
              showLabel: true, // Hiển thị tên màu
              pickerAreaHeightPercent: 0.8, // Chiều cao của vùng chọn màu
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại sau khi chọn
              },
            ),
          ],
        );
      },
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {},
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: [
        CircleAvatar(backgroundImage: AssetImage("images/profile.png")),
        SizedBox(width: 20),
      ],
    );
  }

  _validateCategoryData() {
    if (_titleController.text.isNotEmpty && _descController.text.isNotEmpty) {
      _addCategoryToDb();
      Get.back();
    } else {
      Get.snackbar(
        "Required",
        "All fields are required",
        snackPosition: SnackPosition.BOTTOM,
        icon: Icon(Icons.warning_amber_rounded, color: Colors.red),
        backgroundColor: Colors.white,
        colorText: pinkClr,
      );
    }
  }

  _addCategoryToDb() async {
    int value = await _categoryController.addCategory(
      TaskCategory(
        title: _titleController.text,
        description: _descController.text,
        color: _selectedColor.toARGB32(), // Chuyển màu về int
      ),
    );
    print("New category ID: $value");
    _categoryController.getCategories();
  }
}
