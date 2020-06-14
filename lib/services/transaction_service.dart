import "package:cloud_firestore/cloud_firestore.dart";
import "package:student_app/models/transaction.dart";

class TransactionService {
  static CollectionReference getCollectionReference() {
    return Firestore.instance.collection("transactions");
  }

  static DocumentReference getDocumentReference(String id) {
    return Firestore.instance.document("transactions/$id");
  }

  static Future<DocumentReference> createTransaction(
      TransactionModel transaction) {
    return getCollectionReference().add(transaction.toJson());
  }

  static Future<void> updateTransaction(TransactionModel transaction) async {
    return getDocumentReference(transaction.id)
        .updateData(transaction.toJson());
  }

  static Future<void> deleteTransaction(TransactionModel transaction) {
    return getDocumentReference(transaction.id).delete();
  }

  static Query getCollectionReferenceOrderByDate(String userID) {
    return getCollectionReference()
        .where("creatorId", isEqualTo: userID)
        .orderBy("date", descending: true);
  }

  static Query getCollectionReferenceInDateRange(
    String userID,
    DateTime left,
    DateTime right,
  ) {
    return getCollectionReference()
        .where("creatorId", isEqualTo: userID)
        .where("date",
            isGreaterThanOrEqualTo: DateTime(left.year, left.month, left.day))
        .where("date",
            isLessThan: DateTime(right.year, right.month, right.day)
                .add(Duration(days: 1)))
        .orderBy("date");
  }
}
