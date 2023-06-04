import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';

class TransactionTypeSpinner extends StatelessWidget {
  final selectedItem;
  final Function changedSelectedItem;
  const TransactionTypeSpinner(this.selectedItem, this.changedSelectedItem);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        dropdownColor: primaryColor,
        value: selectedItem,
        items: [
          DropdownMenuItem(
            child: Text(
              "income".tr,
              style: TextStyle(color: Colors.white),
            ),
            value: 1,
          ),
          DropdownMenuItem(
            child: Text(
              "expense".tr,
              style: TextStyle(color: Colors.white),
            ),
            value: 2,
          ),
        ],
        onChanged: (value) {
          changedSelectedItem(value);
        });
  }
}
