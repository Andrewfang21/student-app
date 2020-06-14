import "package:flutter/material.dart";

class TaskModel {
  String id;
  String name;
  String description;
  String category;
  int priority;
  DateTime dueAt;
  DateTime createdAt;
  bool isCompleted;
  String creatorId;

  TaskModel({
    id,
    name,
    description,
    category,
    priority,
    dueAt,
    createdAt,
    @required this.creatorId,
  })  : this.id = id,
        this.name = name ?? "",
        this.description = description ?? "",
        this.category = category ?? "Meeting",
        this.priority = priority ?? 3,
        this.dueAt = dueAt ?? DateTime.now(),
        this.createdAt = DateTime.now(),
        this.isCompleted = false;

  TaskModel.fromJson(String id, Map<String, dynamic> json) {
    if (json != null) {
      this.id = id;
      this.name = json["name"];
      this.description = json["description"];
      this.category = json["category"];
      this.priority = json["priority"];
      this.dueAt = DateTime.parse(json["dueAt"].toDate().toString());
      this.createdAt = DateTime.parse(json["createdAt"].toDate().toString());
      this.creatorId = json["creatorId"];
    }
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "category": category,
        "priority": priority,
        "dueAt": dueAt,
        "createdAt": createdAt,
        "creatorId": creatorId,
      };

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
