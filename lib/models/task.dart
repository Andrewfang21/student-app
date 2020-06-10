import "package:flutter/material.dart";
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
        this.category = category ?? "Meeting",
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

  void updateTaskDueDate(DateTime newDate) {
    this.dueAt = DateTime(
      newDate.year,
      newDate.month,
      newDate.day,
      this.dueAt.hour,
      this.dueAt.minute,
    );
  }

  void updateTaskDueTime(TimeOfDay newTime) {
    this.dueAt = DateTime(
      this.dueAt.year,
      this.dueAt.month,
      this.dueAt.day,
      newTime.hour,
      newTime.minute,
    );
  }
}
