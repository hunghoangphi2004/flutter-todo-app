import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/task_category.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/add_task_bar.dart';
import 'package:todo_app/ui/add_task_category.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';
import 'package:todo_app/ui/widgets/category_filter.dart';
import 'package:todo_app/controller/task_category_controller.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  const MyHomePage({required this.title, super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper; // Đảm bảo biến không null
  // String _selectedTaskCategory = "All";
  TaskCategory? _selectedTaskCategory;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper(); // Khởi tạo NotifyHelper
    notifyHelper.initializeNotification(); // Khởi tạo thông báo
    notifyHelper.requestIOSPermissions(); // Yêu cầu quyền trên iOS
    _taskController.getTasks();
    final _categoryController = Get.put(TaskCategoryController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, notifyHelper), // Truyền notifyHelper vào AppBar
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10),
          _filterTasksByCategory(),
          SizedBox(height: 10),
          _showTasks(),
        ],
      ),
    );
  }

  _filterTasksByCategory() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: CategoryDropdown(
        selectedCategory: _selectedTaskCategory,
        onChanged: (selectedCategory) {
          setState(() {
            _selectedTaskCategory = selectedCategory;
          });

          // Gọi lại phương thức filterTasksByCategory khi thay đổi category
          if (selectedCategory == null || selectedCategory.id == -1) {
            _taskController.getTasks(); // Lấy tất cả các task khi chọn "All"
          } else {
            _taskController.getTasksByCategory(
              selectedCategory.title!,
            ); // Lọc theo danh mục
          }
        },
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
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(
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

  // _addTaskBar() {
  //   return Container(
  //     margin: EdgeInsets.only(left: 20, right: 20, top: 10),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Container(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 DateFormat.yMMMMd().format(DateTime.now()),
  //                 style: subHeadingStyle,
  //               ),
  //               Text("Today", style: headingStyle),
  //             ],
  //           ),
  //         ),
  //         Column(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           children: [
  //             MyButton(
  //               label: "+ Add Task",
  //               onTap: () async {
  //                 await Get.to(() => AddTaskPage());
  //                 _taskController.getTasks();
  //               },
  //             ),
  //             SizedBox(height: 10),
  //             MyButton1(
  //               label: "+ Add Category",
  //               onTap: () => Get.to(AddTaskCategory()),
  //             ),
  //           ],
  //         ),
  //       ],
  //     ),
  //   );
  // }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text("Today", style: headingStyle),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              MyButton(
                label: "+ Add Task",
                onTap: () async {
                  await Get.to(() => AddTaskPage());
                  _taskController.getTasks();
                },
              ),
              SizedBox(height: 10),
              MyButton1(
                label: "+ Add Category",
                onTap: () => Get.to(AddTaskCategory()),
              ),
              SizedBox(height: 10),
              // MyButton1(
              //   label: "View Categories",
              //   onTap:
              //       () =>
              //           Get.to(() => TaskCategoryList()),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  // _showTasks() {
  //   return Expanded(
  //     child: Obx(() {
  //       print("taskList length: ${_taskController.taskList.length}");
  //       return ListView.builder(
  //         itemCount: _taskController.taskList.length,

  //         itemBuilder: (_, index) {
  //           Task task = _taskController.taskList[index];
  //           if (task.repeat == "Daily") {
  //             // DateTime date = DateFormat.jm().parse(task.startTime.toString());
  //             // var myTime = DateFormat("HH:mm").format(date);
  //             // print(myTime);
  //             // notifyHelper.scheduledNotification(
  //             //   int.parse(myTime.toString().split(":")[0]),
  //             //   int.parse(myTime.toString().split(":")[1]),
  //             //   task,
  //             // );
  //             return AnimationConfiguration.staggeredList(
  //               position: index,
  //               child: SlideAnimation(
  //                 child: FadeInAnimation(
  //                   child: Row(
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           _showBottomSheet(context, task);
  //                         },
  //                         child: TaskTile(task),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           }
  //           if (task.date == DateFormat.yMd().format(_selectedDate)) {
  //             return AnimationConfiguration.staggeredList(
  //               position: index,
  //               child: SlideAnimation(
  //                 child: FadeInAnimation(
  //                   child: Row(
  //                     children: [
  //                       GestureDetector(
  //                         onTap: () {
  //                           _showBottomSheet(context, task);
  //                         },
  //                         child: TaskTile(task),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             );
  //           } else {
  //             return Container();
  //           }
  //         },
  //       );
  //     }),
  //   );
  // }
  _showTasks() {
    return Expanded(
      child: Obx(() {
        print("taskList length: ${_taskController.taskList.length}");

        // Lọc các task theo category được chọn
        List<Task> filteredTasks =
            _taskController.taskList.where((task) {
              // Nếu không chọn "All", mới lọc theo category
              if (_selectedTaskCategory != null &&
                  _selectedTaskCategory!.id != -1 &&
                  task.category != _selectedTaskCategory!.title) {
                return false;
              }

              // Lọc theo ngày hoặc Daily
              if (task.repeat == "Daily" ||
                  task.date == DateFormat.yMd().format(_selectedDate)) {
                return true;
              }

              return false;
            }).toList();

        // Nếu không có task nào trong danh mục được chọn
        if (filteredTasks.isEmpty) {
          return Center(
            child: Text(
              "No tasks available in this category", // Thông báo khi không có task
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        // Nếu có task, hiển thị danh sách
        return ListView.builder(
          itemCount: filteredTasks.length,
          itemBuilder: (_, index) {
            Task task = filteredTasks[index];

            return AnimationConfiguration.staggeredList(
              position: index,
              child: SlideAnimation(
                child: FadeInAnimation(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showBottomSheet(context, task);
                        },
                        child: TaskTile(task),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  _bottomSheetButton({
    required label,
    required onTap,
    required clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,

        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color:
                isClose == true
                    ? Get.isDarkMode
                        ? Colors.grey[600]!
                        : Colors.grey[300]!
                    : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),

        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height:
            task.isCompleted == 1
                ? MediaQuery.of(context).size.height * 0.24
                : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                  label: "Task Completed",
                  onTap: () {
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  },
                  clr: primaryClr,
                  context: context,
                ),
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.delete(task);

                Get.back();
              },
              clr: Colors.red[300],

              context: context,
            ),
            SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300],
              isClose: true,
              context: context,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
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

        // notifyHelper.scheduledNotification();
      },
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
