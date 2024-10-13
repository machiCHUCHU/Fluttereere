
import 'dart:async';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newBookingPage.dart';
import 'package:capstone/brandnew/newBookingService.dart';
import 'package:capstone/brandnew/newChartPage.dart';
import 'package:capstone/brandnew/newCustomerPage.dart';
import 'package:capstone/brandnew/newInventoryPage.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/brandnew/newReportPage.dart';
import 'package:capstone/brandnew/newReviewPage.dart';
import 'package:capstone/brandnew/newSettings.dart';
import 'package:capstone/brandnew/newUpcomingTaskScreen.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/loginStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
    homeDisplay();
  }



  Future<void> homeDisplay() async{
    ApiResponse response = await getHome(token.toString());

    if(response.error == null){
      setState(() {
        home = response.data as Map;
        hasData = home.isNotEmpty;
      });
    }else{
    }
  }

  void startTimer(){
    _timer = Timer.periodic(const Duration(seconds: 5), (timer){
      homeDisplay();
    });
  }

  Map profile = {};
  Future<void> appBarDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getAppbar('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        profile = response.data as Map;
      });
    }else{

    }
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
    appBarDisplay();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> logoutState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await logout(token.toString());

    if (response.error == null) {
      await prefs.clear();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const NewLoginScreen()),
              (route) => false,
        );
      }
    } else {
    }
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
    print(token);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Mate'),
        titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        actions: [
          Text('${profile['shopname'] ?? '...'}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),overflow: TextOverflow.ellipsis,),
          const SizedBox(width: 5,),
          InkWell(
            onTap: (){
              logoutDialog(context, logoutState);
            },
            child: Stack(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 22,
                ),
                ProfilePicture(
                  name: '${profile['shopname']}',
                  radius: 22,
                  fontsize: 14,
                  img: profile['pic'] == '' || profile['pic'] == 'null' ? null : '$picaddress/${profile['pic']}'
                )
              ],
            ),
          ),
          const SizedBox(width: 5,),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.white
                ),
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                            ),
                            padding: const EdgeInsets.all(8),
                            fixedSize: const Size(100, 100)
                          ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewBookingScreen()));
                            },
                            child: Column(
                              children: [
                                const Icon(Icons.pending,color: Colors.white,size: 32,),
                                const Text('Pending',style: TextStyle(color: Colors.white),),
                                const SizedBox(height: 5,),
                                Text(hasData ? '${home['bookings']}' : '0',style: const TextStyle(color: Colors.white,fontSize: 18))
                              ],
                            )
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.all(8),
                                fixedSize: const Size(100, 100)
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewWashScreen()));
                            },
                            child: Column(
                              children: [
                                const Icon(Icons.water,color: Colors.white,size: 32,),
                                const Text('Washing',style: TextStyle(color: Colors.white),),
                                const SizedBox(height: 5,),
                                Text(hasData ? '${home['wash']}' : '0',style: const TextStyle(color: Colors.white,fontSize: 18))
                              ],
                            )
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.yellow.shade600,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.all(8),
                                fixedSize: const Size(100, 100)
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewDryScreen()));
                            },
                            child: Column(
                              children: [
                                const Icon(CupertinoIcons.wind,color: Colors.white,size: 32,),
                                const Text('Drying',style: TextStyle(color: Colors.white),),
                                const SizedBox(height: 5,),
                                Text( hasData ? '${home['dry']}' : '0',style: const TextStyle(color: Colors.white,fontSize: 18))
                              ],
                            )
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreenAccent.shade700,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.all(8),
                                fixedSize: const Size(100, 100)
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewFoldScreen()));
                            },
                            child: Column(
                              children: [
                                const Icon(Icons.dry_cleaning,color: Colors.white,size: 32,),
                                const Text('Folding',style: TextStyle(color: Colors.white),),
                                const SizedBox(height: 5,),
                                Text( hasData ? '${home['fold']}' : '0',style: const TextStyle(color: Colors.white,fontSize: 18))
                              ],
                            )
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.all(8),
                                fixedSize: const Size(100, 100)
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewPickupScreen()));
                            },
                            child: Column(
                              children: [
                                const Icon(CupertinoIcons.cube,color: Colors.white,size: 32,),
                                const Text('Pick-up',style: TextStyle(color: Colors.white),),
                                const SizedBox(height: 5,),
                                Text( hasData ? '${home['pick']}' : '0',style: const TextStyle(color: Colors.white,fontSize: 18))
                              ],
                            )
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.all(8),
                                fixedSize: const Size(100, 100)
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewCompleteScreen()));
                            },
                            child: Column(
                              children: [
                                const Icon(CupertinoIcons.check_mark_circled_solid,color: Colors.white,size: 32,),
                                const Text('Completed',style: TextStyle(color: Colors.white),),
                                const SizedBox(height: 5,),
                                Text(hasData ? '${home['complete']}' : '0',style: const TextStyle(color: Colors.white,fontSize: 18))
                              ],
                            )
                        ),

                      ],
                    ),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlueAccent.shade400,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.all(8),
                                fixedSize: Size(MediaQuery.of(context).size.width * .87, 70)
                            ),
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const NewUpcomingTaskScreen()));
                            },
                            child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.calendar_month,size: 32,color: Colors.white,),
                                  Text('Upcoming Laundry',style: TextStyle(color: Colors.white))
                                ],
                              ),
                        ),
                      ],
                    ),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .42,
                          decoration: BoxDecoration(
                            color: Colors.amberAccent,
                            borderRadius: BorderRadius.circular(5)
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              const Icon(CupertinoIcons.money_rubl_circle_fill,color: Colors.white,size: 28,),
                              const Text('Today\'s Revenue',style: TextStyle(color: Colors.white)),
                              Text(hasData ? '₱${home['revenue']}' : '0',style: const TextStyle(color: Colors.white,fontSize: 18))
                            ],
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * .42,
                          decoration: BoxDecoration(
                              color: Colors.teal,
                              borderRadius: BorderRadius.circular(5)
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              const Icon(Icons.local_laundry_service,color: Colors.white,size: 28,),
                              const Text('Remaining Load',style: TextStyle(color: Colors.white)),
                              Text(hasData ? '${home['remload']}' : '0',style: const TextStyle(color: Colors.white,fontSize: 18))
                            ],
                          ),
                        )
                      ],
                    ),

                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        fixedSize: const Size(105, 105),
                      ),
                      onPressed: ()async{
                        final response = await Navigator.push(context, MaterialPageRoute(builder: (context) => const NewSettingsScreen()));

                        if(response == true){
                          appBarDisplay();
                        }
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.black87,
                            child: Icon(Icons.settings,color:Colors.white,size: 32,),
                          ),
                          Text('Settings',style: TextStyle(color: Colors.black,fontSize: 14),)
                        ],
                      )
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        fixedSize: const Size(105, 105),
                      ),
                      onPressed: (){
                        _bottomModalCustomers();
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.lightGreen,
                            child: Icon(Icons.book,color:Colors.white,size: 32,),
                          ),
                          Text('Book Service',style: TextStyle(color: Colors.black,fontSize: 14),)
                        ],
                      )
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        fixedSize: const Size(105, 105),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewInventoryScreen()));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.brown,
                            child: Icon(Icons.inventory,color:Colors.white,size: 32,),
                          ),
                          Text('Inventory',style: TextStyle(color: Colors.black,fontSize: 14),)
                        ],
                      )
                  )
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        fixedSize: const Size(105, 105),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewCustomerScreen()));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.pinkAccent,
                            child: Icon(Icons.people_alt,color:Colors.white,size: 32,),
                          ),
                          Text('Customers',style: TextStyle(color: Colors.black,fontSize: 14),)
                        ],
                      )
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        fixedSize: const Size(105, 105),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewReviewPage()));
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.yellow.shade400,
                            child: const Icon(Icons.feed,color:Colors.white,size: 32,),
                          ),
                          const Text('Reviews',style: TextStyle(color: Colors.black,fontSize: 14),)
                        ],
                      )
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        fixedSize: const Size(105, 105),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NewReportScreen()));
                      },
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.grey,
                            child: Icon(Icons.file_copy,color:Colors.white,size: 32,),
                          ),
                          Text('Report',style: TextStyle(color: Colors.black,fontSize: 14),)
                        ],
                      )
                  )
                ],
              )
            ],
          ),
        )
    );

  }
}

class SalesData {
  SalesData(this.year, this.sales);
  final String year;
  final double sales;
}

