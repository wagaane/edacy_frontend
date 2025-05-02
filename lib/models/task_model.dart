class TaskModel {
  final int id;
  final String title;
  final String description;
  late  bool selected;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.selected,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      selected: false
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }

  static List<TaskModel> fromList(List<dynamic> list) {
    return list.map((e) => TaskModel.fromJson(e)).toList();
  }
}
