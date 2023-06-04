import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:moneymanager/core/models/group.dart';
import 'package:moneymanager/core/models/request.dart';
import 'package:moneymanager/core/models/user.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';

class AddRequests extends StatefulWidget {
  final Group group;
  const AddRequests({Key? key, required this.group}) : super(key: key);

  @override
  State<AddRequests> createState() => _AddRequestsState();
}

class _AddRequestsState extends State<AddRequests> {
  var user = GetStorage().read("user");
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSentRequests();
  }

  List<Request> sent = [];
  getSentRequests() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('requests').where("groupId", isEqualTo: widget.group.id).get();
    List<Request> requests = snapshot.docs.map((doc) => Request.fromJson(doc.data())).toList();
    setState(() {
      sent = requests;
      print(sent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "add_members".tr,
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where("role", isEqualTo: "user")
              .where("uid", isNotEqualTo: user['uid'])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<AppUser> users = [];
              for (var data in snapshot.data!.docs.toList()) {
                if (!widget.group.members.contains(data.get('uid'))) {
                  users.add(AppUser.fromJson(data.data() as Map<String, dynamic>));
                }
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
                                        if (sent.any((item) => item.userId == users[index].uid)) {
                                          FirebaseFirestore.instance
                                              .collection("requests")
                                              .doc(sent.firstWhere((req) => req.userId == users[index].uid).id)
                                              .delete();
                                          getSentRequests();
                                        } else {
                                          var collection = FirebaseFirestore.instance.collection("requests");
                                          var doc = collection.doc();
                                          collection
                                              .doc(doc.id)
                                              .set({"userId": users[index].uid, "groupId": widget.group.id, "id": doc.id});
                                          getSentRequests();
                                        }
                                      },
                                      child: sent.any((item) => item.userId == users[index].uid)
                                          ? Image.asset('assets/icons/check.png',
                                              color: Colors.blue, height: Constants.screenHeight * 0.03)
                                          : Image.asset('assets/icons/add_user.png',
                                              color: Colors.blue, height: Constants.screenHeight * 0.03),
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
                          child: Text("no_users".tr),
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
