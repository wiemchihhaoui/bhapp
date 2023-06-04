import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/core/models/transaction.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';

class Savings extends StatefulWidget {
  const Savings({Key? key}) : super(key: key);

  @override
  State<Savings> createState() => _SavingsState();
}

class _SavingsState extends State<Savings> {
  var user = GetStorage().read("user");
  String month = DateFormat.MMM().format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("saving".tr),
        backgroundColor: primaryColor,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user['uid'])
            .collection("transactions")
            .where("categoryindex", isEqualTo: 15)
            .where("month", isEqualTo: month)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TransactionProcess> tr = [];
            for (var data in snapshot.data!.docs.toList()) {
              TransactionProcess transactionProcess = TransactionProcess.fromJson(data.data() as Map<String, dynamic>);
              if (tr.any((obj) => obj.memo == transactionProcess.memo)) {
                TransactionProcess existingObject = tr.firstWhere((obj) => obj.id == transactionProcess.id);
                existingObject.amount += transactionProcess.amount;
              } else {
                tr.add(transactionProcess);
              }
            }
            return ListView.builder(
                itemCount: tr.length,
                itemBuilder: (context, index) {
                  return Card(
                      child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${tr[index].memo}  : ${tr[index].amount}"),
                  ));
                });
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
