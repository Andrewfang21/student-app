import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/models/task.dart";
import "package:student_app/providers/user_provider.dart";
import "package:student_app/screens/task_form_screen.dart";
import "package:student_app/widgets/transaction_form.dart";

class TaskCreateScreen extends StatelessWidget {
  final CustomForm _form = CustomForm();

  @override
  Widget build(BuildContext context) {
    final TaskModel currentTask = TaskModel(
      creatorId:
          Provider.of<UserProvider>(context, listen: false).currentUserID,
    );

    return TaskFormScreen(
      context: "Add",
      form: _form,
      task: currentTask,
    );
  }
}
