import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moneymanager/core/services/category_icon_service.dart';
import 'package:moneymanager/core/viewmodels/base_model.dart';

import '../../locator.dart';
import '../models/transaction.dart';

class DetailsModel extends BaseModel {
  var user = GetStorage().read("user");
  final CategoryIconService _categoryIconService = locator<CategoryIconService>();

  Icon getIconForCategory(int index, String type) {
    if (type == 'income') {
      final categoryIcon = _categoryIconService.incomeList.elementAt(index);

      return Icon(
        categoryIcon.icon,
        color: categoryIcon.color,
      );
    } else {
      final categoryIcon = _categoryIconService.expenseList.elementAt(index);

      return Icon(
        categoryIcon.icon,
        color: categoryIcon.color,
      );
    }
  }

  String getCategoryIconName(index, type) {
    if (type == 'income') {
      return _categoryIconService.incomeList.elementAt(index).name;
    } else {
      return _categoryIconService.expenseList.elementAt(index).name;
    }
  }

  Future deleteTransacation(BuildContext context, TransactionProcess transaction) async {
    FirebaseFirestore.instance.collection("users").doc(user['uid']).collection("transactions").doc(transaction.id).delete();
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
