import 'package:flutter/material.dart';
import 'package:moneymanager/ui/views/admin/admin_home.dart';
import 'package:moneymanager/ui/views/details_view.dart';
import 'package:moneymanager/ui/views/edit_view.dart';
import 'package:moneymanager/ui/views/home_view.dart';
import 'package:moneymanager/ui/views/messages/client_services.dart';
import 'package:moneymanager/ui/views/saving.dart';
import 'package:moneymanager/ui/views/sign_in_view.dart';
import 'package:moneymanager/ui/views/spash_view.dart';
import 'package:moneymanager/ui/views/user_home.dart';

import '../core/models/transaction.dart';
import 'views/insert_transaction_view.dart';
import 'views/new_transaction_view.dart';
import 'views/piechart_view.dart';
import 'views/register_view.dart';

const String initialRoute = "login";

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => HomeView());
      case '/login':
        return MaterialPageRoute(builder: (_) => SignInScreen());
      case '/admin':
        return MaterialPageRoute(builder: (_) => AdminHomeScreen());
      case '/admins':
        return MaterialPageRoute(builder: (_) => ClientServices());
      case '/user':
        return MaterialPageRoute(builder: (_) => UserHomeScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => SignupScreen());
      case '/newtransaction':
        return MaterialPageRoute(builder: (_) => NewTransactionView());
      case '/inserttransaction':
        var args = settings.arguments as List<dynamic>;
        return MaterialPageRoute(
            builder: (_) => InsertTranscationView(category: args.elementAt(0), selectedCategory: args.elementAt(1)));
      case '/chart':
        return MaterialPageRoute(builder: (_) => PieChartView());
      case '/details':
        var transaction = settings.arguments as TransactionProcess;
        return MaterialPageRoute(builder: (_) => DetailsView(transaction));
      case '/edit':
        var transaction = settings.arguments as TransactionProcess;
        return MaterialPageRoute(builder: (_) => EditView(transaction));
      case '/savings':
        return MaterialPageRoute(builder: (_) => Savings());
      /*   case 'edit':
        var transaction = settings.arguments as Transaction;
        return MaterialPageRoute(builder: (_) => EditView(transaction));
      case 'chart':
        return MaterialPageRoute(builder: (_) => PieChartView());
      case 'newtransaction':
        return MaterialPageRoute(builder: (_) => NewTransactionView());
      case 'inserttransaction':
        var args = settings.arguments as List<dynamic>;
        return MaterialPageRoute(builder: (_) => InsertTranscationView(args.elementAt(0), args.elementAt(1)));
      case 'details':
        var transaction = settings.arguments as Transaction;
        return MaterialPageRoute(builder: (_) => DetailsView(transaction));
      case 'reminder':
        return MaterialPageRoute(builder: (_) => ReminderView());*/
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
