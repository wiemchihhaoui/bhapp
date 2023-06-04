import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/core/models/transaction.dart';

class DetailsTable extends StatelessWidget {
  const DetailsTable({
    Key? key,
    required this.transaction,
  }) : super(key: key);

  final TransactionProcess transaction;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "category".tr + " : ",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            Text(
              transaction.type.tr,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "amount".tr + " : ",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            Text(
              transaction.amount.toString(),
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "date".tr + " : ",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            Text(
              transaction.day + ", " + transaction.month,
              textAlign: TextAlign.justify,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              "label".tr + " : ",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 18,
              ),
            ),
            Text(
              transaction.memo,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 20,
              ),
            ),
          ],
        )
      ],
    );
  }
}
