import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:student_app/models/task.dart";
import "package:student_app/providers/user_provider.dart";
import "package:student_app/services/task_service.dart";
import "package:student_app/widgets/date_form_button.dart";
import "package:student_app/widgets/icon_with_text.dart";
import "package:student_app/widgets/transaction_form.dart";
import "package:student_app/utils.dart";

class CreateScheduleScreen extends StatefulWidget {
  final Task currentTask;

  CreateScheduleScreen({
    this.currentTask,
  });

  @override
  _CreateScheduleScreenState createState() => _CreateScheduleScreenState();
}

class _CreateScheduleScreenState extends State<CreateScheduleScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CustomFormField taskName;
  CustomFormField taskDescription;
  Task _task;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    taskName = CustomFormField(
      initialValue: widget.currentTask?.name,
      labelText: "Name",
    );
    taskDescription = CustomFormField(
      initialValue: widget.currentTask?.description,
      labelText: "Description",
    );

    _task = Task(
      id: widget.currentTask?.id,
      creatorId:
          Provider.of<UserProvider>(context, listen: false).currentUserID,
    );
  }

  Future<void> _saveForm(BuildContext context) async {
    final bool isValid = _formKey.currentState.validate();
    if (!isValid) return;

    _formKey.currentState.save();

    setState(() => _isLoading = true);

    String snackBarMessage = "";
    try {
      if (widget.currentTask == null) {
        await TaskService.createTask(_task);
        snackBarMessage = "Task added successfully";
      } else {
        await TaskService.updateTask(_task);
        snackBarMessage = "Task updated successfully";
      }
    } catch (e) {
      snackBarMessage = "Error occurs, please try again later";
    }

    setState(() => _isLoading = false);

    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(snackBarMessage),
      duration: Duration(seconds: 2),
    ));
  }

  String _getLabelFromValue(int priority) {
    switch (priority) {
      case 0:
        return "None";
      case 1:
        return "Low";
      case 2:
        return "Medium";
      default:
        return "High";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.currentTask == null ? "Add Task" : "Edit Task"),
          actions: <Widget>[
            Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.save),
                onPressed: _isLoading
                    ? null
                    : () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        await _saveForm(context);
                      },
              ),
            )
          ],
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15.0,
                  vertical: 10.0,
                ),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: taskName.labelText,
                        ),
                        initialValue: taskName.initialValue,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) => FocusScope.of(context)
                            .requestFocus(taskDescription.focusNode),
                        validator: (value) =>
                            value.isEmpty ? "Name should not be empty" : null,
                        onSaved: (value) => _task.updateName(value),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: taskDescription.labelText,
                        ),
                        initialValue: taskDescription.initialValue,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        focusNode: taskDescription.focusNode,
                        onSaved: (value) => _task.updateDescription(value),
                      ),
                      FormFieldTitle(text: "Due At"),
                      DateFormButton(
                        date: _task.dueAt,
                        onPressDateHandler: () async {
                          final DateTime newDate = await showDatePicker(
                            context: context,
                            initialDate: _task.dueAt,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (newDate != null) {
                            setState(() => _task.updateTaskDueDate(newDate));
                          }
                        },
                        onPressTimeHandler: () async {
                          final TimeOfDay newTime = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: _task.dueAt.hour,
                                  minute: _task.dueAt.minute));
                          if (newTime != null) {
                            setState(() => _task.updateTaskDueTime(newTime));
                          }
                        },
                      ),
                      FormFieldTitle(text: "Category"),
                      DropdownButtonFormField(
                        hint: IconWithTextWidget(
                          child: IconWithText(
                            text: _task.category,
                            icon: taskCategories[_task.category],
                          ),
                          marginWidth: 10.0,
                        ),
                        items: taskCategories.entries
                            .map((e) => DropdownMenuItem<String>(
                                  value: e.key,
                                  child: IconWithTextWidget(
                                      child: IconWithText(
                                        text: e.key,
                                        icon: taskCategories[e.key],
                                      ),
                                      marginWidth: 10.0),
                                ))
                            .toList(),
                        onChanged: (String e) {
                          setState(() => _task.updateCategory(e));
                        },
                      ),
                      FormFieldTitle(text: "Priority"),
                      Slider(
                        min: 0,
                        max: 3,
                        value: _task.priority.toDouble(),
                        divisions: 3,
                        label: _getLabelFromValue(_task.priority),
                        onChanged: (double value) {
                          setState(() => _task.priority = value.toInt());
                        },
                      ),
                    ],
                  ),
                ),
              ));
  }
}
