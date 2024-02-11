class Task {
  final String title, subcategory;
  bool isCompleted;
  DateTime created;
  DateTime? due, completed;
  List<Task> dependencies;
  String? dependentOn;
  int? rootIndex;

  Task({
    required this.title,
    required this.subcategory,
    this.isCompleted = false,
    required this.created,
    this.due,
    this.completed,
    required this.dependencies,
    this.dependentOn,
    this.rootIndex,
  }) : assert((dependentOn == null && rootIndex == null) || (dependentOn != null && rootIndex != null),
            'Both parameters must be set or not set together.');

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
      'dependentOn': dependentOn,
      'rootIndex': rootIndex,
    };
  }

  static Task fromJson(Map<String, dynamic> json) => Task(
        title: json['title'],
        subcategory: json['subcategory'],
        isCompleted: json['isCompleted'],
        created: DateTime.parse(json['created']),
        due: json['due'] != null ? DateTime.parse(json['due']) : null,
        completed: json['completed'] != null ? DateTime.parse(json['completed']) : null,
        dependencies: (json['dependencies'] as List).map((e) => Task.fromJson(e)).toList(),
        dependentOn: json['dependentOn'],
        rootIndex: json['rootIndex'],
      );
}
