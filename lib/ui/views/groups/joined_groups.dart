import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:moneymanager/core/models/group.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';
import 'package:moneymanager/ui/views/groups/add_group.dart';
import 'package:moneymanager/ui/views/groups/group_details.dart';

class MyJoinedGroups extends StatefulWidget {
  const MyJoinedGroups({Key? key}) : super(key: key);

  @override
  State<MyJoinedGroups> createState() => _MyGroupsState();
}

class _MyGroupsState extends State<MyJoinedGroups> {
  deleteAllRequests(String grpId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('requests').where("groupId", isEqualTo: grpId).get();
    for (DocumentSnapshot<Map<String, dynamic>> doc in snapshot.docs) {
      doc.reference.delete();
    }
  }

  var user = GetStorage().read("user");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('groups').where("members", arrayContains: user['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Group> groups = [];
              for (var data in snapshot.data!.docs.toList()) {
                groups.add(Group.fromJson(data.data() as Map<String, dynamic>));
              }
              if (groups.isNotEmpty) {
                return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      if (user['uid'] == groups[index].idAdmin) {
                        return Slidable(
                          key: const ValueKey(0),
                          startActionPane: ActionPane(
                            motion: const ScrollMotion(),
                            children: [
                              SlidableAction(
                                onPressed: null,
                                backgroundColor: Colors.green,
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
                                        content: Text('${'delete_grp'.tr} ${groups[index].name}'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('cancel'.tr),
                                            onPressed: () {
                                              Navigator.of(context).pop(); // Close the dialog
                                            },
                                          ),
                                          TextButton(
                                            child: Text('delete'.tr),
                                            onPressed: () {
                                              deleteAllRequests(groups[index].id);
                                              FirebaseFirestore.instance.collection("groups").doc(groups[index].id).delete();
                                              final snackBar = SnackBar(
                                                content: Text("deleted_grp".tr),
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
                          child: InkWell(
                            onTap: () {
                              Get.to(GroupDetails(
                                group: groups[index],
                              ));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                height: Constants.screenHeight * 0.1,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: primaryColor),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: CircleAvatar(
                                          backgroundImage: AssetImage("assets/images/group.png"),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${'group_name'.tr}: ${groups[index].name}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "${'creation_date'.tr} : ${DateFormat("yyyy/MM/dd hh:mm").format(groups[index].createdAt)}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        Text(
                                          "${'members'.tr} : ${groups[index].members.length}",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        StreamBuilder(
                                            stream: FirebaseFirestore.instance
                                                .collection('users')
                                                .doc(groups[index].idAdmin)
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
                                    Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () {
                            Get.to(GroupDetails(
                              group: groups[index],
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Container(
                              height: Constants.screenHeight * 0.1,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: primaryColor),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: AspectRatio(
                                      aspectRatio: 1,
                                      child: CircleAvatar(
                                        backgroundImage: AssetImage("assets/images/group.png"),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${'group_name'.tr}: ${groups[index].name}",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      Text(
                                        "${'creation_date'.tr} : ${DateFormat("yyyy/MM/dd hh:mm").format(groups[index].createdAt)}",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      Text(
                                        "${'members'.tr} : ${groups[index].members.length}",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(groups[index].idAdmin)
                                              .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
                                            if (snapshot.hasData) {
                                              return Text(
                                                "Admin : ${snapshot.data!.get("userName")}",
                                                style: TextStyle(color: Colors.green),
                                              );
                                            } else {
                                              return Container();
                                            }
                                          })
                                    ],
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
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
                          child: Text("no_grps".tr),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Get.to(AddGroup());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
