import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneymanager/core/enums/viewstate.dart';
import 'package:moneymanager/ui/shared/app_colors.dart';
import 'package:moneymanager/ui/shared/dimensions/dimensions.dart';
import 'package:moneymanager/ui/views/base_view.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../core/viewmodels/piechart_model.dart';

class PieChartView extends StatelessWidget {
  const PieChartView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<PieChartModel>(
      model: PieChartModel(),
      onModelReady: (model) => model.init(true),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          backgroundColor: primaryColor,
          title: Text(
            'statistics'.tr,
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {
                model.generateExcelAndDownload();
              },
              icon: Icon(Icons.download),
            ),
          ],
        ),
        body: model.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    child: Container(
                      width: Constants.screenWidth,
                      child: Column(
                        children: <Widget>[
                          ChipsChoice<int>.single(
                            choiceCheckmark: true,
                            value: model.selectedMonthIndex,
                            wrapped: true,
                            choiceItems: C2Choice.listFrom<int, String>(
                              source: model.months,
                              value: (i, v) => i,
                              label: (i, v) => v,
                            ),
                            onChanged: (val) => model.changeSelectedMonth(val),
                          ),
                          ChipsChoice<int>.single(
                            value: model.type == 'income' ? 0 : 1,
                            wrapped: true,
                            choiceCheckmark: true,
                            choiceItems: C2Choice.listFrom<int, String>(
                              source: model.types,
                              value: (i, v) => i,
                              label: (i, v) => v,
                            ),
                            onChanged: (val) => model.changeType(val),
                          ),
                          model.dataMap.length == 0 ? Text('No_Data_for_this_month'.tr) : PieChart(dataMap: model.dataMap),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
