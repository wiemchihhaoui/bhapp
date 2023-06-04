import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/views/action_button.dart';
import 'package:moneymanager/ui/widgets/inputs/input_field.dart';

class AddGroup extends StatefulWidget {
  const AddGroup({Key? key}) : super(key: key);

  @override
  State<AddGroup> createState() => _AddGroupState();
}

class _AddGroupState extends State<AddGroup> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var user = GetStorage().read("user");
  TextEditingController nameController = TextEditingController();
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
          "add_grp".tr,
          style: TextStyle(color: primaryColor),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            InputField(label: "grp_name".tr, textInputType: TextInputType.text, controller: nameController),
            ActionButton(
                label: 'add'.tr,
                buttonColor: primaryColor,
                labelColor: Colors.white,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    var collection = FirebaseFirestore.instance.collection("groups");
                    var doc = collection.doc();
                    collection.doc(doc.id).set({
                      'name': nameController.text,
                      'id': doc.id,
                      'idAdmin': user["uid"],
                      'members': [user['uid']],
                      'createdAt': DateTime.now(),
                    });

                    nameController.clear();
                    final snackBar = SnackBar(
                      content: Text('added_grp'.tr),
                      backgroundColor: (Colors.green),
                      action: SnackBarAction(
                        label: 'close'.tr,
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pop(context);
                  }
                })
          ],
        ),
      ),
    );
  }
}
