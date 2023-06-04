import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:moneymanager/core/services/AuthServices.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';
import 'package:moneymanager/ui/widgets/inputs/input_field.dart';

import 'forgot_password_view.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<SignInScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<bool> avoidReturnButton() async {
    showDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            content: Text("vous etes sur de sortir ?"),
            actions: [Negative(context), Positive()],
          );
        });
    return true;
  }

  Widget Positive() {
    return Container(
      decoration: BoxDecoration(color: Colors.blueAccent),
      child: TextButton(
          onPressed: () {
            exit(0);
          },
          child: const Text(
            " Oui",
            style: TextStyle(
              color: Color(0xffEAEDEF),
            ),
          )),
    );
  } // fermeture de l'application

  Widget Negative(BuildContext context) {
    return TextButton(
        onPressed: () {
          Navigator.pop(context); // fermeture de dialog
        },
        child: Text(" Non"));
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: avoidReturnButton,
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
                key: _formKey,
                child: Column(children: [
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(90),
                      ),
                      gradient: LinearGradient(begin: Alignment.topRight, end: Alignment.bottomLeft, colors: [
                        Colors.blue,
                        primaryColor,
                      ]),
                    ),
                    child: Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 50),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image(
                              image: AssetImage('assets/images/bh.jpg'),
                              height: 100,
                              width: 100,
                            ),
                          ),
                        ),
                        // SizedBox(height: 10),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          child: Text(
                            'BH',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                //  fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      ],
                    )),
                  ),
                  SizedBox(height: 80),
                  InputField(
                    label: "Email",
                    controller: emailController,
                    textInputType: TextInputType.emailAddress,
                    prefixWidget: Icon(Icons.email, color: primaryColor),
                  ),
                  InputField(
                    label: "Mot de passe",
                    controller: passwordController,
                    textInputType: TextInputType.visiblePassword,
                    prefixWidget: Icon(
                      Icons.lock,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: Constants.screenWidth * 0.07),
                    child: Container(
                      alignment: Alignment.centerRight,
                      width: Constants.screenWidth,
                      child: TextButton(
                          onPressed: () {
                            Get.to(ForgotPassScreen());
                          },
                          child: Text(
                            "mot de passe oublié?",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.black54,
                                //fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? CircularProgressIndicator()
                      : Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                  child: CupertinoButton(
                                      child:
                                          Text('Connexion', style: TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
                                      color: primaryColor,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          AuthServices()
                                              .signIn(emailController.text, passwordController.text)
                                              .then((value) async {
                                            if (value) {
                                              if (AuthServices().savedUser['role'] == "user") {
                                                Get.toNamed("/user");
                                              } else {
                                                Get.toNamed("/admin");
                                              }
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "Invalid cridentials",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          });
                                        }
                                      }))
                            ],
                          )),
                  SizedBox(height: 20),
                  Container(
                      margin: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        children: [
                          Expanded(
                              child: TextButton(
                            child: Text("Besoin d'un nouveau compte?",
                                style: TextStyle(color: primaryColor, fontSize: 14, fontStyle: FontStyle.italic)),
                            onPressed: () {
                              Get.toNamed("/register");
                            },
                          ))
                        ],
                      )),
                ])),
          )),
    );
  }
}
