// widgets/member_card.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/teammember.dart';
import 'package:todo_app/ui/theme.dart';
import 'package:todo_app/controller/teammember_controller.dart';
import 'package:todo_app/ui/ui_doanh_nghiep/member_dialogs.dart';

class MemberCard extends StatelessWidget {
  final TeamMember member;
  final Task? taskToAssign;
  final TeamMembersController controller;

  const MemberCard({
    Key? key,
    required this.member,
    this.taskToAssign,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: AssetImage(member.avatarUrl ?? 'images/profile.png'),
          backgroundColor:
              member.isActive ?? false ? Colors.green : Colors.grey,
        ),
        title: Text(
          member.name ?? 'unnamed',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Get.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              member.email ?? 'null@gmail.com',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700],
              ),
            ),
            SizedBox(height: 2),
            Text(
              member.role ?? 'no olre',
              style: GoogleFonts.lato(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: primaryClr,
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.assignment,
                  size: 14,
                  color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
                SizedBox(width: 4),
                Text(
                  "${member.assignedTasks?.length ?? 0} Task(s)",
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    color: Get.isDarkMode ? Colors.grey[400] : Colors.grey[700],
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color:
                        member.isActive ?? false ? Colors.green : Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    member.isActive ?? false ? "Active" : "Inactive",
                    style: GoogleFonts.lato(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing:
            taskToAssign != null
                ? IconButton(
                  icon: Icon(Icons.assignment_turned_in, color: primaryClr),
                  onPressed: () {
                    controller.assignTask(member.id ?? 0, taskToAssign!);
                  },
                )
                : PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: Get.isDarkMode ? Colors.white : Colors.black,
                  ),
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(value: 'view', child: Text("View Tasks")),
                        PopupMenuItem(
                          value: 'status',
                          child: Text(
                            member.isActive ?? false
                                ? "Set Active"
                                : "Set Inactive",
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Text("Remove Member"),
                        ),
                      ],
                  onSelected: (value) {
                    if (value == 'view') {
                      MemberDialogs.showMemberTasks(context, member);
                    } else if (value == 'status') {
                      controller.toggleMemberStatus(member.id ?? 0);
                    } else if (value == 'delete') {
                      MemberDialogs.showDeleteConfirmation(
                        context,
                        member,
                        controller,
                      );
                    }
                  },
                ),
      ),
    );
  }
}
