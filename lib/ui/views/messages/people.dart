import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:moneymanager/core/models/user.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';
import 'package:moneymanager/ui/views/messages/Messenger.dart';

class People extends StatefulWidget {
  const People({Key? key}) : super(key: key);

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where("role", isEqualTo: "user")
            .where("uid", isNotEqualTo: user['uid'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<AppUser> users = [];
            for (var data in snapshot.data!.docs.toList()) {
              users.add(AppUser.fromJson(data.data() as Map<String, dynamic>));
            }
            if (users.isNotEmpty) {
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        height: Constants.screenHeight * 0.1,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: primaryColor),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundImage: AssetImage("assets/images/user.png"),
                                radius: 20,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  users[index].userName!,
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                    onTap: () {
                                      Get.to(Messenger(
                                          user: AppUser(
                                        uid: users[index].uid,
                                        userName: users[index].userName,
                                        email: users[index].email,
                                      )));
                                    },
                                    child: Image.asset('assets/images/chat.png', height: Constants.screenHeight * 0.05),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              return Center(
                child: Container(
                  height: Constants.screenHeight * 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset("assets/lotties/error.json", repeat: false, height: Constants.screenHeight * 0.1),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("Pas d'admin diponible pour le moment "),
                      ),
                    ],
                  ),
                ),
              );
            }
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
