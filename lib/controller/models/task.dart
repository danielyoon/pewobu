//TODO: Create dependency structure

class Task {
  final String title, description, subcategory;
  bool isCompleted;
  DateTime created;
  DateTime? due, completed;

  Task(
      {required this.title,
      this.description = '',
      required this.subcategory,
      this.isCompleted = false,
      required this.created,
      this.completed,
      this.due});
}
