import "package:cloud_firestore/cloud_firestore.dart";
import "package:student_app/models/task.dart";

class TaskService {
  static CollectionReference getCollectionReference() {
    return Firestore.instance.collection("tasks");
  }

  static DocumentReference getDocumentReference(String id) {
    return Firestore.instance.document("tasks/$id");
  }

  static Future<DocumentReference> createTask(Task task) {
    return getCollectionReference().add(task.toJson());
  }

  static Future<void> updateTask(Task task) async {
    return getDocumentReference(task.id).updateData(task.toJson());
  }

  static Future<void> deleteTask(Task task) {
    return getDocumentReference(task.id).delete();
  }

  static Query getCollectionReferenceByCategory(String category) {
    return getCollectionReference()
        .where("category", isEqualTo: category)
        .where("dueAt", isGreaterThanOrEqualTo: DateTime.now())
        .orderBy("dueAt");
  }

  static Query getCollectionReferenceDueAt(DateTime date) {
    return getCollectionReference()
        .where("dueAt",
            isLessThanOrEqualTo: DateTime(date.year, date.month, date.day)
                .add(Duration(days: 1)))
        .where("dueAt",
            isGreaterThanOrEqualTo: DateTime(date.year, date.month, date.day))
        .orderBy("dueAt");
  }

  static Query getAllUpcomingTasks() {
    final DateTime now = DateTime.now();

    return getCollectionReference()
        .where("dueAt",
            isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day))
        .orderBy("dueAt");
  }

  static Query getAllPastTasksByCategory(String category) {
    final DateTime now = DateTime.now();

    return getCollectionReference()
        .where("category", isEqualTo: category)
        .where("dueAt", isLessThan: DateTime(now.year, now.month, now.day))
        .orderBy("dueAt", descending: true);
  }

  static Query getAllTasks() {
    return getCollectionReference().orderBy("dueAt");
  }
}
