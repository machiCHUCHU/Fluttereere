
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/newBookingPage.dart';
import 'package:capstone/brandnew/newBookingService.dart';
import 'package:capstone/brandnew/newCustomerPage.dart';
import 'package:capstone/brandnew/newInventoryPage.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/brandnew/newReportPage.dart';
import 'package:capstone/brandnew/newReviewPage.dart';
import 'package:capstone/brandnew/newSettings.dart';
import 'package:capstone/brandnew/setWidget/appbar.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/drawer/ownerDrawer.dart';
import 'package:capstone/home/homePage.dart';
import 'package:capstone/model/chart.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/loginStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfWid;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:capstone/newchart/weeklyChart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class NewHomeScreen extends StatefulWidget {
  const NewHomeScreen({super.key});

  @override
  State<NewHomeScreen> createState() => _NewHomeScreenState();
}

class _NewHomeScreenState extends State<NewHomeScreen> {

  String? token;
  int? userid;
  int? shopid;
  String _selectedRange = 'Weekly';
  Map home = {};
  Map appbar = {};
  bool hasData = false;
  Timer? _timer;
  List<dynamic> service = [];
  Map serve = {};
  Map chart = {};

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
    });
    getSalesWeekly();
    homeDisplay();
  }

  Future<void> getSalesWeekly() async{
    ApiResponse response = await getWeeklySalesChart(token.toString());

    if(response.error == null){
      setState(() {
        chart = response.data as Map;
        isLoading = false;
      });
    }else{
      print(response.error);
      isLoading = false;
    }
  }

  Future<void> homeDisplay() async{
    ApiResponse response = await getHome(token.toString());

    if(response.error == null){
      setState(() {
        home = response.data as Map;
        hasData = home.isNotEmpty;
      });
    }else{
      print(response.error);
    }
  }

  void startTimer(){
    _timer = Timer.periodic(Duration(seconds: 10), (timer){
      print('jel');
      getSalesWeekly();
      homeDisplay();
    });
  }

  void _bottomModalCustomers(){
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
          )
      ),
      builder: (context) => SizedBox(
        height: 300,
        child: Column(
          children: [
            const SizedBox(height: 20,),
            const Text(
              'Select Customer',
              style: LoginStyle.modalTitle,
            ),
            const SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForRegisteredScreen()));
                  },
                  child: Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ColorStyle.tertiary,
                            width: 2
                        )
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_pin_rounded,
                          size: 80,
                          color: ColorStyle.tertiary,
                        ),
                        Text(
                          'Registered',
                          style: LoginStyle.modalSubTitle,
                        )
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ForWalkinScreen()));
                  },
                  child: Container(
                    width: 125,
                    height: 125,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: ColorStyle.tertiary,
                            width: 2
                        )
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_walk,
                          size: 80,
                          color: ColorStyle.tertiary,
                        ),
                        Text(
                          'Walk-in',
                          style: LoginStyle.modalSubTitle,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState(){
    super.initState();
    getUser();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool showAvg = false;
  bool isWeekly = true;
  bool isLoading = true;

  String formatNumber(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ForAppBar(
        title: Text('Laundry Mate'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      Expanded(
                          child:  GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              Column(
                                children: [
                                  SizedBox(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: ColorStyle.tertiary,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)
                                            ),
                                            elevation: 5
                                        ),
                                        onPressed: (){
                                          Navigator.push(context, MaterialPageRoute(builder: (context) => const NewBookingScreen()));
                                        },
                                        child: Text(
                                          hasData ? '${home['bookings']}' : '0',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        )
                                    ),
                                  ),
                                  const Text('Booked')
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorStyle.tertiary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          elevation: 5
                                      ),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewWashScreen()));
                                      },
                                      child: Text(
                                        hasData ? '${home['wash']}' : '0',
                                        style: TextStyle(color: Colors.white),
                                      )
                                  ),
                                  const Text('Wash')
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorStyle.tertiary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          elevation: 5
                                      ),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewDryScreen()));
                                      },
                                      child: Text(
                                        hasData ? '${home['dry']}' : '0',
                                        style: TextStyle(color: Colors.white),
                                      )
                                  ),
                                  const Text('Dry')
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorStyle.tertiary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          elevation: 5
                                      ),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewFoldScreen()));
                                      },
                                      child: Text(
                                        hasData ? '${home['fold']}' : '0',
                                        style: TextStyle(color: Colors.white),
                                      )
                                  ),
                                  const Text('Fold')
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorStyle.tertiary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          elevation: 5
                                      ),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewPickupScreen()));
                                      },
                                      child: Text(
                                        hasData ? '${home['pick']}' : '0',
                                        style: TextStyle(color: Colors.white),
                                      )
                                  ),
                                  const Text('Pick-up')
                                ],
                              ),
                              Column(
                                children: [
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorStyle.tertiary,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5)
                                          ),
                                          elevation: 5
                                      ),
                                      onPressed: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewCompleteScreen()));
                                      },
                                      child: Text(
                                        hasData ? '${home['complete']}' : '0',
                                        style: TextStyle(color: Colors.white),
                                      )
                                  ),
                                  const Text('Complete')
                                ],
                              ),
                            ],
                          )
                      ),
                      Expanded(
                          child: Column(
                            children: [
                              Text(
                                hasData ? '₱${formatNumber(home['revenue'])}' : '0',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text('Revenue'),

                              Container(
                                  width: double.infinity,
                                  height: 150,
                                  child: SfCartesianChart(
                                      primaryXAxis: const CategoryAxis(
                                        labelPlacement: LabelPlacement.onTicks,
                                        labelRotation: 90,
                                        interval: 1,
                                        desiredIntervals: 7,
                                        majorGridLines: MajorGridLines(width: 0),
                                        axisLine: AxisLine(width: 1),
                                      ),
                                      primaryYAxis: const NumericAxis(
                                        majorGridLines: MajorGridLines(width: 0),
                                        axisLine: AxisLine(width: 1),
                                      ),
                                      plotAreaBorderWidth: 0,
                                      plotAreaBorderColor: Colors.transparent,
                                      borderWidth: 0,
                                      borderColor: Colors.transparent,
                                      tooltipBehavior: TooltipBehavior(enable: true),
                                      series: <LineSeries<SalesData, String>>[
                                        LineSeries<SalesData, String>(
                                          width: 2,
                                          dataSource:  <SalesData>[
                                            SalesData('Sun', isLoading ? 0 : chart['sunday'].toDouble()),
                                            SalesData('Mon', isLoading ? 0 : chart['monday'].toDouble()),
                                            SalesData('Tue', isLoading ? 0 : chart['tuesday'].toDouble()),
                                            SalesData('Wed', isLoading ? 0 : chart['wednesday'].toDouble()),
                                            SalesData('Thu', isLoading ? 0 : chart['thursday'].toDouble()),
                                            SalesData('Fri', isLoading ? 0 : chart['friday'].toDouble()),
                                            SalesData('Sat', isLoading ? 0 : chart['saturday'].toDouble())
                                          ],
                                          xValueMapper: (SalesData sales, _) => sales.year,
                                          yValueMapper: (SalesData sales, _) => sales.sales,
                                          enableTooltip: true,
                                          dataLabelSettings: const DataLabelSettings(
                                            isVisible: true,
                                            textStyle: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                            showZeroValue: false
                                          ),
                                          markerSettings: const MarkerSettings(
                                            isVisible: true,
                                            shape: DataMarkerType.circle,
                                            color: ColorStyle.tertiary,
                                            borderWidth: 2,
                                            borderColor: Colors.white,
                                          ),
                                          animationDuration: 0,
                                        )
                                      ]
                                  )
                              ),
                            ],
                          )
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        SizedBox.square(
                          dimension: 90,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  elevation: 2,
                                  backgroundColor: ColorStyle.tertiary
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewSettingsScreen()));
                              },
                              child: const Icon(
                                Icons.settings,
                                size: 42,
                                color: Colors.white,
                              )
                          ),
                        ),
                        const Text(
                          'Settings',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox.square(
                          dimension: 90,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  elevation: 2,
                                  backgroundColor: ColorStyle.tertiary
                              ),
                              onPressed: (){
                                _bottomModalCustomers();
                              },
                              child: const Icon(
                                Icons.local_laundry_service,
                                size: 42,
                                color: Colors.white,
                              )
                          ),
                        ),
                        const Text(
                          'Book Service',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox.square(
                          dimension: 90,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  elevation: 2,
                                  backgroundColor: ColorStyle.tertiary
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewInventoryScreen()));
                              },
                              child: const Icon(
                                Icons.inventory,
                                size: 42,
                                color: Colors.white,
                              )
                          ),
                        ),
                        const Text(
                          'Inventory',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ]),
              const SizedBox(height: 20,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        SizedBox.square(
                          dimension: 90,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  elevation: 2,
                                  backgroundColor: ColorStyle.tertiary
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewCustomerScreen()));
                              },
                              child: const Icon(
                                Icons.person,
                                size: 42,
                                color: Colors.white,
                              )
                          ),
                        ),
                        const Text(
                          'Customers',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox.square(
                          dimension: 90,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  elevation: 2,
                                  backgroundColor: ColorStyle.tertiary
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewReviewPage()));
                              },
                              child: const Icon(
                                Icons.feed,
                                size: 42,
                                color: Colors.white,
                              )
                          ),
                        ),
                        const Text(
                          'Reviews',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox.square(
                          dimension: 90,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  elevation: 2,
                                  backgroundColor: ColorStyle.tertiary
                              ),
                              onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewReportScreen()));
                              },
                              child: const Icon(
                                Icons.file_copy,
                                size: 42,
                                color: Colors.white,
                              )
                          ),
                        ),
                        const Text(
                          'Report',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    ),
                  ])
            ],
          ),
        )
      ),
    );

  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}