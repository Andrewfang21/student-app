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
    return Firestore.instance
        .collection("tasks")
        .where("category", isEqualTo: category)
        .where("dueAt", isGreaterThanOrEqualTo: DateTime.now())
        .orderBy("dueAt");
  }
}
