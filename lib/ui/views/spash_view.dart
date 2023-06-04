import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';

import '../shared/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var auth = GetStorage().read("auth");
  var user = GetStorage().read("user");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var timer = Timer(Duration(seconds: 3), () {
      if (auth == 1) {
        if (user['role'] == "admin") {
          Get.toNamed("/admin");
        } else {
          Get.toNamed("/user");
        }
      } else {
        Get.toNamed("/login");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: splashColor,
          body: Container(
            height: Constants.screenHeight,
            width: double.infinity,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.1),
                  child: Text(
                    'BH',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ),
                Lottie.asset(
                  "assets/lotties/wallet.json",
                  width: Constants.screenWidth,
                ),
                Text(
                  'Un endroit pour toutes vos dépenses.',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Lottie.asset(
                    "assets/lotties/loading.json",
                    height: Constants.screenWidth * 0.2,
                  ),
                )
              ],
            ),
          )),
    );
  }
}
