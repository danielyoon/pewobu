class Task {
  final String title, description;
  bool isCompleted;
  DateTime created;
  DateTime? due, completed;

  Task(
      {required this.title,
      required this.description,
      this.isCompleted = false,
      required this.created,
      this.completed,
      this.due});
}
