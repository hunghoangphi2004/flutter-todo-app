import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/teammember.dart';

class TeamMembersController extends GetxController {
  var members =
      <TeamMember>[
        TeamMember(
          id: 1,
          name: "nhan vien 1",
          email: "v1@example.com",
          role: "Project Manager",
          avatarUrl: "images/profile.png",
          assignedTasks: [],
          isActive: true,
        ),
        TeamMember(
          id: 2,
          name: "nhan vien 2",
          email: "nv2@example.com",
          role: "Developer",
          avatarUrl: "images/profile.png",
          assignedTasks: [],
          isActive: true,
        ),
        TeamMember(
          id: 3,
          name: "nhan vien 3",
          email: "nvc@example.com",
          role: "Designer",
          avatarUrl: "images/profile.png",
          assignedTasks: [],
          isActive: true,
        ),
      ].obs;

  void addMember(TeamMember member) {
    members.add(member);
    update();
  }

  void removeMember(int id) {
    members.removeWhere((member) => member.id == id);
    update();
  }

  void assignTask(int memberId, Task task) {
    final index = members.indexWhere((member) => member.id == memberId);
    if (index != -1) {
      // Create a new list with the updated member
      final updatedMembers = List<TeamMember>.from(members);
      final updatedMember = TeamMember(
        id: members[index].id,
        name: members[index].name,
        email: members[index].email,
        role: members[index].role,
        avatarUrl: members[index].avatarUrl,
        isActive: members[index].isActive,
        assignedTasks: [...?members[index].assignedTasks, task],
      );
      updatedMembers[index] = updatedMember;

      // Update the observable list
      members.value = updatedMembers;
      Get.snackbar(
        "Task Assigned",
        "Task successfully assigned to ${members[index].name}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: EdgeInsets.all(10),
      );
    }
  }

  void toggleMemberStatus(int id) {
    final index = members.indexWhere((member) => member.id == id);
    if (index != -1) {
      final updatedMembers = List<TeamMember>.from(members);
      final updatedMember = TeamMember(
        id: members[index].id,
        name: members[index].name,
        email: members[index].email,
        role: members[index].role,
        avatarUrl: members[index].avatarUrl,
        assignedTasks: members[index].assignedTasks,
        isActive: members[index].isActive ?? false,
      );
      updatedMembers[index] = updatedMember;
      members.value = updatedMembers;
    }
  }
}
