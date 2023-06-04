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
      'food'.tr: 0,
      'bills.tr': 0,
      'transportation'.tr: 0,
      'home'.tr: 0,
      'entertainment'.tr: 0,
      'shopping'.tr: 0,
      'clothing'.tr: 0,
      'insurance'.tr: 0,
      'telephone'.tr: 0,
      'health'.tr: 0,
      'sport'.tr: 0,
      'beauty'.tr: 0,
      'education'.tr: 0,
      'gift'.tr: 0,
      'pet'.tr: 0,
      'saving'.tr: 0,
    };

    Map<String, double> fullIncomeMap = {
      'salary'.tr: 0,
      'awards'.tr: 0,
      'grants'.tr: 0,
      'rental'.tr: 0,
      'investment'.tr: 0,
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
    await init(false);
  }

  void prepareDataMap(element) {
    if (type == 'income') {
      dataMap[_categoryIconService.incomeList.elementAt(element.categoryindex).name] =
          element.amount + .0 + dataMap[_categoryIconService.incomeList.elementAt(element.categoryindex).name];
    } else {
      dataMap[_categoryIconService.expenseList.elementAt(element.categoryindex).name] =
          element.amount + .0 + dataMap[_categoryIconService.expenseList.elementAt(element.categoryindex).name];
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
    } else {}
  }
}
