class TaskCategory {
  int? id;
  String? title;
  String? description;
  int? color;

  TaskCategory({this.id, this.title, this.description, this.color});

  TaskCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['color'] = this.color;
    return data;
  }
}
