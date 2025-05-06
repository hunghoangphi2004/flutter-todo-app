import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/controller/category_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:todo_app/ui/add_task_bar.dart';
import 'package:todo_app/ui/add_task_category.dart';
import 'package:todo_app/ui/widgets/category_tile.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({required this.title, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  final _categoryController = Get.put(CategoryController());
  late NotifyHelper notifyHelper;
  String selectedCategory = "Tất cả";


  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
    _categoryController.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, notifyHelper),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateOptions(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          const SizedBox(height: 10),
          _showCategory(), 
          const SizedBox(height: 10),
          Flexible(child: _showTasks()),
        ],
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text("Today", style: headingStyle),
            ],
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }
  
 _showCategory() {
    return Obx(() {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CategoryTile(
                "Tất cả",
                isSelected: selectedCategory == "Tất cả",
                onTap: () {
                  setState(() {
                    selectedCategory = "Tất cả";
                  });
                },
              ),
            ),
            ...List.generate(
              _categoryController.categoryList.length,
              (index) {
                String categoryName = _categoryController.categoryList[index]['name'];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CategoryTile(
                    categoryName,
                    isSelected: selectedCategory == categoryName,
                    onTap: () {
                      setState(() {
                        selectedCategory = categoryName;
                      });
                    },
                  ),
                );
              },
            ),
          ],
        ),
      );
    });
  }


  _showTasks() {
    return Obx(() {
      final filteredTasks = _taskController.taskList.where((task) {
        final isSameDate = task.repeat == "Daily" || task.date == DateFormat.yMd().format(_selectedDate);
        final isCategoryMatch = selectedCategory == "Tất cả" || task.category == selectedCategory;
        return isSameDate && isCategoryMatch;
      }).toList();

      return ListView.builder(
        itemCount: filteredTasks.length,
        itemBuilder: (_, index) {
          Task task = filteredTasks[index];
          return AnimationConfiguration.staggeredList(
            position: index,
            child: SlideAnimation(
              child: FadeInAnimation(
                child: GestureDetector(
                  onTap: () => _showTaskBottomSheet(context, task),
                  child: TaskTile(task),
                ),
              ),
            ),
          );
        },
      );
    });
  }


  _showCreateOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              _buildOption(
                icon: Icons.edit_note,
                text: 'Create Task',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskPage()));
                },
              ),
              _buildOption(
                icon: Icons.add_box_outlined,
                text: 'Create Category',
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddTaskCategory()),
                  );
                  _categoryController.getCategories();  // <<< Thêm dòng này!
                },
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                onPressed: () => Navigator.pop(context),
                backgroundColor: primaryClr,
                child: const Icon(Icons.close),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption({required IconData icon, required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: primaryClr),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  _showTaskBottomSheet(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 20),
              if (task.isCompleted != 1)
                _buildBottomOption(
                  icon: Icons.check_circle_outline,
                  text: "Mark as Completed",
                  color: primaryClr,
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Navigator.pop(context);
                  },
                ),
              _buildBottomOption(
                icon: Icons.delete_outline,
                text: "Delete Task",
                color: Colors.red[400]!,
                onTap: () {
                  _taskController.delete(task);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
              FloatingActionButton(
                backgroundColor: primaryClr,
                onPressed: () => Navigator.pop(context),
                child: const Icon(Icons.close),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomOption({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context, NotifyHelper notifyHelper) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          notifyHelper.displayNotification(
            title: "Theme Changed",
            body:
                Get.isDarkMode ? "Dark Theme Activated" : "Light Theme Activated",
          );
        },
        child: Icon(
          Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(backgroundImage: AssetImage("images/profile.png")),
        SizedBox(width: 20),
      ],
    );
  }
}
