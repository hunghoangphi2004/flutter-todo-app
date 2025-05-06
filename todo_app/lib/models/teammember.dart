// class Task {
//   int? id;
//   String title;
//   String? note;
//   int? isCompleted;
//   String? date;
//   String? startTime;
//   String? endTime;
//   int? color;
//   int? remind;
//   String? repeat;
//   String? category;

//   Task({
//     this.id,
//     required this.title,
//     this.note,
//     this.isCompleted,
//     this.date,
//     this.startTime,
//     this.endTime,
//     this.color,
//     this.remind,
//     this.repeat,
//     this.category,
//   });

//   // Task.fromJson(Map<String, dynamic> json) {
//   //   id = json['id'];
//   //   title = json['title'];
//   //   note = json['note'];
//   //   isCompleted = json['isCompleted'];
//   //   date = json['date'];
//   //   startTime = json['startTime'];
//   //   endTime = json['endTime'];
//   //   color = json['color'];
//   //   remind = json['remind'];
//   //   repeat = json['repeat'];
//   //   category = json['category'];
//   // }

//   Task.fromJson(Map<String, dynamic> json)
//     : title = json['title'] ?? 'Untitled' {
//     id = json['id'];
//     note = json['note'];
//     isCompleted = json['isCompleted'];
//     date = json['date'];
//     startTime = json['startTime'];
//     endTime = json['endTime'];
//     color = json['color'];
//     remind = json['remind'];
//     repeat = json['repeat'];
//     category = json['category'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['note'] = this.note;
//     data['isCompleted'] = this.isCompleted;
//     data['date'] = this.date;
//     data['startTime'] = this.startTime;
//     data['endTime'] = this.endTime;
//     data['color'] = this.color;
//     data['remind'] = this.remind;
//     data['repeat'] = this.repeat;
//     data['category'] = this.category;
//     return data;
//   }
// }

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
