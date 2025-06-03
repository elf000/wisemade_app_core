import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:wisemade_app_core/utils/format.dart';

import '../../models/coin.dart';

class CoinSparkline extends StatelessWidget {
  final Coin? coin;
  final double height;

  const CoinSparkline({
    Key? key,
    required this.coin,
    required this.height
  }) : super(key: key);

  MaterialColor getTrendColor() {
    double lastPrice = coin!.sparklineData![coin!.sparklineData.length - 10];
    double firstPrice = coin!.sparklineData![10];

    if (lastPrice / firstPrice > 1.01) {
      return Colors.green;
    } else if(lastPrice / firstPrice < 0.99) {
      return Colors.red;
    } else {
      return Colors.blue;
    }
  }

  List<double> smoothData(List<double> data, {double alpha = 0.4}) {
    List<double> smoothedData = List<double>.from(data);
    for (int i = 1; i < data.length; i++) {
      smoothedData[i] = alpha * data[i] + (1 - alpha) * smoothedData[i - 1];
    }
    return smoothedData;
  }

  List<Map<String, dynamic>> pricePointsToMap(List<double> prices) {
    List lastPrices = prices.reversed.toList().take(7 * 24).toList().reversed.toList();
    List<Map<String, dynamic>> result = [];
    int totalEntries = lastPrices.length;
    DateTime now = DateTime.now();
    int hoursJump = ((7 * 24) / lastPrices.length).floor();

    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime startDate = today.subtract(const Duration(days: 7));

    for (int i = 0; i < totalEntries; i++) {
      DateTime timestamp = startDate.add(Duration(hours: hoursJump * i));
      result.add({'price': lastPrices[i], 'timestamp': timestamp});
    }

    return result;
  }

  double averageGap(List<double> numbers) {
    if (numbers.length <= 1) {
      throw ArgumentError('The input list must contain at least two elements.');
    }

    double sumOfGaps = 0;
    for (int i = 1; i < numbers.length; i++) {
      sumOfGaps += (numbers[i] - numbers[i - 1]).abs();
    }

    return sumOfGaps / (numbers.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    if(coin?.sparklineData?.isEmpty ?? true) return SkeletonLine(style: SkeletonLineStyle(height: height));

    List<double> data = smoothData(coin!.sparklineData);
    double gap = averageGap(data);

    return coin?.sparkline != null ? SizedBox(
        height: height,
        child: SfCartesianChart(
          plotAreaBorderWidth: 0,
          crosshairBehavior: CrosshairBehavior(enable: true, activationMode: ActivationMode.singleTap),
          primaryXAxis: DateTimeAxis(
              axisLine: const AxisLine(width: 0.3),
              majorGridLines: const MajorGridLines(width: 0.1),
              axisLabelFormatter: (label) {
                return ChartAxisLabel(DateFormat('d/M').format(
                  DateTime.fromMillisecondsSinceEpoch(label.value.toInt())),
                  label.textStyle.copyWith(color: Theme.of(context).colorScheme.shadow)
                );
              },
          ),
          primaryYAxis: NumericAxis(
            labelPosition: ChartDataLabelPosition.inside,
            axisLine: const AxisLine(width: 0.3),
            majorGridLines: const MajorGridLines(width: 0.3),
            maximumLabels: 2,
            axisLabelFormatter: (label) {
              return ChartAxisLabel(Format.currency(label.value, pattern: "\$ #,##0.00######"), label.textStyle.copyWith(color: Theme.of(context).colorScheme.shadow));
            },
            minimum: data.reduce(min) - (gap * 5),
            maximum: data.reduce(max) + (gap * 5)
          ),
          borderWidth: 0,
          series: <LineSeries<Map<String, dynamic>, DateTime>>[
            LineSeries<Map<String, dynamic>, DateTime>(
              dataSource:  pricePointsToMap(data),
              xValueMapper: (Map<String, dynamic> value, _) => value['timestamp'],
              yValueMapper: (Map<String, dynamic> value, _) => value['price'],
              trendlines: [Trendline(isVisible: true, color: Colors.grey, opacity: 0.5, dashArray: [5, 5])],
              color: getTrendColor()
            ),
          ],
        )
      ) : const SizedBox();
  }
}