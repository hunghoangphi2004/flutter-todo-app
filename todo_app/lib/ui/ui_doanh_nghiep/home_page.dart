import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/controller/task_controller.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/notification_services.dart';
import 'package:todo_app/services/theme_services.dart';
import 'package:todo_app/ui/add_task_bar.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/ui_doanh_nghiep/team_members_screen.dart';
import 'package:todo_app/ui/widgets/button.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:todo_app/ui/widgets/task_tile.dart';

class MyHomePageBusiness extends StatefulWidget {
  final String title;

  const MyHomePageBusiness({required this.title, Key? key}) : super(key: key);

  @override
  State<MyHomePageBusiness> createState() => _MyHomePageBusinessState();
}

class _MyHomePageBusinessState extends State<MyHomePageBusiness> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestIOSPermissions();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context, notifyHelper),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          SizedBox(height: 10),
          // _showTasks(),
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
                Text("Business Tasks", style: headingStyle),
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
                label: "+ Add Members",
                onTap: () => Get.to(() => TeamMembersScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // _showTasks() {
  //   return Expanded(
  //     child: Obx(() {
  //       return ListView.builder(
  //         itemCount: _taskController.taskList.length,
  //         itemBuilder: (_, index) {
  //           Task task = _taskController.taskList[index];
  //           if (task.repeat == "Daily") {
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

  _bottomSheetButton({
    required String label,
    required Function() onTap,
    required Color clr,
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
            task.isCompleted != 1
                ? _bottomSheetButton(
                  label: "Assign Task",
                  onTap: () {
                    Get.back();
                    Get.to(() => TeamMembersScreen(taskToAssign: task));
                  },
                  clr: Colors.orange,
                  context: context,
                )
                : Container(),
            _bottomSheetButton(
              label: "Delete Task",
              onTap: () {
                _taskController.delete(task);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
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
      },
      child: Icon(
        Get.isDarkMode ? Icons.wb_sunny_outlined : Icons.nightlight_round,
        size: 20,
        color: Get.isDarkMode ? Colors.white : Colors.black,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(
          Icons.people,
          color: Get.isDarkMode ? Colors.white : Colors.black,
          size: 24,
        ),
        onPressed: () {
          Get.to(() => TeamMembersScreen());
        },
      ),
      CircleAvatar(backgroundImage: AssetImage("images/profile.png")),
      SizedBox(width: 20),
    ],
  );
}
