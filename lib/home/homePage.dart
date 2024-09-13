import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/drawer/ownerDrawer.dart';
import 'package:capstone/home/homePage.dart';
import 'package:capstone/model/chart.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWid;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void viewMore(){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            content: Container(
              height: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black,
                          fixedSize: Size(200, 50),
                          backgroundColor: Color(0xFF597FAF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SalesDashboardScreen()));
                      },
                      child: const Text(
                        'Sales',
                        style: TextStyle(
                            color: Color(0xFFF6F6F6),
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shadowColor: Colors.black,
                          fixedSize: Size(200, 50),
                          backgroundColor: Color(0xFF597FAF),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          )
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingDashboardScreen()));
                      },
                      child: const Text(
                        'Bookings',
                        style: TextStyle(
                            color: Color(0xFFF6F6F6),
                            fontWeight: FontWeight.bold
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        }
    );
  }

  String? token;
  int? userid;
  int? shopid;
  String? today;
  int? sales;
  int? bookings;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
    homeDisplay();
  }

  Future<void> homeDisplay() async{
    ApiResponse response = await getHome(token.toString());

    if(response.error == null){
      setState(() {
        today = response.today; sales = response.sales; bookings = response.totalbooks;
      });
    }else{
      print(response.error);

    }
  }

  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(

      body: Column(
        children: [
          SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 200,
                child: Card(
                    elevation: 5,
                    shadowColor: Colors.black,
                    color: Color(0xFFE3F3FF),
                    child: Column(
                      children: [
                        Text(
                          'Daily Sales',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 25,),
                        Text(
                          '$sales',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                ),
              ),
              Container(
                height: 150,
                width: 150,
                child: Card(
                    elevation: 5,
                    shadowColor: Colors.black,
                    color: Color(0xFFE3F3FF),
                    child: Column(
                      children: [
                        Text(
                          'Bookings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 25,),
                        Text(
                          '$bookings',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150,
                width: 200,
                child: Card(
                    elevation: 5,
                    shadowColor: Colors.black,
                    color: Color(0xFFE3F3FF),
                    child: Column(
                      children: [
                        Text(
                          'Daily Sales',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 25,),
                        Text(
                          '4,530.00',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 32
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  shadowColor: Colors.black,
                  fixedSize: Size(200, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  )
              ),
              onPressed: (){
                setState(() {
                  viewMore();
                });
              },
              child: const Text(
                'View More',
                style: TextStyle(
                    color: Color(0xFFF6F6F6),
                    fontWeight: FontWeight.bold
                ),
              )
          )
        ],
      ),
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 50,
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PDFScreen()));
          },
          child: const Text(
            'Download as PDF',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ),
    )
    );
  }
}

class SalesDashboardScreen extends StatefulWidget {
  const SalesDashboardScreen({super.key});

  @override
  State<SalesDashboardScreen> createState() => _SalesDashboardScreenState();
}

class _SalesDashboardScreenState extends State<SalesDashboardScreen> {

  int? monday; int? tuesday; int? wednesday; int? thursday;
  int? friday; int? saturday; int? sunday; int? mostday; String? dayname;
  int? weeklyTotal; int? weeklyLoad; int? lowest; int? highest; int? total;

  int? jan; int? feb; int? mar; int? apr; int? may; int? jun;
  int? jul; int? aug; int? sep; int? oct; int? nov; int? dec;
  int? minmonth; int? mostmonth; int? monthlyTotal; int? monthlyLoad;

  String? token;
  int? userid;
  int? shopid;
  String _selectedRange = 'Weekly';

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
    getSalesWeekly();
    getSalesMonthly();
  }

  Future<void> getSalesWeekly() async{
    ApiResponse response = await getWeeklySalesChart(token.toString());

    if(response.error == null){
      setState(() {
        lowest = response.low; highest = response.high; total = response.total;
        monday = response.mon; tuesday = response.tue; wednesday = response.wed;
        thursday = response.thu; friday = response.fri; saturday = response.sat;
        sunday = response.sun; mostday = response.mostday; dayname = response.status;
        isLoading = false;
      });
    }else{
      print(response.error);
      isLoading = false;
    }
  }

  Future<void> getSalesMonthly() async{
    ApiResponse response = await getMonthlySalesChart(token.toString());

    if(response.error == null){
      setState(() {
        jan = response.jan; feb = response.feb; mar = response.mar; apr = response.apr;
        may = response.may; jun = response.jun; jul = response.jul; aug = response.aug;
        sep = response.sep; oct = response.oct; nov = response.nov; dec = response.dec;
        minmonth = response.low; mostmonth = response.high; monthlyTotal = response.total;
        isLoading = false;
      });
    }else{
      print(response.error);
      isLoading = false;
    }
  }

  @override
  void initState(){
    super.initState();
    getUser();
  }
  List<Color> gradientColors = [
    Colors.cyan,
    Colors.blue
  ];

  bool showAvg = false;
  bool isWeekly = true;
  bool isLoading = true;


  Widget bottomTitleWidgetsWeekly(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('MON', style: style);
        break;
      case 1:
        text = const Text('TUE', style: style);
        break;
      case 2:
        text = const Text('WED', style: style);
        break;
      case 3:
        text = const Text('THU', style: style);
        break;
      case 4:
        text = const Text('FRI', style: style);
        break;
      case 5:
        text = const Text('SAT', style: style);
        break;
      case 6:
        text = const Text('SUN', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget bottomTitleWidgetsMonthly(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('J', style: style);
        break;
      case 1:
        text = const Text('F', style: style);
        break;
      case 2:
        text = const Text('M', style: style);
        break;
      case 3:
        text = const Text('A', style: style);
        break;
      case 4:
        text = const Text('M', style: style);
        break;
      case 5:
        text = const Text('J', style: style);
        break;
      case 6:
        text = const Text('J', style: style);
        break;
      case 7:
        text = const Text('A', style: style);
        break;
      case 8:
        text = const Text('S', style: style);
        break;
      case 9:
        text = const Text('O', style: style);
        break;
      case 10:
        text = const Text('N', style: style);
        break;
      case 11:
        text = const Text('D', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '${lowest ?? 0}';
        break;
      case 3:
        text = '${lowest ?? 0  * 3}';
        break;
      case 5:
        text = '${lowest ?? 0 * 5}';
        break;
      case 7:
        text = '${lowest ?? 0 * 7}';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
      if(_selectedRange == 'Monthly'){
        setState(() {
          isWeekly = false;
        });
      }else{
        setState(() {
          isWeekly = true;
        });
      }
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.cyan,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: isWeekly ? bottomTitleWidgetsWeekly : bottomTitleWidgetsMonthly,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: isWeekly ? 6 : 11,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        isWeekly ?
        LineChartBarData(
          spots: [
            FlSpot(0, (monday ?? 0) * .01),
            FlSpot(1, (tuesday ?? 0) * .01),
            FlSpot(2, (wednesday ?? 0) * .01),
            FlSpot(3, (thursday ?? 0) * .01),
            FlSpot(4, (friday ?? 0) * .01),
            FlSpot(5, (saturday ?? 0) * .01),
            FlSpot(6, (sunday ?? 0) * .01),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(.7))
                  .toList(),
            ),
          ),
        ) :
        LineChartBarData(
          spots: [
            FlSpot(0, (jan ?? 0) * .01),
            FlSpot(1, (feb ?? 0) * .01),
            FlSpot(2, (mar ?? 0) * .01),
            FlSpot(3, (apr ?? 0) * .01),
            FlSpot(4, (may ?? 0) * .01),
            FlSpot(5, (jun ?? 0) * .01),
            FlSpot(6, (jul ?? 0) * .01),
            FlSpot(7, (aug ?? 0) * .01),
            FlSpot(8, (sep ?? 0) * .01),
            FlSpot(9, (oct ?? 0) * .01),
            FlSpot(10, (nov ?? 0) * .01),
            FlSpot(11, (dec ?? 0) * .01),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget leftTileLoading(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '0';
        break;
      case 3:
        text = '0';
        break;
      case 5:
        text = '0';
        break;
      case 7:
        text = '0';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }
  LineChartData loadingData() {

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Colors.grey,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Colors.cyan,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgetsWeekly,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTileLoading,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: isWeekly ? 6 : 11,
      minY: 0,
      maxY: 10,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0,0),
            FlSpot(1,0),
            FlSpot(2,0),
            FlSpot(3,0),
            FlSpot(4,0),
            FlSpot(5,0),
            FlSpot(6,0),
          ],
          isCurved: false,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading)
    {
      return Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String newValue) {
                setState(() {
                  _selectedRange = newValue;
                });
              },
              itemBuilder: (BuildContext context) {
                return ['Weekly', 'Monthly'].map((String value) {
                  return PopupMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList();
              },
              offset: Offset(0, 50),
            )
          ],
        ),
        body: Column(
          children: [
            Card(
                color: Colors.white,
                elevation: 5,
                child: Column(
                  children: [
                    Text(
                      'Weekly Sales',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.70,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 18,
                              left: 12,
                              top: 24,
                              bottom: 12,
                            ),
                            child: LineChart(
                                loadingData()
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ),
            Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10
                  ),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[100],
                      child: Column(
                        children: [
                          const Text(
                            'Highest Sales',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),

                          Text('',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                            ),)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[200],
                      child: Column(
                        children: [
                          const Text(
                            'Total Sales',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),

                          Text('',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                            ),)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[300],
                      child: Column(
                        children: [
                          const Text(
                            'Lowest Sales',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),

                          Text('',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                            ),)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[400],
                      child: Column(
                        children: [
                          const Text(
                            'Average Sales',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),

                          Text('',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                            ),)
                        ],
                      ),
                    ),
                  ],
                )
            )
          ],
        ),

        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF597FAF)
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PDFScreen()));
            },
            child: const Text(
              'Download as PDF',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
      );
    }
    else{
      return Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            icon: Icon(Icons.arrow_back),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (String newValue) {
                setState(() {
                  _selectedRange = newValue;
                });
              },
              itemBuilder: (BuildContext context) {
                return ['Weekly', 'Monthly'].map((String value) {
                  return PopupMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList();
              },
              offset: Offset(0, 50),
            )
          ],
        ),
        body: Column(
          children: [
            Card(
                color: Colors.white,
                elevation: 5,
                child: Column(
                  children: [
                    Text(
                      _selectedRange == 'Weekly' ? 'Weekly Sales' : 'Monthly Sales',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18
                      ),
                    ),
                    Stack(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 1.70,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 18,
                              left: 12,
                              top: 24,
                              bottom: 12,
                            ),
                            child: LineChart(
                                mainData()
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
            ),
            Expanded(
                child: GridView.count(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 10
                  ),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[100],
                      child: Column(
                        children: [
                          const Text(
                            'Highest Sales',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),

                          Text(_selectedRange == 'Weekly' ? '${highest ?? 0}' : '${mostmonth ?? 0}',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                            ),)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[200],
                      child: Column(
                        children: [
                          const Text(
                            'Total Sales',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),

                          Text(_selectedRange == 'Weekly' ? '${total ?? 0}' : '${monthlyTotal ?? 0}',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                            ),)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[300],
                      child: Column(
                        children: [
                          const Text(
                            'Lowest Sales',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),

                          Text(_selectedRange == 'Weekly' ? '${lowest ?? 0}' : '${minmonth ?? 0}',
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                            ),)
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.teal[400],
                      child: Column(
                        children: [
                          const Text(
                            'Average Sales',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10,),

                          Text(_selectedRange == 'Weekly' ? ((total ?? 0) / 7).toStringAsFixed(2) : ((monthlyTotal ?? 0) / 7).toStringAsFixed(2),
                            style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold
                            ),)
                        ],
                      ),
                    ),
                  ],
                )
            )
          ],
        ),

        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF597FAF)
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const PDFScreen()));
            },
            child: const Text(
              'Download as PDF',
              style: TextStyle(
                  color: Colors.white
              ),
            ),
          ),
        ),
      );
    }
  }
}

class BookingDashboardScreen extends StatefulWidget {
  const BookingDashboardScreen({super.key});

  @override
  State<BookingDashboardScreen> createState() => _BookingDashboardScreenState();
}

class _BookingDashboardScreenState extends State<BookingDashboardScreen> {
  int monday = 0; int tuesday = 0; int wednesday = 0; int thursday = 0;
  int friday = 0; int saturday = 0; int sunday = 0; int mostday = 0; String? dayname;
  int weeklyTotal = 0; int weeklyLoad = 0;

  int jan = 0; int feb = 0; int mar = 0; int apr = 0; int may = 0; int jun = 0;
  int jul = 0; int aug = 0; int sep = 0; int oct = 0; int nov = 0; int dec = 0;
  int mostmonth = 0; String? monthname; int monthlyTotal = 0; int monthlyLoad = 0;

  String? token;
  int? userid;
  int? shopid;
  String? _selectedRange;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
    getBookData();
    getBookDataMonthly();
  }

  Future<void> getBookData() async{
    ApiResponse response = await getWeeklyBookingChart(shopid.toString());

    if(response.error == null){
      setState(() {
        monday = response.mon!; tuesday = response.tue!; wednesday = response.wed!;
        thursday = response.thu!; friday = response.fri!; saturday = response.sat!;
        sunday = response.sun!; mostday = response.mostday!; dayname = response.status!;
        weeklyTotal = response.totalbooks!; weeklyLoad = response.weeklyload!;
      });
    }else{
      print(response.error);
    }
  }
  Future<void> getBookDataMonthly() async{
    ApiResponse response = await getMonthBookingChart(shopid.toString());

    if(response.error == null){
      setState(() {
        jan = response.jan!; feb = response.feb!; mar = response.mar!; apr = response.apr!;
        may = response.may!; jun = response.jun!; jul = response.jul!; aug = response.aug!;
        sep = response.sep!; oct = response.oct!; nov = response.nov!; dec = response.dec!;
        mostmonth = response.mostmonth!; monthname = response.status!;
        monthlyTotal = response.totalbooks!; monthlyLoad = response.monthlyload!;
      });
    }else{
      print(response.error);
    }
  }

  void initState(){
    super.initState();
    getUser();
  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: true,
    touchTooltipData: BarTouchTooltipData(
      getTooltipColor: (group) => Colors.transparent,
      tooltipPadding: EdgeInsets.zero,
      tooltipMargin: 0,
      fitInsideVertically: true,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.toY.round().toString(),
          const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        );
      },
    ),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

  LinearGradient get _barsGradient => LinearGradient(
    colors: [
      Colors.black,
      Colors.cyan,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  FlTitlesData get titlesData => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  FlTitlesData get titlesData2 => FlTitlesData(
    show: true,
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 30,
        getTitlesWidget: getTitles2,
      ),
    ),
    leftTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    topTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
    rightTitles: const AxisTitles(
      sideTitles: SideTitles(showTitles: false),
    ),
  );

  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Mon';
        break;
      case 1:
        text = 'Tue';
        break;
      case 2:
        text = 'Wed';
        break;
      case 3:
        text = 'Thu';
        break;
      case 4:
        text = 'Fri';
        break;
      case 5:
        text = 'Sat';
        break;
      case 6:
        text = 'Sun';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget getTitles2(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'Jan';
        break;
      case 1:
        text = 'Feb';
        break;
      case 2:
        text = 'Mar';
        break;
      case 3:
        text = 'Apr';
        break;
      case 4:
        text = 'May';
        break;
      case 5:
        text = 'Jun';
        break;
      case 6:
        text = 'Jul';
        break;
      case 7:
        text = 'Aug';
        break;
      case 8:
        text = 'Sep';
        break;
      case 9:
        text = 'Oct';
        break;
      case 10:
        text = 'Nov';
        break;
      case 11:
        text = 'Dec';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  List<BarChartGroupData> get barGroups => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
          toY: monday.toDouble(),
          gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
          toY: tuesday.toDouble(),
          gradient: _barsGradient,
          width: 20,
          borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
          toY: wednesday.toDouble(),
          gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
          toY: thursday.toDouble(),
          gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 4,
      barRods: [
        BarChartRodData(
          toY: friday.toDouble(),
          gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 5,
      barRods: [
        BarChartRodData(
          toY: saturday.toDouble(),
          gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 6,
      barRods: [
        BarChartRodData(
          toY: sunday.toDouble(),
          gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
  ];

  List<BarChartGroupData> get barGroups2 => [
    BarChartGroupData(
      x: 0,
      barRods: [
        BarChartRodData(
            toY: jan.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 1,
      barRods: [
        BarChartRodData(
            toY: feb.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 2,
      barRods: [
        BarChartRodData(
            toY: mar.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 3,
      barRods: [
        BarChartRodData(
            toY: apr.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 4,
      barRods: [
        BarChartRodData(
            toY: may.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 5,
      barRods: [
        BarChartRodData(
            toY: jun.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 6,
      barRods: [
        BarChartRodData(
            toY: jul.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 7,
      barRods: [
        BarChartRodData(
            toY: aug.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 8,
      barRods: [
        BarChartRodData(
            toY: sep.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 9,
      barRods: [
        BarChartRodData(
            toY: oct.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 10,
      barRods: [
        BarChartRodData(
            toY: nov.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
    BarChartGroupData(
      x: 11,
      barRods: [
        BarChartRodData(
            toY: dec.toDouble(),
            gradient: _barsGradient,
            width: 20,
            borderRadius: BorderRadius.zero
        )
      ],
      showingTooltipIndicators: [0],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool isWeekly = true;
    String avgBook = '${weeklyLoad/7}'.toString();
    if(_selectedRange == 'Monthly'){
      setState(() {
        isWeekly = false;
      });
    }
    return Scaffold(
      backgroundColor: Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
        actions: [

          PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (String newValue) {
                  setState(() {
                    _selectedRange = newValue;
                  });
                },
                itemBuilder: (BuildContext context) {
                  return ['Weekly', 'Monthly'].map((String value) {
                    return PopupMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList();
                },
                offset: Offset(0, 50),
              )
        ],
      ),
      body: Column(
        children: [
          Card(
            color: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)
            ),
            elevation: 5,
            child: Column(
              children: [
                 Text(
                    isWeekly ? 'Bookings made (Weekly)' : 'Bookings made (Monthly)',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10,),
                AspectRatio(
                  aspectRatio: 1.6,
                  child: Container(
                    child: BarChart(
                      BarChartData(
                          barTouchData: barTouchData,
                          titlesData: isWeekly ? titlesData : titlesData2,
                          borderData: borderData,
                          barGroups: isWeekly ? barGroups : barGroups2,
                          gridData: const FlGridData(show: false),
                          alignment: BarChartAlignment.spaceAround,
                          maxY: 30
                      ),
                    ),
                  ),
                ),

              ],
            )
          ),
          Expanded(
              child: GridView.count(
            shrinkWrap: true,
            padding: const EdgeInsets.only(
                left: 20, right: 20, top: 10
            ),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 2,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[100],
                child: Column(
                  children: [
                    const Text(
                        'Most Bookings Made',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,),

                    Text(isWeekly ? '$mostday' : '$mostmonth',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold
                    ),)
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[200],
                child: Column(
                  children: [
                    const Text(
                      'Total Bookings Made',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,),

                    Text(isWeekly ? '$weeklyTotal' : '$monthlyTotal',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                      ),)
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[300],
                child: Column(
                  children: [
                    const Text(
                      'Total Laundry Load',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,),

                    Text(isWeekly ? '$weeklyLoad' : '$monthlyLoad',
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                      ),)
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: Colors.teal[400],
                child: Column(
                  children: [
                    const Text(
                      'Average Bookings',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10,),

                    Text(isWeekly ? (weeklyTotal / 7).toStringAsFixed(2) : (monthlyTotal / 7).toStringAsFixed(2),
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold
                      ),)
                  ],
                ),
              ),
            ],
          )
          )
        ],
      ),

      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        height: 50,
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const PDFScreen()));
          },
          child: const Text(
            'Download as PDF',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}

class PDFScreen extends StatefulWidget {
  const PDFScreen({super.key});

  @override
  State<PDFScreen> createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> {
  @override
  void initState() {
    super.initState();
  }

  Future<Uint8List> _createPdf(
      PdfPageFormat format,
      ) async {
    final pdf = pdfWid.Document(
      version: PdfVersion.pdf_1_4,
      compress: true,
    );

    final tryimage = pdfWid.MemoryImage(
        (await rootBundle.load('assets/pepe.png')).buffer.asUint8List()
    );



    pdf.addPage(
      pdfWid.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {

          return pdfWid.SizedBox(
            width: double.infinity,
            child: pdfWid.FittedBox(
                child: pdfWid.Column(
                    mainAxisAlignment: pdfWid.MainAxisAlignment.center,
                    children: [
                      pdfWid.Container(
                          height: 300,
                          width: 600,
                          decoration: const pdfWid.BoxDecoration(
                              color: PdfColors.blue
                          ),
                          child: pdfWid.Column(
                              mainAxisAlignment: pdfWid.MainAxisAlignment.center,
                              children: [
                                pdfWid.Image(
                                    tryimage,
                                    width: 100,
                                    height: 100
                                ),
                                pdfWid.Text(
                                    "LaundryMate",
                                    style: pdfWid.TextStyle(
                                      fontSize: 35, fontWeight: pdfWid.FontWeight.bold,
                                    ),
                                    textAlign: pdfWid.TextAlign.center
                                ),
                                pdfWid.Text(
                                    "San Mateo, Isabela",
                                    style: pdfWid.TextStyle(
                                      fontSize: 35, fontWeight: pdfWid.FontWeight.bold,
                                    ),
                                    textAlign: pdfWid.TextAlign.center
                                ),
                                pdfWid.Text(
                                    "09123475890",
                                    style: pdfWid.TextStyle(
                                      fontSize: 35, fontWeight: pdfWid.FontWeight.bold,
                                    ),
                                    textAlign: pdfWid.TextAlign.center
                                ),
                              ]
                          )
                      ),

                      pdfWid.Container(
                        width: 600,
                        child: pdfWid.Divider(
                          thickness: 5,
                          color: PdfColors.black,
                        ),
                      ),
                      pdfWid.Container(
                        width: 300,
                        child: pdfWid.Text(
                            'Shop Report',
                            style: pdfWid.TextStyle(
                              fontSize: 35,
                              fontWeight: pdfWid.FontWeight.bold,
                            ),
                            textAlign: pdfWid.TextAlign.center,
                            maxLines: 5),
                      ),
                      pdfWid.Container(
                        width: 600,
                        child: pdfWid.Divider(
                          thickness: 5,
                          color: PdfColors.black,
                        ),
                      ),

                      pdfWid.SizedBox(height: 20),
                      pdfWid.Table(
                          border: pdfWid.TableBorder.all(color: const PdfColor.fromInt(0xFF4A5667)),
                          defaultVerticalAlignment: pdfWid.TableCellVerticalAlignment.middle,
                          children: [
                            pdfWid.TableRow(
                                decoration: pdfWid.BoxDecoration(
                                    color: PdfColor.fromInt(0xFFBBDEDD)
                                ),
                                children: [
                                  pdfWid.Container(
                                      decoration: pdfWid.BoxDecoration(
                                          border: pdfWid.Border.all(
                                              color: PdfColors.black,
                                              width: 2
                                          )
                                      ),
                                      padding: pdfWid.EdgeInsets.all(5),
                                      child: pdfWid.Text(
                                          'Date',
                                          style: pdfWid.TextStyle(
                                              fontSize: 28,
                                              fontWeight: pdfWid.FontWeight.bold
                                          ),
                                      )
                                  ),

                                  pdfWid.Container(
                                      decoration: pdfWid.BoxDecoration(
                                          border: pdfWid.Border.all(
                                              color: PdfColors.black,
                                              width: 2
                                          )
                                      ),
                                      padding: pdfWid.EdgeInsets.all(5),
                                      child: pdfWid.Text(
                                          'Bookings Made',
                                          style: pdfWid.TextStyle(
                                              fontSize: 28,
                                              fontWeight: pdfWid.FontWeight.bold
                                          )
                                      )
                                  ),

                                  pdfWid.Container(
                                      decoration: pdfWid.BoxDecoration(
                                          border: pdfWid.Border.all(
                                              color: PdfColors.black,
                                              width: 2
                                          )
                                      ),
                                      padding: pdfWid.EdgeInsets.all(5),
                                      child: pdfWid.Text(
                                          'Sales',
                                          style: pdfWid.TextStyle(
                                              fontSize: 28,
                                              fontWeight: pdfWid.FontWeight.bold
                                          )
                                      )
                                  ),

                                  pdfWid.Container(
                                      decoration: pdfWid.BoxDecoration(
                                          border: pdfWid.Border.all(
                                              color: PdfColors.black,
                                              width: 2
                                          )
                                      ),
                                      padding: pdfWid.EdgeInsets.all(5),
                                      child: pdfWid.Text(
                                          'Detergent Qty Used',
                                          style: pdfWid.TextStyle(
                                              fontSize: 28,
                                              fontWeight: pdfWid.FontWeight.bold
                                          )
                                      )
                                  ),

                                ]
                            ),


                            pdfWid.TableRow(
                                decoration: pdfWid.BoxDecoration(
                                    color: PdfColor.fromInt(0xFFBBDEDD)
                                ),
                                children: [
                                  pdfWid.Container(
                                      decoration: pdfWid.BoxDecoration(
                                          border: pdfWid.Border.all(
                                              color: PdfColors.black,
                                              width: 2
                                          )
                                      ),
                                      padding: pdfWid.EdgeInsets.all(5),
                                      child: pdfWid.Text(
                                          '07/30/2024',
                                          style: pdfWid.TextStyle(
                                              fontSize: 28
                                          )
                                      )
                                  ),

                                  pdfWid.Container(
                                      decoration: pdfWid.BoxDecoration(
                                          border: pdfWid.Border.all(
                                              color: PdfColors.black,
                                              width: 2
                                          )
                                      ),
                                      padding: pdfWid.EdgeInsets.all(5),
                                      child: pdfWid.Text(
                                          '10',
                                          style: pdfWid.TextStyle(
                                              fontSize: 28
                                          )
                                      )
                                  ),

                                  pdfWid.Container(
                                      decoration: pdfWid.BoxDecoration(
                                          border: pdfWid.Border.all(
                                              color: PdfColors.black,
                                              width: 2
                                          )
                                      ),
                                      padding: pdfWid.EdgeInsets.all(5),
                                      child: pdfWid.Text(
                                          'P1,200.00',
                                          style: pdfWid.TextStyle(
                                              fontSize: 28
                                          )
                                      )
                                  ),

                                  pdfWid.Container(
                                      decoration: pdfWid.BoxDecoration(
                                          border: pdfWid.Border.all(
                                              color: PdfColors.black,
                                              width: 2
                                          )
                                      ),
                                      padding: pdfWid.EdgeInsets.all(5),
                                      child: pdfWid.Text(
                                          '2',
                                          style: pdfWid.TextStyle(
                                              fontSize: 28
                                          )
                                      )
                                  )
                                ]
                            )
                          ]
                      )

                    ]
                )
            ),
          );
        },
      ),
    );

    return pdf.save();
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentTime = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF'),
      ),
      body: PdfPreview(
    build: (format) => _createPdf(format),
        allowPrinting: false,
        allowSharing: false,
        canChangePageFormat: false,
        canChangeOrientation: false,
        canDebug: false,
        actionBarTheme: const PdfActionBarTheme(
          backgroundColor: Color(0xFF050C9C)
        ),
        actions: [
          Container(
            width: double.infinity,
            child: TextButton(
              style: TextButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero
                ),
              ),
              child: const Text(
                'Download Report',
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              onPressed: () async {
                final pdfBytes = await _createPdf(PdfPageFormat.a4);
                final output = await getTemporaryDirectory();
                final file = File("${output.path}/Shop-Report-$currentTime.pdf");
                await file.writeAsBytes(pdfBytes);

                print(output);
                await OpenFile.open(file.path);
              },
            ),
          ),
        ],
      ),
    );
  }
}



