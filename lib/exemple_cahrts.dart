import 'dart:math';

import 'package:app_qrcode_login/bussines/chart_dashboard.dart';
import 'package:app_qrcode_login/bussines/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'bussines/developer_chart.dart';

class DeveloperChart extends StatelessWidget {
  final List<Dashboard> data;

  DeveloperChart({required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<Dashboard, String>> series = [
      charts.Series(
          id: "developers",
          data: data,
          domainFn: (Dashboard series, _) => series.nome.toString(),
          measureFn: (Dashboard series, _) => series.total,
          colorFn: (Dashboard series, _) => series.barColor)
    ];

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: charts.PieChart(
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
