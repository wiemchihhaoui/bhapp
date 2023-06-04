import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moneymanager/core/models/category.dart';
import 'package:moneymanager/core/models/transaction.dart';
import 'package:moneymanager/core/services/category_icon_service.dart';
import 'package:moneymanager/core/viewmodels/base_model.dart';
import 'package:toast/toast.dart';

import '../../locator.dart';

class EditModel extends BaseModel {
  var user = GetStorage().read("user");
  TextEditingController memoController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  final CategoryIconService _categoryIconService = locator<CategoryIconService>();

  List months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  late String selectedDay;
  late String selectedMonth;
  DateTime selectedDate = new DateTime.now();
  late Category category;

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

  void unFocusFromTheTextField(context) {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  String getSelectedDate() {
    if (int.parse(selectedDay) == DateTime.now().day && DateTime.now().month == months.indexOf(selectedMonth) + 1) {
      return 'Today ' + selectedMonth + ',' + selectedDay;
    } else {
      return selectedMonth + ',' + selectedDay;
    }
  }

  void init(TransactionProcess transaction) {
    // initla values are current day and month
    selectedMonth = transaction.month;
    selectedDay = transaction.day;
    if (transaction.type == 'income') {
      category = _categoryIconService.incomeList.elementAt(transaction.categoryindex);
    } else {
      category = _categoryIconService.expenseList.elementAt(transaction.categoryindex);
    }
    memoController.text = transaction.memo;
    amountController.text = transaction.amount.toString();
    notifyListeners();
  }

  editTransaction(context, TransactionProcess transaction) async {
    String memo = memoController.text;
    String amount = amountController.text;

    if (memo.length == 0 || amount.length == 0) {
      Toast.show("Please fill all the fields!", duration: 1, gravity: 0);
      return;
    }

    TransactionProcess updatedTransaction = new TransactionProcess(
        type: transaction.type,
        day: selectedDay,
        month: selectedMonth,
        memo: memoController.text,
        amount: double.parse(amount),
        categoryindex: transaction.categoryindex);
    FirebaseFirestore.instance
        .collection("users")
        .doc(user['uid'])
        .collection("transactions")
        .doc(transaction.id.toString())
        .set(updatedTransaction.Tojson());

    Navigator.of(context).pushReplacementNamed('/home');
  }
}
