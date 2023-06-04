import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/core/models/transaction.dart';
import 'package:moneymanager/core/viewmodels/edit_model.dart';
import 'package:moneymanager/ui/shared/ui_helpers.dart';
import 'package:moneymanager/ui/views/base_view.dart';
import 'package:moneymanager/ui/widgets/inputs/transactions_field.dart';

import '../shared/app_colors.dart';

class EditView extends StatelessWidget {
  final TransactionProcess transaction;
  EditView(this.transaction);

  @override
  Widget build(BuildContext context) {
    return BaseView<EditModel>(
      model: EditModel(),
      onModelReady: (model) => model.init(transaction),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text('edit'.tr),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text(model.category.name),
                leading: CircleAvatar(
                    child: Icon(
                  model.category.icon,
                  size: 20,
                )),
              ),
              UIHelper.verticalSpaceMedium(),
              TransactionField(
                  controller: model.memoController,
                  text: 'label'.tr + ' : ',
                  helperText: "enter_label".tr,
                  icon: Icons.edit,
                  isNumeric: false),
              UIHelper.verticalSpaceMedium(),
              TransactionField(
                  controller: model.amountController,
                  text: 'amount'.tr + ' : ',
                  helperText: "enter_amount".tr,
                  icon: Icons.attach_money,
                  isNumeric: true),
              UIHelper.verticalSpaceMedium(),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'select_date'.tr + ' : ',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                ),
              ),
              Divider(
                thickness: 2,
              ),
              Divider(
                thickness: 2,
              ),
              Container(
                width: 20,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text(model.getSelectedDate()),
                  onPressed: () async {
                    await model.selectDate(context);
                  },
                ),
              ),
              UIHelper.verticalSpaceLarge(),
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                  child: Text(
                    'edit'.tr,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () async {
                    await model.editTransaction(context, transaction);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
