import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moneymanager/core/models/transaction.dart';

class TransactionServices {
  static Future<bool> addTransaction(TransactionProcess transaction, String uid) async {
    try {
      var trCollection = FirebaseFirestore.instance.collection("users").doc(uid).collection('transactions');
      await trCollection.add(transaction.Tojson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
