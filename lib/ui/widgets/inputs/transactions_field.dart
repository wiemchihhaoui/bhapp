import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionField extends StatelessWidget {
  TextEditingController controller;
  String text;
  String helperText;
  IconData icon;
  bool isNumeric;
  ValueChanged<String>? test;

  TransactionField(
      {Key? key,
      required this.text,
      this.test,
      required this.controller,
      required this.icon,
      required this.helperText,
      required this.isNumeric})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value!.isEmpty) {
          return "required_field".tr;
        } else if (isNumeric) {
          try {
            double.parse(value);
          } catch (e) {
            return "numeric_field".tr;
          }
        }
      },
      cursorColor: Colors.black,
      onChanged: (value) => test != null ? test!(value) : null,
      maxLength: isNumeric ? 10 : 40,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        icon: Icon(
          icon,
          color: Colors.black,
        ),
        labelText: text,
        suffixIcon: InkWell(
          onTap: () {
            controller.clear();
          },
          child: Icon(
            Icons.clear,
            color: Colors.black,
          ),
        ),
        labelStyle: TextStyle(
          color: Color(0xFFFF000000),
        ),
        helperText: helperText,
      ),
    );
  }
}
