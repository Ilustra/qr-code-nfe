class ChartDashboard {
  final String segment;
  final int size;

  ChartDashboard({required this.segment, required this.size});

  factory ChartDashboard.fromJson(dynamic json) {
    return ChartDashboard(segment: json['nome'], size: json['total']);
  }
}
