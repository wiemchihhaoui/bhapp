import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/core/enums/viewstate.dart';
import 'package:moneymanager/core/models/transaction.dart';
import 'package:moneymanager/core/viewmodels/home_model.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';
import 'package:moneymanager/ui/views/base_view.dart';
import 'package:moneymanager/ui/views/settings.dart';
import 'package:moneymanager/ui/widgets/home_view_widgets/app_bar_title_widget.dart';
import 'package:moneymanager/ui/widgets/home_view_widgets/app_drawer.dart';
import 'package:moneymanager/ui/widgets/home_view_widgets/app_fab.dart';
import 'package:moneymanager/ui/widgets/home_view_widgets/empty_transaction_widget.dart';
import 'package:moneymanager/ui/widgets/home_view_widgets/month_year_picker_widget.dart';
import 'package:moneymanager/ui/widgets/home_view_widgets/summary_widget.dart';
import 'package:moneymanager/ui/widgets/home_view_widgets/transactions_listview_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  @override
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
      model: HomeModel(),
      onModelReady: (model) async => await model.init(),
      builder: (context, model, child) => Scaffold(
        appBar: buildAppBar(model.appBarTitle, model),
        drawer: AppDrawer(),
        floatingActionButton: Visibility(
          visible: model.show,
          child: AppFAB(model.closeMonthPicker),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  width: Constants.screenWidth,
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/user.png",
                        height: Constants.screenHeight * 0.06,
                      ),
                      Text(
                        "${'welcome'.tr} ${model.user["userName"].toString().toUpperCase()}",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )),
            ),
            if (model.state == ViewState.Busy)
              Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: Stack(
                  children: <Widget>[
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(model.user['uid'])
                          .collection("transactions")
                          .where("month", isEqualTo: model.appBarTitle)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var data = snapshot.data!.docs.toList();
                          dynamic income = 0;
                          dynamic expenses = 0;
                          List<TransactionProcess> trProcess = [];
                          for (var value in data) {
                            TransactionProcess tr = TransactionProcess(
                                type: value.get('type'),
                                id: value.id,
                                day: value.get('day'),
                                month: value.get('month'),
                                memo: value.get('memo'),
                                amount: value.get('amount') + .0,
                                categoryindex: value.get('categoryindex'));
                            trProcess.add(tr);
                            if (value.get("type") == "expense") {
                              expenses = expenses + value.get("amount");
                            } else {
                              income = income + value.get("amount");
                            }
                          }
                          trProcess = trProcess.reversed.toList();
                          return Container(
                            child: Column(
                              children: <Widget>[
                                SummaryWidget(
                                  income: income,
                                  expense: expenses,
                                ),
                                buildList(model, trProcess),
                              ],
                            ),
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                    model.isCollabsed
                        ? PickMonthOverlay(model: model, showOrHide: model.isCollabsed, context: context)
                        : Container(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  buildAppBar(String title, HomeModel model) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: primaryColor,
      title: AppBarTitle(
        title: title,
        model: model,
      ),
      actions: [
        IconButton(
            onPressed: () {
              Get.to(AppSettings());
            },
            icon: Icon(
              Icons.settings,
              color: Colors.white,
            ))
      ],
    );
  }

  buildList(HomeModel model, List<TransactionProcess> transactionProcess) {
    return transactionProcess.isEmpty ? EmptyTransactionsWidget() : TransactionsListView(transactionProcess, model);
  }
}
