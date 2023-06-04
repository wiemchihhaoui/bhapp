import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/views/groups/groups.dart';
import 'package:moneymanager/ui/views/home_view.dart';
import 'package:moneymanager/ui/views/messages/chat.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({Key? key}) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  List<Widget> pages = [HomeView(), UserMessages(), MyGroups()];
  int pageIndex = 0;
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
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: primaryColor,
          currentIndex: pageIndex,
          onTap: (i) {
            setState(() {
              pageIndex = i;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: 'home1'.tr,
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.comment),
              label: 'messages'.tr,
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.group),
              label: 'groups'.tr,
            ),
          ],
        ),
        body: pages[pageIndex],
      ),
    );
  }
}
