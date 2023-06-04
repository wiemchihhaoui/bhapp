import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moneymanager/core/services/AuthServices.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  var user = GetStorage().read("user");
  bool en = GetStorage().read("locale") == "en" ? true : false;
  Widget Positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            AuthServices().logout();
            Get.toNamed("/login");
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
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Image.asset(
              'assets/icons/wallet.png',
              width: 100,
              height: 100,
              alignment: Alignment.centerLeft,
            ),
            decoration: BoxDecoration(
              color: primaryColor,
            ),
          ),
          if (user["role"] == "user") ...[
            ListTile(
              title: Text('statistics'.tr),
              leading: Icon(Icons.pie_chart),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed("/chart");
              },
            ),
            Divider(
              thickness: 1,
            ),
          ],
          if (user["role"] == "user") ...[
            ListTile(
              title: Text('saving'.tr),
              leading: Icon(Icons.save),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed("/savings");
              },
            ),
            Divider(
              thickness: 1,
            ),
          ],
          ListTile(
            title: Text("logout".tr),
            leading: Icon(Icons.logout),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      content: Text("wanna_leave?".tr),
                      actions: [Negative(context), Positive()],
                    );
                  });
            },
          ),
          Divider(
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                children: [
                  Icon(Icons.translate),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("change_language".tr),
                  ),
                  Spacer(),
                  Transform.scale(
                    scale: 1.2,
                    child: Switch(
                      value: en,
                      onChanged: (value) {
                        setState(() {
                          en = !en;
                          Get.updateLocale(Locale(en ? "en" : "fr"));
                          GetStorage().write("locale", en ? "en" : "fr");
                        });
                      },
                      inactiveThumbImage: AssetImage("assets/icons/france.png"),
                      activeThumbImage: AssetImage("assets/icons/usa.png"),
                    ),
                  )
                ],
              ),
            ),
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
