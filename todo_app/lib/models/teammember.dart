import 'package:todo_app/models/task.dart';

class TeamMember {
  int? id;
  String? name;
  String? email;
  String? role;
  String? avatarUrl;
  List<Task>? assignedTasks;
  bool? isActive;

  TeamMember({
    this.id,
    this.name,
    this.email,
    this.role,
    this.avatarUrl,
    this.assignedTasks,
    this.isActive = true,
  });

  TeamMember copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? avatarUrl,
    List<Task>? assignedTasks,
    bool? isActive,
  }) {
    return TeamMember(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      assignedTasks: assignedTasks ?? this.assignedTasks,
      isActive: isActive ?? this.isActive,
    );
  }
}
