import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:moneymanager/core/services/AuthServices.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';
import 'package:moneymanager/ui/views/action_button.dart';
import 'package:moneymanager/ui/views/sign_in_view.dart';
import 'package:moneymanager/ui/widgets/inputs/input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 250,
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
                                      height: 90,
                                      width: 90,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: InputField(
                              label: "Nom et prénom",
                              controller: nameController,
                              textInputType: TextInputType.text,
                              prefixWidget: Icon(
                                Icons.person,
                                color: primaryColor,
                              ),
                            ),
                          ),
                          InputField(
                            label: "Email",
                            controller: emailController,
                            textInputType: TextInputType.emailAddress,
                            prefixWidget: Icon(
                              Icons.email,
                              color: primaryColor,
                            ),
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
                          loading
                              ? CircularProgressIndicator()
                              : Row(
                                  children: [
                                    Expanded(
                                        child: ActionButton(
                                      label: "S'inscrire",
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                          AuthServices()
                                              .signUp(emailController.text, passwordController.text, nameController.text)
                                              .then((value) async {
                                            if (value) {
                                              setState(() {
                                                loading = false;
                                                Get.toNamed("/user");
                                              });
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg: "L'email déja existe",
                                                  toastLength: Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 1,
                                                  backgroundColor: Colors.grey,
                                                  textColor: Colors.white,
                                                  fontSize: 16.0);
                                              setState(() {
                                                loading = false;
                                              });
                                            }
                                          });
                                        }
                                      },
                                      buttonColor: primaryColor,
                                      labelColor: Colors.white,
                                    ))
                                  ],
                                ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: Constants.screenHeight * 0.07,
                          width: double.infinity,
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  Get.to(SignInScreen());
                                },
                                icon: Icon(Icons.arrow_back_ios),
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: Constants.screenHeight * 0.08,
                              ),
                              Text(
                                "Creér un compte",
                                style: TextStyle(
                                    fontStyle: FontStyle.italic, color: Colors.white, fontSize: Constants.screenHeight * 0.03),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )))),
    );
  }
}
