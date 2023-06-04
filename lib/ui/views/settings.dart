import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moneymanager/ui/views/action_button.dart';
import 'package:moneymanager/ui/widgets/inputs/input_field.dart';

class AppSettings extends StatefulWidget {
  const AppSettings({Key? key}) : super(key: key);

  @override
  State<AppSettings> createState() => _SettingsState();
}

class _SettingsState extends State<AppSettings> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ceilingController.text = user['ceiling'].toString();
  }

  bool loading = false;
  var user = GetStorage().read("user");
  TextEditingController ceilingController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tr_limits".tr),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "ceiling_dt".tr,
              style: TextStyle(color: Colors.indigo),
            ),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: InputField(label: "ceiling".tr, textInputType: TextInputType.number, controller: ceilingController),
            ),
          ),
          loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ActionButton(
                  label: 'update'.tr,
                  buttonColor: Colors.indigo,
                  labelColor: Colors.white,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        loading = true;
                      });
                      await FirebaseFirestore.instance
                          .collection("users")
                          .doc(user['uid'])
                          .update({"ceiling": int.tryParse(ceilingController.text)}).then((value) {
                        setState(() {
                          loading = false;
                        });
                        final snackBar = SnackBar(
                          content: Text("update_ceiling".tr),
                          backgroundColor: (Colors.green),
                          action: SnackBarAction(
                            label: 'close'.tr,
                            textColor: Colors.white,
                            onPressed: () {},
                          ),
                        );
                        user['ceiling'] = int.tryParse(ceilingController.text);
                        GetStorage().write("user", user);
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop(); // Close the dialog
                      });
                    }
                  })
        ],
      ),
    );
  }
}
