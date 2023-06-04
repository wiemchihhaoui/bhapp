import 'package:flutter/material.dart';
import 'package:moneymanager/core/viewmodels/details_model.dart';
import 'package:moneymanager/ui/shared/ui_helpers.dart';
import 'package:moneymanager/ui/widgets/details_view_widgets/details_table.dart';

import '../../../core/models/transaction.dart';

class DetailsCard extends StatelessWidget {
  final TransactionProcess transaction;
  final DetailsModel model;
  DetailsCard({required this.transaction, required this.model});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.blueAccent.withOpacity(.1),
                  child: model.getIconForCategory(transaction.categoryindex, transaction.type)),
              title: Text(
                "\t\t\t" + model.getCategoryIconName(transaction.categoryindex, transaction.type),
                style: TextStyle(fontSize: 30),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            UIHelper.verticalSpaceSmall(),
            DetailsTable(transaction: transaction),
          ],
        ),
      ),
    );
  }
}
