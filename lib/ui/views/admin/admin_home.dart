import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/views/messages/Messages.dart';
import 'package:moneymanager/ui/widgets/home_view_widgets/app_drawer.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({Key? key}) : super(key: key);

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Future<bool> avoidReturnButton() async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text("wanna_leave?".tr),
            actions: [Negative(context), Positive()],
          );
        });
    return true;
  }

  Widget Positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0);
          },
          child: Text(
            "yes".tr,
            style: TextStyle(
              color: Color(0xffEAEDEF),
            ),
          )),
    );
  }

  Widget Negative(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context); // fermeture de dialog
        },
        child: Text("no".tr));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: avoidReturnButton,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
        ),
        drawer: AppDrawer(),
        body: buildMessages(),
      ),
    );
  }
}
