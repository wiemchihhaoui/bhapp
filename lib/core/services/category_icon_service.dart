import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:moneymanager/core/models/category.dart';

class CategoryIconService {
  //* FIRST : EXPENSE LIST
  final expenseList = {
    Category(0, "food".tr, FontAwesomeIcons.pizzaSlice, Colors.green),
    Category(1, "bills".tr, FontAwesomeIcons.moneyBill, Colors.blue),
    Category(2, "transportation".tr, FontAwesomeIcons.bus, Colors.blueAccent),
    Category(3, "home".tr, FontAwesomeIcons.home, Colors.brown),
    Category(4, "entertainment".tr, FontAwesomeIcons.gamepad, Colors.cyanAccent),
    Category(5, "shopping".tr, FontAwesomeIcons.shoppingBag, Colors.deepOrange),
    Category(6, "clothing".tr, FontAwesomeIcons.tshirt, Colors.deepOrangeAccent),
    Category(7, "insurance".tr, FontAwesomeIcons.hammer, Colors.indigo),
    Category(8, "telephone".tr, FontAwesomeIcons.phone, Colors.indigoAccent),
    Category(9, "health".tr, FontAwesomeIcons.briefcaseMedical, Colors.lime),
    Category(10, "sport".tr, FontAwesomeIcons.footballBall, Colors.limeAccent),
    Category(11, "beauty".tr, FontAwesomeIcons.marker, Colors.pink),
    Category(12, "education".tr, FontAwesomeIcons.book, Colors.teal),
    Category(13, "gift".tr, FontAwesomeIcons.gift, Colors.redAccent),
    Category(14, "pet".tr, FontAwesomeIcons.dog, Colors.deepPurpleAccent),
    Category(15, "saving".tr, FontAwesomeIcons.save, Colors.deepPurpleAccent),
  };
  //* SECOND : INCOME LIST
  final incomeList = [
    Category(0, "salary".tr, FontAwesomeIcons.wallet, Colors.green),
    Category(1, "awards".tr, FontAwesomeIcons.moneyCheck, Colors.amber),
    Category(2, "grants".tr, FontAwesomeIcons.gifts, Colors.lightGreen),
    Category(3, "rental".tr, FontAwesomeIcons.houseUser, Colors.yellow),
    Category(4, "investment".tr, FontAwesomeIcons.piggyBank, Colors.cyanAccent),
    Category(5, "lottery".tr, FontAwesomeIcons.dice, Colors.deepOrange),
  ];
}
