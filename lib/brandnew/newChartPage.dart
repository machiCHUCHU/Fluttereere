import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:capstone/services/chart.dart';

class NewChartScreen extends StatefulWidget {
  const NewChartScreen({super.key});

  @override
  State<NewChartScreen> createState() => _NewChartScreenState();
}

class _NewChartScreenState extends State<NewChartScreen> {
  bool isLoading = true; bool hasBar = false;
  Map bar = {}; Map monthlyBar = {};
  List<dynamic> doughnut = [];  List<_DoughnutChart> services = []; int serviceMade = 0;
  List<dynamic> inventory = [];  List<_BarChart> inv = []; int invCount = 0;
  String? token;

  var formatter = NumberFormat('#,##,###');

  void getToken() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');

    setState(() {
      isLoading = false;
    });

    getSalesWeekly();
    getSalesMonthly();
    donutChartDisplay();
    inventoryChartDisplay();
  }
  Future<void> getSalesWeekly() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getWeeklySalesChart('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        bar = response.data as Map;

      });
    }else{

    }
  }

  Future<void> getSalesMonthly() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getMonthlySalesBarChart('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        monthlyBar = response.data as Map;

      });
    }else{

    }
  }

  Future<void> donutChartDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getDonutChart('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        doughnut = response.data as List<dynamic>;
        serviceMade = response.count ?? 0;
        services = doughnut.map((item) {
          return _DoughnutChart(item['ServiceName'], item['count'].toDouble());
        }).toList();
      });
    }else{

    }
  }

  Future<void> inventoryChartDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getInventoryChart('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        inventory = response.data as List<dynamic>;
        invCount = response.count ?? 0;
        inv = inventory.map((item) {
          return _BarChart(item['ItemName'], item['ItemQty'].toDouble());
        }).toList();
      });
    }else{

    }
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(monthlyBar);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: isLoading
          ? CircularProgressIndicator()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Weekly Revenue',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey,
                        offset: Offset(0, 2)
                    )
                  ]
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                      isTransposed: true,
                      plotAreaBorderWidth: 0,
                      primaryXAxis: const CategoryAxis(
                        axisLine: AxisLine(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        majorTickLines: MajorTickLines(size: 0),
                      ),
                      primaryYAxis: const NumericAxis(
                        isVisible: false,
                        axisLine: AxisLine(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        majorTickLines: MajorTickLines(size: 0),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<_BarChart, String>>[
                        BarSeries<_BarChart, String>(
                            dataSource: <_BarChart>[
                              _BarChart('Mon', isLoading ? 0 : (bar['monday'] ?? 0).toDouble()),
                              _BarChart('Tue', isLoading ? 0 : (bar['tuesday'] ?? 0).toDouble()),
                              _BarChart('Wed', isLoading ? 0 : (bar['wednesday'] ?? 0).toDouble()),
                              _BarChart('Thu', isLoading ? 0 : (bar['thursday'] ?? 0).toDouble()),
                              _BarChart('Fri', isLoading ? 0 : (bar['friday'] ?? 0).toDouble()),
                              _BarChart('Sat', isLoading ? 0 : (bar['saturday'] ?? 0).toDouble()),
                              _BarChart('Sun', isLoading ? 0 : (bar['sunday'] ?? 0).toDouble()),

                            ],
                            xValueMapper: (_BarChart data, _) => data.x,
                            yValueMapper: (_BarChart data, _) => data.y,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true
                            ),
                            name: 'Revenue',
                          color: ColorStyle.tertiary,
                        ),


                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.square,size: 18,color: ColorStyle.tertiary,),
                        Text('Total: ₱${formatter.format(bar['total'] ?? 0)}.00'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Monthly Revenue',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey,
                        offset: Offset(0, 2)
                    )
                  ]
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                      isTransposed: true,
                      plotAreaBorderWidth: 0,
                      primaryXAxis: const CategoryAxis(
                        axisLine: AxisLine(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        majorTickLines: MajorTickLines(size: 0),
                      ),
                      primaryYAxis: const NumericAxis(
                        isVisible: false,
                        axisLine: AxisLine(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        majorTickLines: MajorTickLines(size: 0),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<_BarChart, String>>[
                        BarSeries<_BarChart, String>(
                            dataSource: <_BarChart>[
                              _BarChart('Jan', isLoading ? 0 : (monthlyBar['jan'] ?? 0).toDouble()),
                              _BarChart('Feb', isLoading ? 0 : (monthlyBar['feb'] ?? 0).toDouble()),
                              _BarChart('Mar', isLoading ? 0 : (monthlyBar['mar'] ?? 0).toDouble()),
                              _BarChart('Apr', isLoading ? 0 : (monthlyBar['apr'] ?? 0).toDouble()),
                              _BarChart('May', isLoading ? 0 : (monthlyBar['may'] ?? 0).toDouble()),
                              _BarChart('Jun', isLoading ? 0 : (monthlyBar['jun'] ?? 0).toDouble()),
                              _BarChart('Jul', isLoading ? 0 : (monthlyBar['jul'] ?? 0).toDouble()),
                              _BarChart('Aug', isLoading ? 0 : (monthlyBar['aug'] ?? 0).toDouble()),
                              _BarChart('Sep', isLoading ? 0 : (monthlyBar['sep'] ?? 0).toDouble()),
                              _BarChart('Oct', isLoading ? 0 : (monthlyBar['oct'] ?? 0).toDouble()),
                              _BarChart('Nov', isLoading ? 0 : (monthlyBar['nov'] ?? 0).toDouble()),
                              _BarChart('Dec', isLoading ? 0 : (monthlyBar['dec'] ?? 0).toDouble()),
                            ],
                            xValueMapper: (_BarChart data, _) => data.x,
                            yValueMapper: (_BarChart data, _) => data.y,
                            color: ColorStyle.tertiary,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true
                            ),
                            name: 'Revenue',
                            ),


                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.square,size: 18,color: ColorStyle.tertiary,),
                        Text('Total: ₱${formatter.format(monthlyBar['total'] ?? 0)}.00'),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Services Made',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            Container(
              height: 200,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey,
                        offset: Offset(0, 2)
                    )
                  ]
              ),
              child:
                  SizedBox(
                    child: SfCircularChart(
                        tooltipBehavior: TooltipBehavior(enable: true),
                        annotations: <CircularChartAnnotation>[

                          CircularChartAnnotation(
                              verticalAlignment: ChartAlignment.center
                              ,
                              widget: Container(
                                  child: Text('$serviceMade',
                                      style: TextStyle(
                                          color: ColorStyle.tertiary, fontSize: 24, fontWeight: FontWeight.bold))))
                        ],
                        legend: Legend(
                          isVisible: true,
                          position: LegendPosition.right
                        ),
                        series: <CircularSeries<_DoughnutChart, String>>[
                          DoughnutSeries<_DoughnutChart, String>(
                              dataSource: services,
                              xValueMapper: (_DoughnutChart data, _) => data.x,
                              yValueMapper: (_DoughnutChart data, _) => data.y,
                              explode: true,
                              explodeAll: true,
                              dataLabelSettings: const DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 14)
                              ),)
                        ]),
              ),
            ),
            const SizedBox(height: 10,),

            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
              child: const Text('Inventory Level',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            ),
            Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 1,
                        color: Colors.grey,
                        offset: Offset(0, 2)
                    )
                  ]
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 200,
                    child: SfCartesianChart(
                      isTransposed: true,
                      plotAreaBorderWidth: 0,
                      primaryXAxis: const CategoryAxis(
                          axisLine: AxisLine(width: 0),
                          majorGridLines: MajorGridLines(width: 0),
                          majorTickLines: MajorTickLines(size: 0),
                          labelIntersectAction: AxisLabelIntersectAction.trim
                      ),
                      primaryYAxis: const NumericAxis(
                        isVisible: false,
                        axisLine: AxisLine(width: 0),
                        majorGridLines: MajorGridLines(width: 0),
                        majorTickLines: MajorTickLines(size: 0),
                      ),
                      tooltipBehavior: TooltipBehavior(enable: true),
                      series: <CartesianSeries<_BarChart, String>>[
                        BarSeries<_BarChart, String>(
                            dataSource: inv,
                            xValueMapper: (_BarChart data, _) => data.x,
                            yValueMapper: (_BarChart data, _) => data.y,
                            dataLabelSettings: const DataLabelSettings(
                                isVisible: true
                            ),
                            name: 'Inventory',
                          color: ColorStyle.tertiary,),


                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.square,size: 18,color: ColorStyle.tertiary,),
                        Text('Total Item Qty: ${invCount}'),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BarChart {
  _BarChart(this.x, this.y);

  final String x;
  final double y;
}

class _DoughnutChart {
  _DoughnutChart(this.x, this.y);

  final String x;
  final double y;
}

List<Color> donutColors = [
  Colors.lightBlue,
  Colors.pinkAccent,
  Colors.orange,
  Colors.green,
  Colors.purple,
];