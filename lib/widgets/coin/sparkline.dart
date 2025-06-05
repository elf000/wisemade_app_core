import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '/utils/format.dart';
import '../../models/coin.dart';

class CoinSparkline extends StatelessWidget {
  final Coin? coin;
  final double height;

  const CoinSparkline({
    super.key,
    required this.coin,
    required this.height,
  });

  MaterialColor getTrendColor() {
    final sparkline = coin!.sparklineData;
    final lastPrice = sparkline[sparkline.length - 10];
    final firstPrice = sparkline[10];

    final ratio = lastPrice / firstPrice;

    if (ratio > 1.01) return Colors.green;
    if (ratio < 0.99) return Colors.red;
    return Colors.blue;
  }

  List<double> smoothData(List<double> data, {double alpha = 0.4}) {
    final smoothedData = List<double>.from(data);
    for (int i = 1; i < data.length; i++) {
      smoothedData[i] = alpha * data[i] + (1 - alpha) * smoothedData[i - 1];
    }
    return smoothedData;
  }

  List<Map<String, dynamic>> pricePointsToMap(List<double> prices) {
    final lastPrices = prices.reversed.toList().take(7 * 24).toList().reversed.toList();
    final result = <Map<String, dynamic>>[];
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startDate = today.subtract(const Duration(days: 7));
    final hoursJump = ((7 * 24) / lastPrices.length).floor();

    for (int i = 0; i < lastPrices.length; i++) {
      final timestamp = startDate.add(Duration(hours: hoursJump * i));
      result.add({'price': lastPrices[i], 'timestamp': timestamp});
    }

    return result;
  }

  double averageGap(List<double> numbers) {
    if (numbers.length <= 1) {
      throw ArgumentError('A lista deve conter ao menos dois elementos.');
    }

    double sum = 0;
    for (int i = 1; i < numbers.length; i++) {
      sum += (numbers[i] - numbers[i - 1]).abs();
    }

    return sum / (numbers.length - 1);
  }

  Widget buildShimmerPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (coin?.sparklineData.isEmpty ?? true) {
      return buildShimmerPlaceholder();
    }

    final data = smoothData(coin!.sparklineData);
    final gap = averageGap(data);

    return coin?.sparkline != null
        ? SizedBox(
      height: height,
      child: SfCartesianChart(
        plotAreaBorderWidth: 0,
        crosshairBehavior: CrosshairBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
        ),
        primaryXAxis: DateTimeAxis(
          axisLine: const AxisLine(width: 0.3),
          majorGridLines: const MajorGridLines(width: 0.1),
          axisLabelFormatter: (label) => ChartAxisLabel(
            DateFormat('d/M').format(DateTime.fromMillisecondsSinceEpoch(label.value.toInt())),
            label.textStyle.copyWith(color: Theme.of(context).colorScheme.shadow),
          ),
        ),
        primaryYAxis: NumericAxis(
          labelPosition: ChartDataLabelPosition.inside,
          axisLine: const AxisLine(width: 0.3),
          majorGridLines: const MajorGridLines(width: 0.3),
          maximumLabels: 2,
          minimum: data.reduce(min) - (gap * 5),
          maximum: data.reduce(max) + (gap * 5),
          axisLabelFormatter: (label) => ChartAxisLabel(
            Format.currency(label.value, pattern: "\$ #,##0.00######"),
            label.textStyle.copyWith(color: Theme.of(context).colorScheme.shadow),
          ),
        ),
        series: <LineSeries<Map<String, dynamic>, DateTime>>[
          LineSeries<Map<String, dynamic>, DateTime>(
            dataSource: pricePointsToMap(data),
            xValueMapper: (value, _) => value['timestamp'],
            yValueMapper: (value, _) => value['price'],
            trendlines: [
              Trendline(
                isVisible: true,
                color: Colors.grey,
                opacity: 0.5,
                dashArray: [5, 5],
              )
            ],
            color: getTrendColor(),
          ),
        ],
      ),
    )
        : const SizedBox();
  }
}