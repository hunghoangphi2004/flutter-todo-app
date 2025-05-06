import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:todo_app/ui/widgets/input_field.dart';
import 'package:todo_app/controller/category_controller.dart'; // Import CategoryController

class AddTaskCategory extends StatefulWidget {
  const AddTaskCategory({Key? key}) : super(key: key);

  @override
  State<AddTaskCategory> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskCategory> {
  final CategoryController _categoryController = Get.find(); // Get CategoryController
  final TextEditingController _categoryNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  int _selectedColor = 0;

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
                controller: _categoryNameController,
                title: "Category Name",
                hint: "Enter category name here.",
              ),
              MyInputField(
                controller: _descriptionController,
                title: "Description",
                hint: "Enter description here.",
              ),
              SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _colorPalete(),
                  MyButton(
                    label: "Create Category",
                    onTap: () async {
                      if (_categoryNameController.text.isNotEmpty) {
                        await _categoryController.addCategory(
                          name: _categoryNameController.text,
                          description: _descriptionController.text,
                          color: _selectedColor.toString(),
                        );
                        // Reset input fields after adding category
                        _categoryNameController.clear();
                        _descriptionController.clear();

                        Navigator.pop(context);  // <<== Thêm dòng này để quay về HomePage
                      }
                    }
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _colorPalete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Color", style: titleStyle),
        SizedBox(height: 8),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryClr
                      : index == 1
                          ? pinkClr
                          : yellowClr,
                  child: _selectedColor == index
                      ? Icon(Icons.done, color: Colors.white, size: 16)
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
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
}
