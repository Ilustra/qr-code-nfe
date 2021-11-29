import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';

class ChartRelatorio {
  final int year;
  final int month;
  late double total;
  final charts.Color barColor;

  ChartRelatorio(
      {required this.year,
      required this.month,
      required this.total,
      required this.barColor});

  void somaTotal(double value) {
    this.total += value;
  }
}
