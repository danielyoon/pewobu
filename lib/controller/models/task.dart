class Task {
  final String title, description, subcategory;
  bool isCompleted;
  DateTime created;
  DateTime? due, completed;
  Task? dependency;

  Task(
      {required this.title,
      this.description = '',
      required this.subcategory,
      this.isCompleted = false,
      required this.created,
      this.due,
      this.completed,
      this.dependency});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
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
      description: json['description'] ?? '',
      subcategory: json['subcategory'],
      isCompleted: json['isCompleted'] ?? false,
      created: DateTime.parse(json['created']),
      due: json['due'] != null ? DateTime.parse(json['due']) : null,
      completed: json['completed'] != null ? DateTime.parse(json['completed']) : null,
      dependency: json['dependency'] != null ? Task.fromJson(json['dependency']) : null,
    );
  }
}
