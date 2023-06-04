import 'package:flutter/material.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/views/messages/Messages.dart';

class MyMessages extends StatefulWidget {
  const MyMessages({Key? key}) : super(key: key);

  @override
  State<MyMessages> createState() => _MyMessagesState();
}

class _MyMessagesState extends State<MyMessages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildMessages(),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          Navigator.pushNamed(context, "/admins");
        },
        child: Icon(Icons.admin_panel_settings_outlined),
      ),
    );
  }
}
