
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/ConstWidgets.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/model/CalendarInfo.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewChartScreen extends StatefulWidget {
  const NewChartScreen({super.key});

  @override
  State<NewChartScreen> createState() => _NewChartScreenState();
}

class _NewChartScreenState extends State<NewChartScreen> {
  bool isLoading = true; bool hasBar = false;
  Map bar = {}; Map monthlyBar = {};
  List<dynamic> doughnut = [];  List<_DoughnutChart> services = []; int serviceMade = 0;
  List<dynamic> inventory = [];  int invCount = 0; String? token; var formatter = NumberFormat('#,##,###');

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
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
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
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
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
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> inventoryChartDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getInventoryChart('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        inventory = response.data as List<dynamic>;
        invCount = response.count ?? 0;
      });
    }else{
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  List<BarChartGroupData> getWeeklyChart(CalendarWeek week) {
    return [
      BarChartGroupData(
          x: 0,
        barRods: [
          BarChartRodData(
              toY: double.tryParse('${week.monday}') ?? 0,
              color: Colors.red,
              width: 15
          )
        ]
      ),
      BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${week.tuesday}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${week.wednesday}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${week.thursday}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${week.friday}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${week.saturday}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${week.sunday}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      )
    ];
  }

  List<BarChartGroupData> getMonthlyChart(CalendarMonth month) {
    return [
      BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.jan}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.feb}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.mar}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.apr}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.may}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.jun}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.jul}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 7,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.aug}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.sep}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 9,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.oct}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 10,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.nov}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 11,
          barRods: [
            BarChartRodData(
                toY: double.tryParse('${month.dec}') ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      )
    ];
  }

  List<Color> colors = [Colors.lightBlue,
    Colors.pinkAccent,
    Colors.orange,
    Colors.green,
    Colors.purple,];

  List<PieChartSectionData> servicesChart(){

    return List.generate(doughnut.length, (index) {
      return PieChartSectionData(
          value: double.tryParse('${doughnut[index]['count']}') ?? 0,
          color: colors[index],
          radius: 20,
          title: '${doughnut[index]['count']}',
          titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
      );
    });
  }

  @override
  void initState() {
    getToken();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(bar);
    CalendarWeek week = CalendarWeek(
        monday: '${bar['monday']}', tuesday: '${bar['tuesday']}', wednesday: '${bar['wednesday']}', thursday: '${bar['thursday']}',
        friday: '${bar['friday']}', saturday: '${bar['saturday']}', sunday: '${bar['sunday']}');

    CalendarMonth month = CalendarMonth(
      jan: '${monthlyBar['jan']}', feb: '${monthlyBar['feb']}', mar: '${monthlyBar['mar']}', apr: '${monthlyBar['apr']}',
      may: '${monthlyBar['may']}', jun: '${monthlyBar['jun']}', jul: '${monthlyBar['jul']}', aug: '${monthlyBar['aug']}',
      sep: '${monthlyBar['sep']}', oct: '${monthlyBar['oct']}', nov: '${monthlyBar['nov']}', dec: '${monthlyBar['dec']}') ;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Dashboard'),
      ),
      body: isLoading
          ? const CircularProgressIndicator()
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
                    child: BarChart(
                      BarChartData(
                        barGroups: getWeeklyChart
                          (week),
                        borderData: FlBorderData(show: false),
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta){
                                List<String> labels = ["Mon", "Tue", "Wed", "Thur", "Fri", "Sat", "Sun"];
                                return Text(labels[value.toInt()]);
                              }
                            )
                          )
                        )
                      )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.square,size: 18,color: ColorStyle.tertiary,),
                        Text('Total: ₱${formatter.format(bar['total'] ?? 0)}'),
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
                    child: BarChart(
                        BarChartData(
                            barGroups: getMonthlyChart(month),
                            borderData: FlBorderData(show: false),
                            gridData: const FlGridData(show: false),
                            titlesData: FlTitlesData(
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                        showTitles: true,
                                        getTitlesWidget: (double value, TitleMeta meta){
                                          List<String> labels = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                                          "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                                          return Text(labels[value.toInt()]);
                                        }
                                    )
                                )
                            )
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.square,size: 18,color: ColorStyle.tertiary,),
                        Text('Total: ₱${formatter.format(monthlyBar['total'] ?? 0)}'),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Donut Chart
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections: servicesChart(),
                            centerSpaceRadius: 42,
                            borderData: FlBorderData(show: false),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),

                      Expanded(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(doughnut.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Container(width: 16, height: 16, color: colors[index]),
                                const SizedBox(width: 8),
                                Expanded(
                                    child: Text('${doughnut[index]['ServiceName']}',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))
                                )
                              ],
                            ),
                          );
                        }),
                      ),)
                    ],
                  ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}


class _DoughnutChart {
  final String x;
  final double y;

  _DoughnutChart(this.x, this.y);
}

List<Color> donutColors = [
  Colors.lightBlue,
  Colors.pinkAccent,
  Colors.orange,
  Colors.green,
  Colors.purple,
];