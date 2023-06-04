import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/core/viewmodels/details_model.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/views/base_view.dart';
import 'package:moneymanager/ui/widgets/details_view_widgets/details_card.dart';

import '../../core/models/transaction.dart';

class DetailsView extends StatelessWidget {
  final TransactionProcess transaction;
  DetailsView(this.transaction);

  @override
  Widget build(BuildContext context) {
    return BaseView<DetailsModel>(
        model: DetailsModel(),
        builder: (context, model, child) => WillPopScope(
              onWillPop: () {
                Navigator.of(context).pushReplacementNamed('/home');
                return Future.value(true);
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: primaryColor,
                  leading: InkWell(
                    child: Icon(Icons.arrow_back),
                    onTap: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('details'.tr),
                      InkWell(
                        child: Icon(Icons.delete),
                        onTap: () {
                          showDeleteDialog(context, model);
                        },
                      ),
                    ],
                  ),
                ),
                body: Stack(
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      height: 300,
                      padding: const EdgeInsets.all(10.0),
                      child: DetailsCard(
                        transaction: transaction,
                        model: model,
                      ),
                    ),
                    Positioned(
                      right: 18,
                      top: 235,
                      child: FloatingActionButton(
                        child: Icon(Icons.edit, color: Colors.white),
                        backgroundColor: primaryColor,
                        onPressed: () {
                          Navigator.of(context).pushNamed('/edit', arguments: transaction);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  showDeleteDialog(BuildContext context, DetailsModel model) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("delete".tr),
            content: Text("delete_confirm".tr),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  "delete".tr,
                ),
                onPressed: () async {
                  await model.deleteTransacation(context, transaction);
                  // hide dialog
                  Navigator.of(context).pop();
                  // exit detailsscreen
                  Navigator.of(context).pop(true);
                },
              ),
              ElevatedButton(
                child: Text("cancel".tr),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              )
            ],
          );
        });
  }
}
