import "package:cloud_firestore/cloud_firestore.dart";
import "package:student_app/models/transaction.dart" as models;

class TransactionService {
  static CollectionReference getCollectionReference() {
    return Firestore.instance.collection("transactions");
  }

  static DocumentReference getDocumentReference(String id) {
    return Firestore.instance.document("transactions/$id");
  }

  static Future<DocumentReference> createTransaction(
      models.Transaction transaction) {
    return getDocumentReference(transaction.id).setData(transaction.toJson());
  }

  static Future<void> updateTransaction(models.Transaction transaction) async {
    return getDocumentReference(transaction.id)
        .updateData(transaction.toJson());
  }

  static Future<void> deleteTransaction(models.Transaction transaction) {
    return getDocumentReference(transaction.id).delete();
  }
}
