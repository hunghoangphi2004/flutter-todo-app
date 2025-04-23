import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/models/teammember.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/controller/teammember_controller.dart';

class MemberDialogs {
  static Color _getBGClr(int? color) {
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

  static void showAddMemberDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final roleController = TextEditingController();
    final controller = Get.find<TeamMembersController>();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? darkGreyClr : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add Team Member",
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: nameController,
                style: GoogleFonts.lato(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: GoogleFonts.lato(
                    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: emailController,
                style: GoogleFonts.lato(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: GoogleFonts.lato(
                    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: roleController,
                style: GoogleFonts.lato(
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  labelText: "Role",
                  labelStyle: GoogleFonts.lato(
                    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.lato(color: Colors.red),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryClr,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (nameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          roleController.text.isNotEmpty) {
                        final newMember = TeamMember(
                          id: DateTime.now().millisecondsSinceEpoch,
                          name: nameController.text,
                          email: emailController.text,
                          role: roleController.text,
                          avatarUrl: "images/profile.png",
                          assignedTasks: [],
                        );
                        controller.addMember(newMember);
                        Get.back();
                      } else {
                        Get.snackbar(
                          "Error",
                          "All fields are required",
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text(
                      "Add Member",
                      style: GoogleFonts.lato(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showMemberTasks(BuildContext context, TeamMember member) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? darkGreyClr : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(
                      member.avatarUrl ?? 'images/profile.png',
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        member.name ?? 'unnamed',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        member.role ?? 'no role',
                        style: GoogleFonts.lato(
                          fontSize: 14,
                          color:
                              Get.isDarkMode
                                  ? Colors.grey[400]
                                  : Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Assigned Tasks",
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 10),
              Flexible(
                child: Container(
                  constraints: BoxConstraints(maxHeight: 300),
                  child:
                      member.assignedTasks?.isEmpty ?? false
                          ? Center(
                            child: Text(
                              "No tasks assigned yet",
                              style: GoogleFonts.lato(
                                color:
                                    Get.isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
                              ),
                            ),
                          )
                          : ListView.builder(
                            shrinkWrap: true,
                            itemCount: member.assignedTasks?.length ?? 0,
                            itemBuilder: (context, index) {
                              final task = member.assignedTasks?[index];
                              return Container(
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _getBGClr(task?.color),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task?.title ?? 'untitled',
                                      style: GoogleFonts.lato(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "${task?.startTime} - ${task?.endTime}",
                                          style: GoogleFonts.lato(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                ),
              ),
              SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Close",
                  style: GoogleFonts.lato(
                    color: primaryClr,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showDeleteConfirmation(
    BuildContext context,
    TeamMember member,
    TeamMembersController controller,
  ) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Get.isDarkMode ? darkGreyClr : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 50),
              SizedBox(height: 15),
              Text(
                "Remove Member",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Get.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Are you sure you want to remove ${member.name} from the team?",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.lato(
                        color: primaryClr,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      controller.removeMember(member.id ?? 0);
                      Get.back();
                      Get.snackbar(
                        "Member Removed",
                        "${member.name} has been removed from the team",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                        margin: EdgeInsets.all(10),
                      );
                    },
                    child: Text(
                      "Remove",
                      style: GoogleFonts.lato(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
