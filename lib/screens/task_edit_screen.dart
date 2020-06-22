import "package:flutter/material.dart";
import "package:student_app/models/task.dart";
import "package:student_app/screens/task_form_screen.dart";
import "package:student_app/widgets/transaction_form.dart";

class TaskEditScreen extends StatelessWidget {
  final TaskModel currentTask;
  final CustomForm _form;

  TaskEditScreen({
    @required this.currentTask,
  }) : _form = CustomForm();

  @override
  Widget build(BuildContext context) {
    return TaskFormScreen(
      context: "Edit",
      form: _form,
      task: currentTask,
    );
  }
}
