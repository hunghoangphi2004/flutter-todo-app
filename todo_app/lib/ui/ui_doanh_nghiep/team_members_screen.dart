import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/controller/teammember_controller.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/ui/ui_doanh_nghiep/member_dialogs.dart';
import 'package:todo_app/ui/widgets/member_card.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TeamMembersScreen extends StatelessWidget {
  final Task? taskToAssign;
  final TeamMembersController _controller = Get.put(TeamMembersController());

  TeamMembersScreen({this.taskToAssign, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          taskToAssign != null ? "Assign Task" : "Team Members",
          style: GoogleFonts.lato(
            textStyle: TextStyle(
              color: Get.isDarkMode ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add,
              color: Get.isDarkMode ? Colors.white : Colors.black,
            ),
            onPressed: () {
              MemberDialogs.showAddMemberDialog(context);
            },
          ),
        ],
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          if (taskToAssign != null) _buildTaskAssignmentHeader(context),
          SizedBox(height: 10),
          _buildMembersList(),
        ],
      ),
    );
  }

  Widget _buildTaskAssignmentHeader(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _getBGClr(taskToAssign!.color),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Assigning Task:",
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 5),
          Text(
            taskToAssign!.title ?? 'untitled',
            style: GoogleFonts.lato(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMembersList() {
    return Expanded(
      child: Obx(() {
        return AnimationLimiter(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 10),
            itemCount: _controller.members.length,
            itemBuilder: (context, index) {
              final member = _controller.members[index];
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: const Duration(milliseconds: 375),
                child: SlideAnimation(
                  verticalOffset: 50.0,
                  child: FadeInAnimation(
                    child: MemberCard(
                      member: member,
                      taskToAssign: taskToAssign,
                      controller: _controller,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Color _getBGClr(int? color) {
    switch (color) {
      case 0:
        return bluishClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }
}
