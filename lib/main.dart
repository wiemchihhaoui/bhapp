import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:moneymanager/ui/router.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';

import 'locator.dart';
import 'ui/shared/internacionalization/languages.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // initialize firebase app
  await GetStorage.init(); // initialize getStorage

  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Languages(),
      locale: Locale(GetStorage().read("locale") != null ? GetStorage().read("locale") : "fr"),
      fallbackLocale: Locale("fr"),
      title: 'BH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: backgroundColor,
        hintColor: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
