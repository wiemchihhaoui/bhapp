import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/ui/shared/ui_helpers.dart';

class EmptyTransactionsWidget extends StatelessWidget {
  const EmptyTransactionsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        UIHelper.verticalSpaceLarge(),
        Image.asset(
          'assets/icons/no-money.png',
          width: 120,
          height: 120,
        ),
        UIHelper.verticalSpaceMedium(),
        Text(
          'no_tr'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 18),
        ),
      ],
    );
  }
}
