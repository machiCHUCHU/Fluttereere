
import 'package:capstone/api_response.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  List<dynamic> inventory = [];  int invCount = 0;
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
      });
    }else{

    }
  }

  List<BarChartGroupData> getWeeklyChart(String monRevenue, String tueRevenue, String wedRevenue,
      String thuRevenue, String friRevenue, String satRevenue, String sunRevenue) {
    return [
      BarChartGroupData(
          x: 0,
        barRods: [
          BarChartRodData(
              toY: double.tryParse(monRevenue) ?? 0,
              color: Colors.red,
              width: 15
          )
        ]
      ),
      BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(tueRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(wedRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(thuRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(friRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(satRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(sunRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      )
    ];
  }

  List<BarChartGroupData> getMonthlyChart(String janRevenue, String febRevenue, String marRevenue,
      String aprRevenue, String mayRevenue, String junRevenue, String julRevenue, String augRevenue, String sepRevenue,
      String octRevenue, String novRevenue, String decRevenue) {
    return [
      BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(janRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(febRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(marRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(aprRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(mayRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(junRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 6,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(julRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 7,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(augRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 8,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(sepRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 9,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(octRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 10,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(novRevenue) ?? 0,
                color: Colors.red,
                width: 15
            )
          ]
      ),
      BarChartGroupData(
          x: 11,
          barRods: [
            BarChartRodData(
                toY: double.tryParse(decRevenue) ?? 0,
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
                          ('${bar['monday']}', '${bar['tuesday']}',
                          '${bar['wednesday']}', '${bar['thursday']}',
                          '${bar['friday']}', '${bar['saturday']}', '${bar['sunday']}'),
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
                            barGroups: getMonthlyChart(
                                '${monthlyBar['jan']}', '${monthlyBar['feb']}', '${monthlyBar['mar']}',
                                '${monthlyBar['apr']}', '${monthlyBar['may']}', '${monthlyBar['jun']}',
                                '${monthlyBar['jul']}', '${monthlyBar['aug']}', '${monthlyBar['sep']}',
                                '${monthlyBar['oct']}', '${monthlyBar['nov']}', '${monthlyBar['dec']}'),
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


                      Expanded(child: Column(
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