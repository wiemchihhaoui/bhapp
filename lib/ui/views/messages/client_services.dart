import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:moneymanager/core/models/user.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';
import 'package:moneymanager/ui/views/messages/Messenger.dart';

class ClientServices extends StatefulWidget {
  const ClientServices({Key? key}) : super(key: key);

  @override
  State<ClientServices> createState() => _ClientServicesState();
}

class _ClientServicesState extends State<ClientServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: primaryColor,
        ),
        title: Text(
          "contact_admin".tr,
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').where("role", isEqualTo: "admin").snapshots(),
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
                          child: Text("no_admin".tr),
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
          }),
    );
  }
}
