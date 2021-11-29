import 'dart:math';
import 'package:intl/intl.dart';
import 'package:app_qrcode_login/bussines/chart_month.dart';

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class RelatorioChart extends StatelessWidget {
  final List<ChartRelatorio> data;

  String getMonth(int m, int y) {
    var date = DateTime(y, m);

    return '' + DateFormat('MMM').format(date);
  }

  RelatorioChart({required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartRelatorio, String>> series = [
      charts.Series(
          id: "developers",
          data: data,
          domainFn: (ChartRelatorio series, _) =>
              getMonth(series.month, series.year),
          measureFn: (ChartRelatorio series, _) => series.total,
          colorFn: (ChartRelatorio series, _) =>
              charts.ColorUtil.fromDartColor(Colors.blue))
    ];

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: charts.BarChart(
                series,
                animate: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
