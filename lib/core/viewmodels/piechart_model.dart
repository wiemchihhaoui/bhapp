import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:moneymanager/core/enums/viewstate.dart';
import 'package:moneymanager/core/services/category_icon_service.dart';
import 'package:moneymanager/core/viewmodels/base_model.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../locator.dart';
import '../models/transaction.dart';

class PieChartModel extends BaseModel {
  var user = GetStorage().read("user");
  List<String> months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

  final CategoryIconService _categoryIconService = locator<CategoryIconService>();

  List<TransactionProcess> transactions = [];

  int selectedMonthIndex = 0;

  Map<String, double> dataMap = new Map<String, double>();

  String type = 'expense';

  List<String> types = ["income".tr, "expense".tr];

  init(bool firstTime) async {
    transactions.clear();
    if (firstTime) selectedMonthIndex = DateTime.now().month - 1;

    setState(ViewState.Busy);
    notifyListeners();

    await getData();
    dataMap = getDefaultDataMap(transactions);

    transactions.forEach((element) {
      prepareDataMap(element);
    });

    print(dataMap.toString());

    setState(ViewState.Idle);
    notifyListeners();
  }

  changeSelectedMonth(int val) async {
    transactions.clear();
    selectedMonthIndex = val;
    await getData();
    // clear old data
    dataMap = getDefaultDataMap(transactions);

    transactions.forEach((element) {
      prepareDataMap(element);
    });

    notifyListeners();
  }

  Map<String, double> getDefaultDataMap(List<TransactionProcess> transactions) {
    Map<String, double> fullExpensesMap = {
      'Food': 0,
      'Bills': 0,
      'Transportaion': 0,
      'Home': 0,
      'Entertainment': 0,
      'Shopping': 0,
      'Clothing': 0,
      'Insurance': 0,
      'Telephone': 0,
      'Health': 0,
      'Sport': 0,
      'Beauty': 0,
      'Education': 0,
      'Gift': 0,
      'Pet': 0,
      'Salary': 0,
      'Awards': 0,
      'Grants': 0,
      'Rental': 0,
      'Investment': 0,
      'Lottery': 0,
    };

    Map<String, double> fullIncomeMap = {
      'Salary': 0,
      'Awards': 0,
      'Grants': 0,
      'Rental': 0,
      'Investment': 0,
      'Lottery': 0,
    };

    List<String> transactionsCategories = [];

    transactions.forEach((element) {
      if (type == 'income') {
        String category = _categoryIconService.incomeList.elementAt(element.categoryindex).name;
        transactionsCategories.add(category);
      } else {
        String category = _categoryIconService.expenseList.elementAt(element.categoryindex).name;
        transactionsCategories.add(category);
      }
    });

    if (type == 'income') {
      fullIncomeMap.removeWhere((key, value) {
        return !transactionsCategories.contains(key);
      });
      return fullIncomeMap;
    }

    fullExpensesMap.removeWhere((key, value) {
      return !transactionsCategories.contains(key);
    });

    return fullExpensesMap;
  }

  changeType(int val) async {
    // 0 => income
    // 1 => expense
    if (val == 0) {
      type = 'income';
    } else {
      type = 'expense';
    }
    print("type " + type);
    await init(false);
  }

  void prepareDataMap(element) {
    if (type == 'income') {
      dataMap[_categoryIconService.incomeList.elementAt(element.categoryindex).name] = element.amount + .0;
    } else {
      dataMap[_categoryIconService.expenseList.elementAt(element.categoryindex).name] = element.amount + .0;
    }
  }

  getData() async {
    var data = await FirebaseFirestore.instance
        .collection("users")
        .doc(user['uid'])
        .collection("transactions")
        .where("type", isEqualTo: type)
        .where("month", isEqualTo: months.elementAt(selectedMonthIndex))
        .get();
    for (var test in data.docs.toList()) {
      transactions.add(TransactionProcess.fromJson(test.data() as Map<String, dynamic>));
    }
  }

  void generateExcelAndDownload() async {
    // Create a new Excel Workbook
    var excel = Excel.createExcel();

    // Add a Worksheet
    var sheet = excel['Sheet1'];

    // Define the headers
    sheet.appendRow([
      'Date',
      'Description',
      'Montant',
    ]);

    // Insert transactions into the Excel file
    for (var transaction in transactions) {
      sheet.appendRow([
        DateFormat("yyyy/MM/dd").format(transaction.date!),
        transaction.memo,
        transaction.amount,
      ]);
    }

    // Save the Excel file
    var bytes = excel.encode();

    // Get the download directory path
    var downloadDirectory = await getExternalStorageDirectory();

    // Create a new file
    var file = File('${downloadDirectory?.path}/transactions${DateFormat("yyyyMMdd hhhmm").format(DateTime.now())}.xlsx');

    // Write the bytes to the file
    await file.writeAsBytes(bytes!);

    // Check if the file exists
    if (await file.exists()) {
      // Open the file for viewing/downloading
      OpenFile.open(file.path);
      print(file.path);
    } else {
      print('File does not exist');
    }
  }
}
