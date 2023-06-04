import 'package:flutter/material.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';

class ActionButton extends StatelessWidget {
  final String label;
  final Color buttonColor;
  final Color labelColor;
  final VoidCallback onPressed;
  const ActionButton(
      {Key? key, required this.label, required this.buttonColor, required this.labelColor, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.screenHeight * 0.09,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: Constants.screenHeight * 0.01, horizontal: Constants.screenWidth * 0.07),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: buttonColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
            onPressed: onPressed,
            child: Row(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      label,
                      style: TextStyle(color: labelColor),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
