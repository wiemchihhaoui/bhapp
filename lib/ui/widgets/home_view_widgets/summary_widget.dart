import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/ui/shared/text_styles.dart';
import 'package:moneymanager/ui/shared/ui_helpers.dart';

class SummaryWidget extends StatelessWidget {
  var income;
  var expense;
  String? name;

  SummaryWidget({required this.income, required this.expense, this.name});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (name != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${'name'.tr} : ${name}",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text('income'.tr, style: summaryTextStyle),
                        UIHelper.verticalSpaceSmall(),
                        FittedBox(child: Text(income.toString(), style: summaryNumberTextStyle))
                      ],
                    ),
                  ),
                  Text(
                    '|',
                    style: TextStyle(fontSize: 40, color: Colors.blueGrey, fontWeight: FontWeight.w200),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'expenses'.tr,
                          style: summaryTextStyle,
                        ),
                        UIHelper.verticalSpaceSmall(),
                        FittedBox(child: Text(expense.toString(), style: summaryNumberTextStyle))
                      ],
                    ),
                  ),
                  Text(
                    '|',
                    style: TextStyle(fontSize: 40, color: Colors.blueGrey, fontWeight: FontWeight.w200),
                  ),
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'balance'.tr,
                          style: summaryTextStyle,
                        ),
                        UIHelper.verticalSpaceSmall(),
                        FittedBox(child: Text((income - expense).toString(), style: summaryNumberTextStyle))
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
