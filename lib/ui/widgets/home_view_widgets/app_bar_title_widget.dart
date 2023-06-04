import 'package:flutter/material.dart';
import 'package:moneymanager/core/viewmodels/home_model.dart';

class AppBarTitle extends StatelessWidget {
  final HomeModel model;
  final String title;
  const AppBarTitle({Key? key, required this.model, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        model.titleClicked();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            model.isCollabsed
                ? Icon(
                    Icons.arrow_drop_down,
                    color: Colors.white,
                  )
                : Icon(
                    Icons.arrow_drop_up,
                    color: Colors.white,
                  ),
          ],
        ),
      ),
    );
  }
}
