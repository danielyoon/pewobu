class Task {
  final String title, subcategory;
  bool isCompleted;
  DateTime created;
  DateTime? due, completed;
  Task? dependency;

  Task(
      {required this.title,
      required this.subcategory,
      this.isCompleted = false,
      required this.created,
      this.due,
      this.completed,
      this.dependency});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subcategory': subcategory,
      'isCompleted': isCompleted,
      'created': created.toIso8601String(),
      'due': due?.toIso8601String(),
      'completed': completed?.toIso8601String(),
      'dependency': dependency?.toJson(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      subcategory: json['subcategory'],
      isCompleted: json['isCompleted'] ?? false,
      created: DateTime.parse(json['created']),
      due: json['due'] != null ? DateTime.parse(json['due']) : null,
      completed: json['completed'] != null ? DateTime.parse(json['completed']) : null,
      dependency: json['dependency'] != null ? Task.fromJson(json['dependency']) : null,
    );
  }
}
