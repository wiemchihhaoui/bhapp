import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moneymanager/core/models/category.dart';
import 'package:moneymanager/core/models/transaction.dart';
import 'package:moneymanager/core/viewmodels/insert_transaction_model.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/ui_helpers.dart';
import 'package:moneymanager/ui/views/base_view.dart';
import 'package:moneymanager/ui/widgets/inputs/transactions_field.dart';

class InsertTranscationView extends StatefulWidget {
  final Category category;
  final int selectedCategory;
  InsertTranscationView({required this.category, required this.selectedCategory});

  @override
  State<InsertTranscationView> createState() => _InsertTranscationViewState();
}

class _InsertTranscationViewState extends State<InsertTranscationView> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController memoController = TextEditingController();
  List<TransactionProcess> result = [];

  var user = GetStorage().read("user");

  @override
  Widget build(BuildContext context) {
    return BaseView<InsertTransactionModel>(
      model: InsertTransactionModel(),
      onModelReady: (model) => model.init(widget.selectedCategory, widget.category.index),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: widget.selectedCategory == 1 ? Text('income'.tr) : Text('expense'.tr),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formkey,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    title: Text(widget.category.name),
                    leading: CircleAvatar(
                        child: Icon(
                      widget.category.icon,
                      size: 20,
                    )),
                  ),
                  UIHelper.verticalSpaceMedium(),
                  TransactionField(
                      controller: memoController,
                      text: 'label'.tr + ' : ',
                      helperText: "enter_label".tr,
                      icon: Icons.edit,
                      isNumeric: false),
                  Padding(
                    padding: EdgeInsets.only(left: 40.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: result.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Container(
                                color: Colors.indigo.withOpacity(0.5),
                                child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        memoController.text = result[index].memo;
                                        memoController.selection =
                                            TextSelection.fromPosition(TextPosition(offset: memoController.text.length));

                                        result.clear();
                                      });
                                    },
                                    title: Text(result[index].memo))),
                          );
                        }),
                  ),
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
                      'select_date'.tr,
                      style: TextStyle(fontStyle: FontStyle.italic, fontSize: 16),
                    ),
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
                    child: model.loading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
                            child: Text(
                              'add'.tr,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                model.addTransaction(context, memoController);
                              }
                            },
                          ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
