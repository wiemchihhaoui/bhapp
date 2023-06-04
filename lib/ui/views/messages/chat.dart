import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';
import 'package:moneymanager/ui/views/messages/my_messages.dart';
import 'package:moneymanager/ui/views/messages/people.dart';

class UserMessages extends StatefulWidget {
  const UserMessages({Key? key}) : super(key: key);

  @override
  State<UserMessages> createState() => _UserMessagesState();
}

class _UserMessagesState extends State<UserMessages> with TickerProviderStateMixin {
  late TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0)..addListener(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.04),
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                height: Constants.screenHeight * 0.06,
                child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.grey,
                  splashFactory: NoSplash.splashFactory,
                  labelColor: Colors.white,
                  controller: _tabController,
                  labelPadding: EdgeInsets.all(10),
                  indicator: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                  tabs: [
                    Container(
                        alignment: Alignment.center,
                        child: Text("my_messages".tr, style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                    Container(
                        alignment: Alignment.center,
                        child: Text("people".tr, style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              children: [MyMessages(), People()],
            ))
          ],
        ),
      ),
    );
  }
}
