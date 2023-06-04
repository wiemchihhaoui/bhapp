import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/core/models/transaction.dart';
import 'package:moneymanager/core/services/transaction_sercvices.dart';
import 'package:moneymanager/core/viewmodels/base_model.dart';

class InsertTransactionModel extends BaseModel {
  TextEditingController amountController = TextEditingController();
  var user = GetStorage().read("user");
  bool loading = false;
  List months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  String selectedDay = new DateTime.now().day.toString();
  String selectedMonth = new DateTime.now().day.toString();
  DateTime selectedDate = new DateTime.now();
  String type = "";
  int cateogryIndex = 1;

  Future selectDate(context) async {
    // hide the keyboard
    unFocusFromTheTextField(context);

    DateTime? picked =
        await showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2020), lastDate: DateTime.now());

    if (picked != null) {
      selectedMonth = months[picked.month - 1];
      selectedDay = picked.day.toString();
      selectedDate = picked;

      notifyListeners();
    }
  }

  void init(int selectedCategory, int index) {
    // initla values are current day and month
    selectedMonth = months[DateTime.now().month - 1];
    selectedDay = DateTime.now().day.toString();
    type = (selectedCategory == 1) ? 'income' : 'expense';
    cateogryIndex = index;
  }

  void unFocusFromTheTextField(context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  String getSelectedDate() {
    if (int.parse(selectedDay) == DateTime.now().day && DateTime.now().month == months.indexOf(selectedMonth) + 1) {
      return selectedMonth + ',' + selectedDay;
    } else {
      return selectedMonth + ',' + selectedDay;
    }
  }

  addTransaction(context, TextEditingController memoController) async {
    String amount = amountController.text;

    TransactionProcess newTransaction = TransactionProcess(
        type: type,
        date: DateTime.now(),
        day: selectedDay,
        month: selectedMonth,
        memo: memoController.text,
        amount: double.parse(amount),
        categoryindex: cateogryIndex);
    loading = true;
    notifyListeners();
    TransactionServices.addTransaction(newTransaction, user['uid']).then((value) {
      loading = false;
      memoController.clear();
      amountController.clear();
      notifyListeners();
    });
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user['uid'])
        .collection("transactions")
        .where("month", isEqualTo: DateFormat("MMMM").format(DateTime.now()))
        .get();
    List<TransactionProcess> res = snapshot.docs.map((doc) => TransactionProcess.fromJson(doc.data())).toList();
    dynamic income = 0;
    dynamic expenses = 0;
    for (var value in res) {
      if (value.type == "expense") {
        expenses = expenses + value.amount;
      } else {
        income = income + value.amount;
      }
    }
    if (income - expenses < user["ceiling"] && type == "expense") {
      final snackBar = SnackBar(
        content: Text("Vous avez depassé votre plafond de ${user['ceiling']} dt "),
        backgroundColor: (Colors.red),
        action: SnackBarAction(
          label: 'fermer',
          textColor: Colors.white,
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
