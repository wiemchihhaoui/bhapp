import 'package:flutter/material.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';

class InputField extends StatelessWidget {
  final String label;
  final TextInputType textInputType;
  final TextEditingController controller;
  final Widget? prefixWidget;

  const InputField({Key? key, required this.label, required this.textInputType, required this.controller, this.prefixWidget})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.001, horizontal: Constants.screenWidth * 0.07),
      child: Container(
        height: Constants.screenHeight * 0.1,
        child: TextFormField(
          style: TextStyle(fontSize: 18),
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return "This field is required";
            } else if (label == "Email") {
              bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value);
              if (!emailValid) {
                return " Invalid email format";
              }
            } else if (textInputType == TextInputType.visiblePassword && controller.text.length < 6) {
              return "Password should be longer than 8";
            }
          },
          keyboardType: textInputType,
          cursorColor: Colors.black,
          obscureText: textInputType == TextInputType.visiblePassword ? true : false,
          decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.red,
              ),
            ),
            prefixIcon: prefixWidget,
            hintText: label,
            filled: true,
            fillColor: Colors.white,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                width: 2.0,
                color: primaryColor.withOpacity(0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(
                color: primaryColor,
                width: 2.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
