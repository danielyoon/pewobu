class Task {
  final String title, subcategory;
  bool isCompleted;
  DateTime created;
  DateTime? due, completed;
  List<Task> dependencies;
  int? dependencyIndex;

  Task({
    required this.title,
    required this.subcategory,
    this.isCompleted = false,
    required this.created,
    this.due,
    this.completed,
    required this.dependencies,
    this.dependencyIndex,
  });

  void toggleTask() {
    isCompleted = !isCompleted;
    completed = isCompleted ? DateTime.now() : null;
  }

  void addDependency(Task task) {
    dependencies.add(task);
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subcategory': subcategory,
      'isCompleted': isCompleted,
      'created': created.toIso8601String(),
      'due': due?.toIso8601String(),
      'completed': completed?.toIso8601String(),
      'dependencies': dependencies.map((task) => task.toJson()).toList(),
      'dependencyIndex': dependencyIndex,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    var dependenciesJson = json['dependencies'] as List?;
    List<Task> dependencies =
        dependenciesJson != null ? dependenciesJson.map((taskJson) => Task.fromJson(taskJson)).toList() : [];
    return Task(
      title: json['title'],
      subcategory: json['subcategory'],
      isCompleted: json['isCompleted'] ?? false,
      created: DateTime.parse(json['created']),
      due: json['due'] != null ? DateTime.parse(json['due']) : null,
      completed: json['completed'] != null ? DateTime.parse(json['completed']) : null,
      dependencies: dependencies,
      dependencyIndex: json['dependencyIndex'],
    );
  }
}
