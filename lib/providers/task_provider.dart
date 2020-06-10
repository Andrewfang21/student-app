import "package:flutter/material.dart";
import "package:uuid/uuid.dart";
import "package:student_app/models/task.dart";

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

  void addTask(Task newTask) {
    _tasks.add(newTask);
    notifyListeners();
  }

  void updateTask(String id, Task editedTask) {
    final int index = _tasks.indexWhere((task) => task.id == id);
    print("$index -> ini index nya woi");
    if (index >= 0) {
      _tasks[index] = editedTask;
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }
}

List<Task> _tasks = [
  Task(
    id: Uuid().v4(),
    name: "ENGG2430 Homework",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?",
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
