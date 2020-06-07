import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import "package:student_app/models/task.dart";
import "package:student_app/utils.dart";

class TaskProvider with ChangeNotifier {
  List<Task> get tasks => [..._tasks];

  List<Task> getTasksDueAt(DateTime date) {
    return [..._tasks]
        .where((task) =>
            task.dueAt.day == date.day &&
            task.dueAt.month == date.month &&
            task.dueAt.year == date.year)
        .toList();
  }

  List<Task> getTasksWithCategory(String category) {
    return [..._tasks].where((task) => task.category == category).toList();
  }
}

List<Task> _tasks = [
  Task(
    id: Uuid().v4(),
    name: "ENGG2430 Homework",
    description: "Homework cuy",
    category: "Study",
    priority: 1,
    dueAt: DateTime.now(),
    createdAt: DateTime.now(),
  ),
  Task(
    id: Uuid().v4(),
    name: "Meeting",
    description: "Meeting cuy",
    category: "Work",
    priority: 1,
    dueAt: DateTime.now(),
    createdAt: DateTime.now(),
  ),
  Task(
    id: Uuid().v4(),
    name: "CSCI3100 Project",
    description: "Project cuy",
    category: "Study",
    priority: 1,
    dueAt: DateTime.now().add(Duration(days: 3)),
    createdAt: DateTime.now(),
  ),
  Task(
    id: Uuid().v4(),
    name: "Sleeping",
    description: "Tidur cuy",
    category: "Others",
    priority: 2,
    dueAt: DateTime.now().add(Duration(days: 7)),
    createdAt: DateTime.now(),
  ),
];
