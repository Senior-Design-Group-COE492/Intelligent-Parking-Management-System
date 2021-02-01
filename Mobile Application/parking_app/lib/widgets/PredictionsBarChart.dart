import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PredictionsBarChart extends StatelessWidget {
  // TODO: finish styling of bar chart
  final List<double> predictions = [
    for (var i = 0; i < 12; i++) Random().nextInt(3945).toDouble()
  ];
  final List<DateTime> dateList = [
    DateTime(2020, 9, 7, 9, 0),
    DateTime(2020, 9, 7, 9, 15),
    DateTime(2020, 9, 7, 9, 30),
    DateTime(2020, 9, 7, 9, 45),
    DateTime(2020, 9, 7, 10, 0),
    DateTime(2020, 9, 7, 10, 15),
    DateTime(2020, 9, 7, 10, 30),
    DateTime(2020, 9, 7, 10, 45),
    DateTime(2020, 9, 7, 11, 0),
    DateTime(2020, 9, 7, 11, 15),
    DateTime(2020, 9, 7, 11, 30),
    DateTime(2020, 9, 7, 11, 45),
    DateTime(2020, 9, 7, 12, 00),
  ];

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

  @override
  Widget build(BuildContext context) {
    final minPrediction = predictions.reduce(min);
    final maxPrediction = predictions.reduce(max);
    final minY = minPrediction / 1.75;
    final yRange = maxPrediction - minY;
    final groupSpaces = Get.width * 0.025;
    // interval calculation to limit the labels shown on the left of the
    double leftInterval = (yRange / 4);
    if (leftInterval > 5) {
      // needed to fix labeling for smaller numbers
      leftInterval = leftInterval - 5;
    }
    final double titleMargin = 10;

    final titlesData = FlTitlesData(
        show: true,
        leftTitles: SideTitles(
            margin: titleMargin,
            showTitles: true,
            interval: (leftInterval),
            getTextStyles: (value) => const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
            getTitles: (double value) {
              return value.toInt().toString();
            }),
        bottomTitles: SideTitles(
            margin: titleMargin,
            showTitles: true,
            getTextStyles: (value) => const TextStyle(
                color: Colors.black, fontWeight: FontWeight.w500),
            getTitles: (double value) {
              final index = value.toInt();
              final date = dateList[index];
              final hour = date.hour;
              // adds a 0 to the left if it is a single digit number
              final minute = date.minute.toString().padLeft(2, '0');
              // only every 4th title is shown in the bottom title
              final barBottomTitle = (index % 5 == 1) ? '$hour:$minute' : '';
              return barBottomTitle;
            }));

    final gridData = FlGridData(
        show: true,
        horizontalInterval: leftInterval,
        getDrawingHorizontalLine: (value) {
          return FlLine(color: Colors.grey[200], strokeWidth: 1);
        });

    final touchData = BarTouchData(
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: Colors.black54,
        getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
        ) {
          return BarTooltipItem(
            rod.y.round().toString(),
            TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          );
        },
      ),
    );

    List<BarChartGroupData> barChartGroupList = [];
    for (var i = 0; i < predictions.length; i++) {
      barChartGroupList.add(
          _makeChartGroupData(predictions[Random().nextInt(12)], i, context));
    }

    final chart = BarChart(BarChartData(
      alignment: BarChartAlignment.center,
      borderData: FlBorderData(show: false),
      titlesData: titlesData, // x and y styling
      barTouchData: touchData,
      barGroups: barChartGroupList,
      gridData: gridData,
      groupsSpace: groupSpaces,
      minY: minY,
    ));

    return Align(
      child: Container(
        // margin needed to re-center the chart
        margin: EdgeInsets.only(right: titleMargin),
        height: 150,
        width: Get.width * 0.75,
        child: chart,
      ),
    );
  }
}
