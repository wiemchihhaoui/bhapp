import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/core/models/group.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/views/groups/add_requests.dart';

import '../../widgets/home_view_widgets/summary_widget.dart';

class GroupDetails extends StatefulWidget {
  final Group group;
  const GroupDetails({Key? key, required this.group}) : super(key: key);

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  var user = GetStorage().read("user");
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
        actions: [
          if (user['uid'] == widget.group.idAdmin)
            IconButton(
                onPressed: () {
                  Get.to(AddRequests(
                    group: widget.group,
                  ));
                },
                icon: Icon(Icons.more_vert)),
          if (user['uid'] != widget.group.idAdmin)
            IconButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('leave'),
                        content: Text("leave_grp".tr),
                        actions: <Widget>[
                          TextButton(
                            child: Text('cancel'.tr),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                              child: Text('leave'.tr),
                              onPressed: () async {
                                var coll = await FirebaseFirestore.instance.collection("groups").doc(widget.group.id).get();
                                List grpMembers = coll.get("members");

                                grpMembers.remove(user["uid"]);
                                await FirebaseFirestore.instance
                                    .collection("groups")
                                    .doc(widget.group.id)
                                    .update({"members": grpMembers}).then((value) {
                                  final snackBar = SnackBar(
                                    content: Text("left_grp".tr),
                                    backgroundColor: (Colors.green),
                                    action: SnackBarAction(
                                      label: 'close'.tr,
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                });
                              }),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.logout)),
        ],
        title: Text(
          "${widget.group.name}",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('groups').doc(widget.group.id).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.hasData) {
              List usersId = snapshot.data!.get("members");
              return ListView.builder(
                  itemCount: usersId.length,
                  itemBuilder: (context, index) {
                    return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('users').doc(usersId[index]).snapshots(),
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> userSnapshot) {
                          if (userSnapshot.hasData) {
                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(userSnapshot.data!.get("uid"))
                                  .collection("transactions")
                                  .where("month", isEqualTo: DateFormat("MMMM").format(DateTime.now()))
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  print(snapshot.data!.docs.toList());
                                  var data = snapshot.data!.docs.toList();
                                  dynamic income = 0;
                                  dynamic expenses = 0;
                                  for (var value in data) {
                                    if (value.get("type") == "expense") {
                                      expenses = expenses + value.get("amount");
                                    } else {
                                      income = income + value.get("amount");
                                    }
                                  }
                                  return SummaryWidget(
                                    name: userSnapshot.data!.get("userName").toString().toUpperCase(),
                                    income: income,
                                    expense: expenses,
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            );
                          } else {
                            return Container();
                          }
                        });
                  });
            } else {
              return Container();
            }
          }),
    );
  }
}
