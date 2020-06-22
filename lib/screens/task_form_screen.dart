import "package:flutter/material.dart";
import "package:student_app/models/task.dart";
import "package:student_app/services/task_service.dart";
import "package:student_app/utils.dart";
import "package:student_app/widgets/date_form_button.dart";
import "package:student_app/widgets/icon_with_text.dart";
import "package:student_app/widgets/transaction_form.dart";

class TaskFormScreen extends StatefulWidget {
  final CustomForm form;
  final TaskModel task;
  final String context;

  const TaskFormScreen({
    @required this.context,
    @required this.form,
    @required this.task,
  });

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _saveForm(BuildContext context) async {
    final bool isValid = _formKey.currentState.validate();
    if (!isValid) return;

    _formKey.currentState.save();

    setState(() => _isLoading = true);

    String snackBarMessage = "";
    try {
      if (widget.context == "Add") {
        await TaskService.createTask(widget.task);
        snackBarMessage = "Task added successfully";
      } else {
        await TaskService.updateTask(widget.task);
        snackBarMessage = "Task updated successfully";
      }
    } catch (e) {
      snackBarMessage = e.toString();
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
        title: Text("${widget.context} Task"),
        actions: <Widget>[
          Builder(
              builder: (context) => IconButton(
                    icon: Icon(Icons.save),
                    onPressed: _isLoading
                        ? null
                        : () {
                            FocusScope.of(context).requestFocus(FocusNode());
                            _saveForm(context);
                          },
                  ))
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
                        labelText: widget.form.nameLabelText,
                      ),
                      initialValue: widget.task.name,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(widget.form.nameFocusNode),
                      validator: (value) =>
                          value.isEmpty ? "Name should not be empty" : null,
                      onSaved: (value) => widget.task.updateName(value),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: widget.form.descriptionLabelText,
                      ),
                      initialValue: widget.task.description,
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      focusNode: widget.form.descriptionFocusNode,
                      onSaved: (value) => widget.task.updateDescription(value),
                    ),
                    FormFieldTitle(text: "Due At"),
                    DateFormButton(
                      date: widget.task.dueAt,
                      onPressDateHandler: () async {
                        final DateTime newDate = await showDatePicker(
                          context: context,
                          initialDate: widget.task.dueAt,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (newDate != null) {
                          setState(
                              () => widget.task.updateTaskDueDate(newDate));
                        }
                      },
                      onPressTimeHandler: () async {
                        final TimeOfDay newTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay(
                                hour: widget.task.dueAt.hour,
                                minute: widget.task.dueAt.minute));
                        if (newTime != null) {
                          setState(
                              () => widget.task.updateTaskDueTime(newTime));
                        }
                      },
                    ),
                    FormFieldTitle(text: "Category"),
                    DropdownButtonFormField(
                      hint: IconWithTextWidget(
                        child: IconWithText(
                          text: widget.task.category,
                          icon: taskCategories[widget.task.category],
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
                        setState(() => widget.task.updateCategory(e));
                      },
                    ),
                    FormFieldTitle(text: "Priority"),
                    Slider(
                      min: 0,
                      max: 3,
                      value: widget.task.priority.toDouble(),
                      divisions: 3,
                      label: _getLabelFromValue(widget.task.priority),
                      onChanged: (double value) {
                        setState(() => widget.task.priority = value.toInt());
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
