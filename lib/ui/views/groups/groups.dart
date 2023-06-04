import 'package:flutter/material.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';
import 'package:moneymanager/ui/views/groups/joined_groups.dart';
import 'package:moneymanager/ui/views/groups/my_requests.dart';

class MyGroups extends StatefulWidget {
  const MyGroups({Key? key}) : super(key: key);

  @override
  State<MyGroups> createState() => _MyContactsState();
}

class _MyContactsState extends State<MyGroups> with TickerProviderStateMixin {
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
                        child: Text("My groups", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                    Container(
                        alignment: Alignment.center,
                        child: Text("My requests", style: TextStyle(fontSize: Constants.screenHeight * 0.025))),
                  ],
                ),
              ),
            ),
            Expanded(
                child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [MyJoinedGroups(), MyRequests()],
            ))
          ],
        ),
      ),
    );
  }
}
