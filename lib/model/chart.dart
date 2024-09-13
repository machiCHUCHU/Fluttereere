class ChartData {
  final int label;
  final int value;

  ChartData({required this.label, required this.value});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      label: json['BookingID'],
      value: json['CustomerLoad'],
    );
  }
}

class BookChartData{
  String? day;
  int? dayCount;

  BookChartData({
    this.day,
    this.dayCount
});

  factory BookChartData.fromJson(Map<String, dynamic> json){
    return BookChartData(
      day: json['day'],
      dayCount: json['daycount']
    );
  }
}