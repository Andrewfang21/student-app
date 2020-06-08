import "package:uuid/uuid.dart";

class Task {
  String id;
  String name;
  String description;
  String category;
  int priority;
  DateTime dueAt;
  DateTime createdAt;
  bool isCompleted;

  Task({
    id,
    name,
    description,
    category,
    priority,
    dueAt,
    createdAt,
  })  : this.id = id ?? Uuid().v4(),
        this.name = name ?? "",
        this.description = description ?? "",
        this.category = category,
        this.priority = priority ?? 3,
        this.dueAt = dueAt ?? DateTime.now(),
        this.createdAt = DateTime.now(),
        this.isCompleted = false;

  void updateName(String name) {
    this.name = name;
  }

  void updateDescription(String description) {
    this.description = description;
  }

  void updateCategory(String category) {
    this.category = category;
  }

  void updatePriority(int priority) {
    this.priority = priority;
  }

  void updateTaskDue(DateTime dueDate) {
    this.dueAt = dueDate;
  }
}
