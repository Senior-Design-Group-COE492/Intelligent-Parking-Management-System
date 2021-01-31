import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PredictionsBarChart extends StatelessWidget {
  // TODO: finish styling of bar chart
  final List<double> predictions = [
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22
  ];
  @override
  Widget build(BuildContext context) {
    List<BarChartGroupData> barChartGroupList = [];
    for (var i = 0; i < predictions.length; i++) {
      barChartGroupList.add(
          _makeChartGroupData(predictions[Random().nextInt(12)], i, context));
    }
    final chart = BarChart(BarChartData(
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(show: false), // x and y styling
      barGroups: barChartGroupList,
    ));

    return Align(
      child: Container(
        height: 200,
        width: Get.width * 0.5,
        child: chart,
      ),
    );
  }

  BarChartGroupData _makeChartGroupData(
      double prediction, int index, BuildContext context) {
    return BarChartGroupData(
      x: index,
      barRods: [
        BarChartRodData(
          colors: [Theme.of(context).accentColor],
          width: 10,
          y: prediction,
        ),
      ],
    );
  }
}
