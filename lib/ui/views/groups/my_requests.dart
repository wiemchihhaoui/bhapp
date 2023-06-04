import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:moneymanager/core/models/request.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({Key? key}) : super(key: key);

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests> {
  @override
  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('requests').where("userId", isEqualTo: user['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Request> req = [];
              for (var data in snapshot.data!.docs.toList()) {
                req.add(Request.fromJson(data.data() as Map<String, dynamic>));
              }
              if (req.isNotEmpty) {
                return ListView.builder(
                    itemCount: req.length,
                    itemBuilder: (context, index) {
                      return Slidable(
                        key: const ValueKey(0),
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: null,
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.cancel,
                              label: 'cancel'.tr,
                            ),
                            SlidableAction(
                              onPressed: (ctx) async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('delete'.tr),
                                      content: Text("delete_add".tr),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('cancel'.tr),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('delete'.tr),
                                          onPressed: () {
                                            snapshot.data!.docs[index].reference.delete();
                                            final snackBar = SnackBar(
                                              content: Text("req_deleted".tr),
                                              backgroundColor: (Colors.red),
                                              action: SnackBarAction(
                                                label: 'close'.tr,
                                                textColor: Colors.white,
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              backgroundColor: Colors.red.withOpacity(0.7),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'delete'.tr,
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (ctx) async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('accept'.tr),
                                      content: Text("accept_req".tr),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('cancel'.tr),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        TextButton(
                                          child: Text('accept'.tr),
                                          onPressed: () async {
                                            var coll = await FirebaseFirestore.instance
                                                .collection("groups")
                                                .doc(req[index].groupId)
                                                .get();
                                            List grpMembers = coll.get("members");
                                            grpMembers.add(user["uid"]);
                                            FirebaseFirestore.instance
                                                .collection("groups")
                                                .doc(req[index].groupId)
                                                .update({"members": grpMembers});
                                            snapshot.data!.docs[index].reference.delete();
                                            final snackBar = SnackBar(
                                              content: Text("req_accepted".tr),
                                              backgroundColor: (Colors.green),
                                              action: SnackBarAction(
                                                label: 'close'.tr,
                                                textColor: Colors.white,
                                                onPressed: () {},
                                              ),
                                            );
                                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            Navigator.of(context).pop(); // Close the dialog
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              backgroundColor: Colors.green.withOpacity(0.7),
                              foregroundColor: Colors.white,
                              icon: Icons.done_all,
                              label: 'accept'.tr,
                            ),
                            SlidableAction(
                              onPressed: null,
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              icon: Icons.cancel,
                              label: 'cancel'.tr,
                            ),
                          ],
                        ),
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance.collection("groups").doc(req[index].groupId).snapshots(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: primaryColor),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: AssetImage("assets/images/group.png"),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${'group_name'.tr}: ${snapshot.data!.get("name")}",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              "${'creation_date'.tr}: ${DateFormat("yyyy/MM/dd hh:mm").format(snapshot.data!.get("createdAt").toDate())}",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              "${'members'.tr} : ${snapshot.data!.get("members").length}",
                                              style: TextStyle(color: Colors.white),
                                            ),
                                            StreamBuilder(
                                                stream: FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(snapshot.data!.get("idAdmin"))
                                                    .snapshots(),
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                                  if (snapshot.hasData) {
                                                    return Text(
                                                      "Admin : ${snapshot.data!.get("userName")}",
                                                      style: TextStyle(color: Colors.white),
                                                    );
                                                  } else {
                                                    return Container();
                                                  }
                                                })
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
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
                          child: Text("no_req".tr),
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
