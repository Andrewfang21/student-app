import "package:flutter/foundation.dart";
import "package:uuid/uuid.dart";

class Task with ChangeNotifier {
  String id;
  String name;
  String description;
  String category;
  String priority;
  DateTime dueAt;
  DateTime createdAt;

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
        this.dueAt = dueAt ?? DateTime.now(),
        this.createdAt = DateTime.now();

  void updateName(String name) {
    this.name = name;
  }

  void updateDescription(String description) {
    this.description = description;
  }

  void updateCategory(String category) {
    this.category = category;
  }

  void updatePriority(String priority) {
    this.priority = priority;
  }

  void updateTaskDue(DateTime dueDate) {
    this.dueAt = dueDate;
  }
}