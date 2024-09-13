import 'dart:convert';
import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newLoginPage.dart';
import 'package:capstone/brandnew/setWidget/appbar.dart';
import 'package:capstone/drawer/ownerDrawer.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/loginStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NewBookingScreen extends StatefulWidget {
  const NewBookingScreen({super.key});

  @override
  State<NewBookingScreen> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {

  String? token;
  int? userid;
  int? shopid;
  String _selectedRange = 'Weekly';
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
    bookingsDisplay();
    walkinDisplay();
  }

  Future<void> bookingsDisplay() async{
    ApiResponse response = await getBookings(token.toString());

    if(response.error == null){
      setState(() {
        bookings = response.data as List<dynamic>;
        hasBook = bookings.isNotEmpty;
        isLoading = false;
      });
    }else{
      print(response.error);
    }
  }

  Future<void> walkinDisplay() async{
    ApiResponse response = await getWalkin(token.toString());

    if(response.error == null){
      setState(() {
        walkins = response.data as List<dynamic>;
        hasWalkin = walkins.isNotEmpty;
      });
    }else{
      print(response.error);
    }
  }
  
  Future<void> walkinUpdate(String stat, String id) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updateWalkin(
        stat, '${prefs.getString('token')}', id
    );
    
    
    if(response.error == null){
      if(stat == '1'){
        await successDialog(context, '${response.data}');
      }else{
        await errorDialog(context, '${response.data}');
      }
      walkinDisplay();
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> bookingUpdate(String stat, String id) async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updateBooking(
        stat, '${prefs.getString('token')}', id
    );


    if(response.error == null){
      if(stat == '1'){
        await successDialog(context, '${response.data}');
      }else{
        await errorDialog(context, '${response.data}');
      }
      bookingsDisplay();
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> paymentUpdate(String type, String id) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updatePayment(
        type, id, '${prefs.getString('token')}'
    );

    Navigator.pop(context);

    if(response.error == null){
      setState(() {
        getUser();
      });
      await successDialog(context, '${response.data}');
      Navigator.pop(context);
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> completeUpdate(String type, String id, String paid) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updateComplete(
        type, id, paid, '${prefs.getString('token')}'
    );

    Navigator.pop(context);

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context);
      setState(() {
        getUser();
      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalBookings(String name,String contact, String load, String total, String date,
      String payment, String service, String bookingId, bool isCancelled,bool isPickup, bool isPending, bool isComplete){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      'Booking ID: $bookingId',
                      style: LoginStyle.modalTitle,
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child:  SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Name',)
                                      ],),
                                      description: Text(name, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call,color: ColorStyle.tertiary),
                                        Text('Contact Number',)
                                      ],),
                                      description: Text(contact, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load',)
                                      ],),
                                      description: Text('$load kg/s', style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service',)
                                      ],),
                                      description: Text(service, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Payment Status',)
                                      ],),
                                      description: Text(payment, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            )
                        )
                    ),
                    isPending
                        ? const SizedBox.shrink()
                        : isCancelled ? const SizedBox.shrink()
                        : isPaid
                        ? isComplete
                        ? const SizedBox.shrink() : Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width, 20)
                            ),
                            onPressed: (){
                              completeUpdate('booking', bookingId, 'paid');
                            },
                            child: const Text('Complete', style: TextStyle(color:Colors.white),)
                        )
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width *.40, 20)
                            ),
                            onPressed: (){
                              paymentUpdate('booking', bookingId);
                            },
                            child: const Text('Paid', style: TextStyle(color:Colors.white),)
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width *.40, 20)
                            ),
                            onPressed: (){
                              completeUpdate('booking', bookingId, 'notpaid');
                            },
                            child: const Text('Complete', style: TextStyle(color:Colors.white),)
                        ),
                      ],
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  void _bottomModalWalkins(String contact, String load, String total, String date,
      String payment, String service, String walkinId, bool isCancelled, bool isPickup,
      bool isPending, bool isComplete){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      'Walkin ID: $walkinId',
                      style: LoginStyle.modalTitle,
                    ),
                    Divider(),

                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call, color: ColorStyle.tertiary,),
                                        Text('Contact')
                                      ],),
                                      description: Text(contact,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load')
                                      ],),
                                      description: Text('$load kg/s',style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service')
                                      ],),
                                      description: Text(service,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.payments,color: ColorStyle.tertiary),
                                        Text('Payment Status')
                                      ],),
                                      description: Text(payment,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),

                                ],
                              ),
                            )
                        )
                    ),
                    isPending ? const SizedBox.shrink()
                        : isCancelled ? const SizedBox.shrink()
                        : !isPickup ? isPaid ? const SizedBox.shrink()
                        : Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width, 20)
                            ),
                            onPressed: (){
                              paymentUpdate('walkin', walkinId);
                            },
                            child: const Text('Paid', style: TextStyle(color:Colors.white),)
                        )
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width *.40, 20)
                            ),
                            onPressed: (){
                              paymentUpdate('walkin', walkinId);
                            },
                            child: const Text('Paid', style: TextStyle(color:Colors.white),)
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width *.40, 20)
                            ),
                            onPressed: (){
                              completeUpdate('walkin', walkinId, 'notpaid');
                            },
                            child: const Text('Complete', style: TextStyle(color:Colors.white),)
                        ),
                      ],
                    )


                  ],
                ),
              )
          );
        }
    );
  }


  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
        return DefaultTabController(
            length: 2,
            child: Scaffold(
                appBar: ForAppBar(
                  title: const Text('Booked'),
                  tabBar: const TabBar(
                    indicatorColor: ColorStyle.primary,
                    labelColor: ColorStyle.tertiary,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'Bookings'),
                      Tab(text: 'Walk-in'),
                    ],
                  ),
                  tabBarColor: Colors.grey.shade50,
                ),
                body: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.black,
                    size: 50,
                  ),
                )
            )
        );
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: ForAppBar(
          title: const Text('Booked'),
          tabBar: const TabBar(
            indicatorColor: ColorStyle.primary,
            labelColor: ColorStyle.tertiary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Bookings'),
              Tab(text: 'Walk-in'),
            ],
          ),
          tabBarColor: Colors.grey.shade50,
        ),
        body: TabBarView(
          children: [
            hasBook
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        Map book = bookings[index] as Map;
                        bool isStatus = book['Status'] == '0' && book['deleted_at'] == null;
                        bool isCancelled = book['deleted_at'] != null && book['Status'] == '0';
                        bool isPickup = book['Status'] == '4';
                        bool isPending = book['Status'] == '0';
                        bool isComplete = book['Status'] == '5';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(book['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalBookings(
                                  '${book['CustomerName']}',
                                  '${book['CustomerContactNumber']}', '${book['LoadWeight']}', '${book['CustomerLoad']}',
                                  '${book['Schedule']}', '${book['PaymentStatus']}', '${book['ServiceName']}',
                                  '${book['BookingID']}', isCancelled,isPickup, isPending,isComplete);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${book['CustomerName']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${book['CustomerLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: isStatus ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: (){
                                                bookingUpdate('1', '${book['BookingID']}');
                                              },
                                              icon: Icon(Icons.check_circle_sharp, ),
                                              color: Colors.green,
                                              iconSize: 32,
                                            ),
                                            IconButton(
                                              onPressed: (){
                                                bookingUpdate('2', '${book['BookingID']}');
                                              },
                                              icon: Icon(Icons.cancel_rounded, ),
                                              color: Colors.red,
                                              iconSize: 32,
                                            )
                                          ],
                                        ) : Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Bookings Yet'),),
            hasWalkin
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Contact ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: walkins.length,
                      itemBuilder: (context, index) {
                        Map walk = walkins[index] as Map;
                        bool isStatus = walk['Status'] == '0' && walk['deleted_at'] == null;
                        bool isCancelled = walk['deleted_at'] != null && walk['Status'] == '0';
                        bool isPickup = walk['Status'] == '4';
                        bool isPending = walk['Status'] == '0';
                        bool isComplete = walk['Status'] == '5';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(walk['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalWalkins(
                                  '${walk['ContactNumber']}', '${walk['WalkinLoad']}', '${walk['Total']}',
                                  '${walk['DateIssued']}', '${walk['PaymentStatus']}', '${walk['ServiceName']}',
                                  '${walk['WalkinID']}',isCancelled,isPickup, isPending,isComplete);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${walk['ContactNumber']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${walk['WalkinLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: isStatus ? Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: (){
                                                walkinUpdate('1', '${walk['WalkinID']}');
                                              },
                                              icon: Icon(Icons.check_circle_sharp, ),
                                              color: Colors.green,
                                              iconSize: 32,
                                            ),
                                            IconButton(
                                              onPressed: (){
                                                walkinUpdate('2', '${walk['WalkinID']}');
                                              },
                                              icon: Icon(Icons.cancel_rounded, ),
                                              color: Colors.red,
                                              iconSize: 32,
                                            )
                                          ],
                                        ) : Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Walkins Yet'),)
          ],
        ),
      ),
    );

  }
}

class NewWashScreen extends StatefulWidget {
  const NewWashScreen({super.key});

  @override
  State<NewWashScreen> createState() => _NewWashScreenState();
}

class _NewWashScreenState extends State<NewWashScreen> {

  String? token;
  int? userid;
  int? shopid;
  String _selectedRange = 'Weekly';
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
    washDisplay();
  }

  Future<void> washDisplay() async{
    ApiResponse response = await getWashing(token.toString());

    if(response.error == null){
      setState(() {
        bookings = response.data as List<dynamic>;
        walkins = response.data1 as List<dynamic>;
        hasBook = bookings.isNotEmpty;
        hasWalkin = walkins.isNotEmpty;
        isLoading = false;
      });
    }else{
      print(response.error);
    }
  }

  Future<void> paymentUpdate(String type, String id) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updatePayment(
        type, id, '${prefs.getString('token')}'
    );

    Navigator.pop(context);

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context);
      setState(() {
        getUser();
      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalBookings(String name,String contact, String load, String total, String date,
      String payment, String service, String bookingId, bool isCancelled){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      'Booking ID: $bookingId',
                      style: LoginStyle.modalTitle,
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child:  SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Name',)
                                      ],),
                                      description: Text(name, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call,color: ColorStyle.tertiary),
                                        Text('Contact Number',)
                                      ],),
                                      description: Text(contact, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load',)
                                      ],),
                                      description: Text('$load kg/s', style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service',)
                                      ],),
                                      description: Text(service, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Payment Status',)
                                      ],),
                                      description: Text(payment, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            )
                        )
                    ),
                    isPaid || isCancelled ? SizedBox.shrink() : Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              fixedSize: Size(MediaQuery.of(context).size.width, 20)
                          ),
                          onPressed: (){
                            paymentUpdate('booking', bookingId);
                          },
                          child: const Text('Paid', style: TextStyle(color:Colors.white),)
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  void _bottomModalWalkins(String contact, String load, String total, String date,
      String payment, String service, String walkinId, bool isCancelled){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      'Walkin ID: $walkinId',
                      style: LoginStyle.modalTitle,
                    ),
                    Divider(),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call, color: ColorStyle.tertiary,),
                                        Text('Contact')
                                      ],),
                                      description: Text(contact,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load')
                                      ],),
                                      description: Text('$load kg/s',style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service')
                                      ],),
                                      description: Text(service,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.payments,color: ColorStyle.tertiary),
                                        Text('Payment Status')
                                      ],),
                                      description: Text(payment,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),

                                ],
                              ),
                            )
                        )
                    ),
                    isPaid || isCancelled ? SizedBox.shrink() : Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              fixedSize: Size(MediaQuery.of(context).size.width, 20)
                          ),
                          onPressed: (){
                            paymentUpdate('walkin', walkinId);
                          },
                          child: const Text('Paid', style: TextStyle(color:Colors.white),)
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }


  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: ForAppBar(
                title: const Text('Booked'),
                tabBar: const TabBar(
                  indicatorColor: ColorStyle.primary,
                  labelColor: ColorStyle.tertiary,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Bookings'),
                    Tab(text: 'Walk-in'),
                  ],
                ),
                tabBarColor: Colors.grey.shade50,
              ),
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              )
          )
      );
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: ForAppBar(
          title: const Text('Booked'),
          tabBar: const TabBar(
            indicatorColor: ColorStyle.primary,
            labelColor: ColorStyle.tertiary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Bookings'),
              Tab(text: 'Walk-in'),
            ],
          ),
          tabBarColor: Colors.grey.shade50,
        ),
        body: TabBarView(
          children: [
            hasBook
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        Map book = bookings[index] as Map;
                        bool isStatus = book['Status'] == '0' && book['deleted_at'] == null;
                        bool isCancelled = book['deleted_at'] != null && book['Status'] == '0';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(book['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalBookings(
                                  '${book['Name']}',
                                  '${book['ContactNumber']}', '${book['LoadWeight']}', '${book['CustomerLoad']}',
                                  '${book['Schedule']}', '${book['PaymentStatus']}', '${book['ServiceName']}',
                                  '${book['BookingID']}', isCancelled);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${book['Name']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${book['CustomerLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Washing Process Yet'),),
            hasWalkin
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Contact ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: walkins.length,
                      itemBuilder: (context, index) {
                        Map walk = walkins[index] as Map;
                        bool isStatus = walk['Status'] == '0' && walk['deleted_at'] == null;
                        bool isCancelled = walk['deleted_at'] != null && walk['Status'] == '0';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(walk['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalWalkins(
                                  '${walk['ContactNumber']}', '${walk['WalkinLoad']}', '${walk['Total']}',
                                  '${walk['DateIssued']}', '${walk['PaymentStatus']}', '${walk['ServiceName']}',
                                  '${walk['WalkinID']}',isCancelled);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${walk['ContactNumber']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${walk['WalkinLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Washing Process Yet'),)
          ],
        ),
      ),
    );

  }
}

class NewDryScreen extends StatefulWidget {
  const NewDryScreen({super.key});

  @override
  State<NewDryScreen> createState() => _NewDryScreenState();
}

class _NewDryScreenState extends State<NewDryScreen> {

  String? token;
  int? userid;
  int? shopid;
  String _selectedRange = 'Weekly';
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
    dryDisplay();
  }

  Future<void> dryDisplay() async{
    ApiResponse response = await getDrying(token.toString());

    if(response.error == null){
      setState(() {
        bookings = response.data as List<dynamic>;
        walkins = response.data1 as List<dynamic>;
        hasBook = bookings.isNotEmpty;
        hasWalkin = walkins.isNotEmpty;
        isLoading = false;
      });
    }else{
      print(response.error);
    }
  }

  Future<void> paymentUpdate(String type, String id) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updatePayment(
        type, id, '${prefs.getString('token')}'
    );

    Navigator.pop(context);

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context);
      setState(() {
        getUser();
      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalBookings(String name,String contact, String load, String total, String date,
      String payment, String service, String bookingId, bool isCancelled){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      'Booking ID: $bookingId',
                      style: LoginStyle.modalTitle,
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child:  SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Name',)
                                      ],),
                                      description: Text(name, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call,color: ColorStyle.tertiary),
                                        Text('Contact Number',)
                                      ],),
                                      description: Text(contact, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load',)
                                      ],),
                                      description: Text('$load kg/s', style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service',)
                                      ],),
                                      description: Text(service, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Payment Status',)
                                      ],),
                                      description: Text(payment, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            )
                        )
                    ),
                    isPaid || isCancelled ? SizedBox.shrink() : Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              fixedSize: Size(MediaQuery.of(context).size.width, 20)
                          ),
                          onPressed: (){
                            paymentUpdate('booking', bookingId);
                          },
                          child: const Text('Paid', style: TextStyle(color:Colors.white),)
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  void _bottomModalWalkins(String contact, String load, String total, String date,
      String payment, String service, String walkinId, bool isCancelled){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      'Walkin ID: $walkinId',
                      style: LoginStyle.modalTitle,
                    ),
                    Divider(),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call, color: ColorStyle.tertiary,),
                                        Text('Contact')
                                      ],),
                                      description: Text(contact,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load')
                                      ],),
                                      description: Text('$load kg/s',style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service')
                                      ],),
                                      description: Text(service,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.payments,color: ColorStyle.tertiary),
                                        Text('Payment Status')
                                      ],),
                                      description: Text(payment,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),

                                ],
                              ),
                            )
                        )
                    ),
                    isPaid || isCancelled ? SizedBox.shrink() : Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              fixedSize: Size(MediaQuery.of(context).size.width, 20)
                          ),
                          onPressed: (){
                            paymentUpdate('walkin', walkinId);
                          },
                          child: const Text('Paid', style: TextStyle(color:Colors.white),)
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }


  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: ForAppBar(
                title: const Text('Booked'),
                tabBar: const TabBar(
                  indicatorColor: ColorStyle.primary,
                  labelColor: ColorStyle.tertiary,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Bookings'),
                    Tab(text: 'Walk-in'),
                  ],
                ),
                tabBarColor: Colors.grey.shade50,
              ),
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              )
          )
      );
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: ForAppBar(
          title: const Text('Booked'),
          tabBar: const TabBar(
            indicatorColor: ColorStyle.primary,
            labelColor: ColorStyle.tertiary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Bookings'),
              Tab(text: 'Walk-in'),
            ],
          ),
          tabBarColor: Colors.grey.shade50,
        ),
        body: TabBarView(
          children: [
            hasBook
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        Map book = bookings[index] as Map;
                        bool isStatus = book['Status'] == '0' && book['deleted_at'] == null;
                        bool isCancelled = book['deleted_at'] != null && book['Status'] == '0';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(book['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalBookings(
                                  '${book['Name']}',
                                  '${book['ContactNumber']}', '${book['LoadWeight']}', '${book['CustomerLoad']}',
                                  '${book['Schedule']}', '${book['PaymentStatus']}', '${book['ServiceName']}',
                                  '${book['BookingID']}', isCancelled);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${book['Name']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${book['CustomerLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Drying Process Yet'),),
            hasWalkin
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Contact ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: walkins.length,
                      itemBuilder: (context, index) {
                        Map walk = walkins[index] as Map;
                        bool isStatus = walk['Status'] == '0' && walk['deleted_at'] == null;
                        bool isCancelled = walk['deleted_at'] != null && walk['Status'] == '0';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(walk['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalWalkins(
                                  '${walk['ContactNumber']}', '${walk['WalkinLoad']}', '${walk['Total']}',
                                  '${walk['DateIssued']}', '${walk['PaymentStatus']}', '${walk['ServiceName']}',
                                  '${walk['WalkinID']}',isCancelled);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${walk['ContactNumber']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${walk['WalkinLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Drying Process Yet'),)
          ],
        ),
      ),
    );

  }
}

class NewFoldScreen extends StatefulWidget {
  const NewFoldScreen({super.key});

  @override
  State<NewFoldScreen> createState() => _NewFoldScreenState();
}

class _NewFoldScreenState extends State<NewFoldScreen> {

  String? token;
  int? userid;
  int? shopid;
  String _selectedRange = 'Weekly';
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
    dryDisplay();
  }

  Future<void> dryDisplay() async{
    ApiResponse response = await getFolding(token.toString());

    if(response.error == null){
      setState(() {
        bookings = response.data as List<dynamic>;
        walkins = response.data1 as List<dynamic>;
        hasBook = bookings.isNotEmpty;
        hasWalkin = walkins.isNotEmpty;
        isLoading = false;
      });
    }else{
      print(response.error);
    }
  }

  Future<void> paymentUpdate(String type, String id) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updatePayment(
        type, id, '${prefs.getString('token')}'
    );

    Navigator.pop(context);

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context);
      setState(() {
        getUser();
      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalBookings(String name,String contact, String load, String total, String date,
      String payment, String service, String bookingId, bool isCancelled){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      'Booking ID: $bookingId',
                      style: LoginStyle.modalTitle,
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child:  SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Name',)
                                      ],),
                                      description: Text(name, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call,color: ColorStyle.tertiary),
                                        Text('Contact Number',)
                                      ],),
                                      description: Text(contact, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load',)
                                      ],),
                                      description: Text('$load kg/s', style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service',)
                                      ],),
                                      description: Text(service, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Payment Status',)
                                      ],),
                                      description: Text(payment, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            )
                        )
                    ),
                    isPaid || isCancelled ? SizedBox.shrink() : Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              fixedSize: Size(MediaQuery.of(context).size.width, 20)
                          ),
                          onPressed: (){
                            paymentUpdate('booking', bookingId);
                          },
                          child: const Text('Paid', style: TextStyle(color:Colors.white),)
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  void _bottomModalWalkins(String contact, String load, String total, String date,
      String payment, String service, String walkinId, bool isCancelled){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      'Walkin ID: $walkinId',
                      style: LoginStyle.modalTitle,
                    ),
                    Divider(),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call, color: ColorStyle.tertiary,),
                                        Text('Contact')
                                      ],),
                                      description: Text(contact,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load')
                                      ],),
                                      description: Text('$load kg/s',style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service')
                                      ],),
                                      description: Text(service,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.payments,color: ColorStyle.tertiary),
                                        Text('Payment Status')
                                      ],),
                                      description: Text(payment,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),

                                ],
                              ),
                            )
                        )
                    ),
                    isPaid || isCancelled ? SizedBox.shrink() : Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              fixedSize: Size(MediaQuery.of(context).size.width, 20)
                          ),
                          onPressed: (){
                            paymentUpdate('walkin', walkinId);
                          },
                          child: const Text('Paid', style: TextStyle(color:Colors.white),)
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }


  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: ForAppBar(
                title: const Text('Booked'),
                tabBar: const TabBar(
                  indicatorColor: ColorStyle.primary,
                  labelColor: ColorStyle.tertiary,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Bookings'),
                    Tab(text: 'Walk-in'),
                  ],
                ),
                tabBarColor: Colors.grey.shade50,
              ),
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              )
          )
      );
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: ForAppBar(
          title: const Text('Booked'),
          tabBar: const TabBar(
            indicatorColor: ColorStyle.primary,
            labelColor: ColorStyle.tertiary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Bookings'),
              Tab(text: 'Walk-in'),
            ],
          ),
          tabBarColor: Colors.grey.shade50,
        ),
        body: TabBarView(
          children: [
            hasBook
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        Map book = bookings[index] as Map;
                        bool isStatus = book['Status'] == '0' && book['deleted_at'] == null;
                        bool isCancelled = book['deleted_at'] != null && book['Status'] == '0';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(book['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalBookings(
                                  '${book['Name']}',
                                  '${book['ContactNumber']}', '${book['LoadWeight']}', '${book['CustomerLoad']}',
                                  '${book['Schedule']}', '${book['PaymentStatus']}', '${book['ServiceName']}',
                                  '${book['BookingID']}', isCancelled);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${book['Name']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${book['CustomerLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Folding Process Yet'),),
            hasWalkin
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Contact ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: walkins.length,
                      itemBuilder: (context, index) {
                        Map walk = walkins[index] as Map;
                        bool isStatus = walk['Status'] == '0' && walk['deleted_at'] == null;
                        bool isCancelled = walk['deleted_at'] != null && walk['Status'] == '0';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(walk['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalWalkins(
                                  '${walk['ContactNumber']}', '${walk['WalkinLoad']}', '${walk['Total']}',
                                  '${walk['DateIssued']}', '${walk['PaymentStatus']}', '${walk['ServiceName']}',
                                  '${walk['WalkinID']}',isCancelled);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${walk['ContactNumber']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${walk['WalkinLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Folding Process Yet'),)
          ],
        ),
      ),
    );

  }
}

class NewPickupScreen extends StatefulWidget {
  const NewPickupScreen({super.key});

  @override
  State<NewPickupScreen> createState() => _NewPickupScreenState();
}

class _NewPickupScreenState extends State<NewPickupScreen> {

  String? token;
  int? userid;
  int? shopid;
  String _selectedRange = 'Weekly';
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
    dryDisplay();
  }

  Future<void> dryDisplay() async{
    ApiResponse response = await getPickup(token.toString());

    if(response.error == null){
      setState(() {
        bookings = response.data as List<dynamic>;
        walkins = response.data1 as List<dynamic>;
        hasBook = bookings.isNotEmpty;
        hasWalkin = walkins.isNotEmpty;
        isLoading = false;
      });
    }else{
      print(response.error);
    }
  }

  Future<void> paymentUpdate(String type, String id) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updatePayment(
        type, id, '${prefs.getString('token')}'
    );

    Navigator.pop(context);

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context);
      setState(() {
        getUser();
      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> completeUpdate(String type, String id, String paid) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updateComplete(
        type, id, paid, '${prefs.getString('token')}'
    );

    Navigator.pop(context);

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context);
      setState(() {
        getUser();
      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalBookings(String name,String contact, String load, String total, String date,
      String payment, String service, String bookingId, bool isCancelled,bool isPending){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      'Booking ID: $bookingId',
                      style: LoginStyle.modalTitle,
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child:  SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Name',)
                                      ],),
                                      description: Text(name, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call,color: ColorStyle.tertiary),
                                        Text('Contact Number',)
                                      ],),
                                      description: Text(contact, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load',)
                                      ],),
                                      description: Text('$load kg/s', style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service',)
                                      ],),
                                      description: Text(service, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Payment Status',)
                                      ],),
                                      description: Text(payment, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            )
                        )
                    ),
                    isPaid
                        ?  isPending ? Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width, 20)
                            ),
                            onPressed: (){
                              completeUpdate('booking', bookingId, 'paid');
                            },
                            child: const Text('Complete', style: TextStyle(color:Colors.white),)
                        )
                    ) : SizedBox.shrink()
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width *.40, 20)
                            ),
                            onPressed: (){
                              paymentUpdate('booking', bookingId);
                            },
                            child: const Text('Paid', style: TextStyle(color:Colors.white),)
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width *.40, 20)
                            ),
                            onPressed: (){
                              completeUpdate('booking', bookingId, 'notpaid');
                            },
                            child: const Text('Complete', style: TextStyle(color:Colors.white),)
                        ),
                      ],
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  void _bottomModalWalkins(String contact, String load, String total, String date,
      String payment, String service, String walkinId, bool isCancelled, bool isPending){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      'Walkin ID: $walkinId',
                      style: LoginStyle.modalTitle,
                    ),
                    Divider(),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call, color: ColorStyle.tertiary,),
                                        Text('Contact')
                                      ],),
                                      description: Text(contact,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load')
                                      ],),
                                      description: Text('$load kg/s',style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service')
                                      ],),
                                      description: Text(service,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.payments,color: ColorStyle.tertiary),
                                        Text('Payment Status')
                                      ],),
                                      description: Text(payment,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),

                                ],
                              ),
                            )
                        )
                    ),
                    isPaid
                        ?  isPending ? Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width, 20)
                            ),
                            onPressed: (){
                              completeUpdate('walkin', walkinId, 'paid');
                            },
                            child: const Text('Complete', style: TextStyle(color:Colors.white),)
                        )
                    ) : SizedBox.shrink()
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width *.40, 20)
                            ),
                            onPressed: (){
                              paymentUpdate('walkin', walkinId);
                            },
                            child: const Text('Paid', style: TextStyle(color:Colors.white),)
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                fixedSize: Size(MediaQuery.of(context).size.width *.40, 20)
                            ),
                            onPressed: (){
                              completeUpdate('walkin', walkinId, 'notpaid');
                            },
                            child: const Text('Complete', style: TextStyle(color:Colors.white),)
                        ),
                      ],
                    )
                  ],
                ),
              )
          );
        }
    );
  }


  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: ForAppBar(
                title: const Text('Booked'),
                tabBar: const TabBar(
                  indicatorColor: ColorStyle.primary,
                  labelColor: ColorStyle.tertiary,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Bookings'),
                    Tab(text: 'Walk-in'),
                  ],
                ),
                tabBarColor: Colors.grey.shade50,
              ),
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              )
          )
      );
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: ForAppBar(
          title: const Text('Booked'),
          tabBar: const TabBar(
            indicatorColor: ColorStyle.primary,
            labelColor: ColorStyle.tertiary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Bookings'),
              Tab(text: 'Walk-in'),
            ],
          ),
          tabBarColor: Colors.grey.shade50,
        ),
        body: TabBarView(
          children: [
            hasBook
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        Map book = bookings[index] as Map;
                        bool isStatus = book['Status'] == '0' && book['deleted_at'] == null;
                        bool isCancelled = book['deleted_at'] != null && book['Status'] == '0';
                        bool isPending = book['Status'] == '4';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(book['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalBookings(
                                  '${book['Name']}',
                                  '${book['ContactNumber']}', '${book['LoadWeight']}', '${book['CustomerLoad']}',
                                  '${book['Schedule']}', '${book['PaymentStatus']}', '${book['ServiceName']}',
                                  '${book['BookingID']}',isCancelled,isPending);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${book['Name']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${book['CustomerLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Pickups Process Yet'),),
            hasWalkin
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Contact ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: walkins.length,
                      itemBuilder: (context, index) {
                        Map walk = walkins[index] as Map;
                        bool isStatus = walk['Status'] == '0' && walk['deleted_at'] == null;
                        bool isCancelled = walk['deleted_at'] != null && walk['Status'] == '0';
                        bool isPending = walk['Status'] == '4';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(walk['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalWalkins(
                                  '${walk['ContactNumber']}', '${walk['WalkinLoad']}', '${walk['Total']}',
                                  '${walk['DateIssued']}', '${walk['PaymentStatus']}', '${walk['ServiceName']}',
                                  '${walk['WalkinID']}',isCancelled, isPending);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${walk['ContactNumber']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${walk['WalkinLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Pickups Process Yet'),)
          ],
        ),
      ),
    );

  }
}

class NewCompleteScreen extends StatefulWidget {
  const NewCompleteScreen({super.key});

  @override
  State<NewCompleteScreen> createState() => _NewCompleteScreenState();
}

class _NewCompleteScreenState extends State<NewCompleteScreen> {

  String? token;
  int? userid;
  int? shopid;
  String _selectedRange = 'Weekly';
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });
    dryDisplay();
  }

  Future<void> dryDisplay() async{
    ApiResponse response = await getComplete(token.toString());

    if(response.error == null){
      setState(() {
        bookings = response.data as List<dynamic>;
        walkins = response.data1 as List<dynamic>;
        hasBook = bookings.isNotEmpty;
        hasWalkin = walkins.isNotEmpty;
        isLoading = false;
      });
    }else{
      print(response.error);
    }
  }

  Future<void> paymentUpdate(String type, String id) async{
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        }
    );
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await updatePayment(
        type, id, '${prefs.getString('token')}'
    );

    Navigator.pop(context);

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.pop(context);
      setState(() {
        getUser();
      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalBookings(String name,String contact, String load, String total, String date,
      String payment, String service, String bookingId, bool isCancelled, bool isPickup){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 20,),
                    Text(
                      'Booking ID: $bookingId',
                      style: LoginStyle.modalTitle,
                    ),
                    SizedBox(height: 20,),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child:  SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Name',)
                                      ],),
                                      description: Text(name, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call,color: ColorStyle.tertiary),
                                        Text('Contact Number',)
                                      ],),
                                      description: Text(contact, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load',)
                                      ],),
                                      description: Text('$load kg/s', style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service',)
                                      ],),
                                      description: Text(service, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.person,color: ColorStyle.tertiary),
                                        Text('Payment Status',)
                                      ],),
                                      description: Text(payment, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            )
                        )
                    ),
                    isPaid || isCancelled ? SizedBox.shrink() : Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              fixedSize: Size(MediaQuery.of(context).size.width, 20)
                          ),
                          onPressed: (){
                            paymentUpdate('booking', bookingId);
                          },
                          child: const Text('Paid', style: TextStyle(color:Colors.white),)
                      ),
                    )
                  ],
                ),
              )
          );
        }
    );
  }

  void _bottomModalWalkins(String contact, String load, String total, String date,
      String payment, String service, String walkinId, bool isCancelled, bool isComplete){
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
                top: Radius.circular(25)
            )
        ),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height *.5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 10,),
                    Text(
                      'Walkin ID: $walkinId',
                      style: LoginStyle.modalTitle,
                    ),
                    Divider(),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.calendar_month,color: ColorStyle.tertiary),
                                        Text('Date',)
                                      ],),
                                      description: Text(date, style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.call, color: ColorStyle.tertiary,),
                                        Text('Contact')
                                      ],),
                                      description: Text(contact,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.monitor_weight,color: ColorStyle.tertiary),
                                        Text('Load')
                                      ],),
                                      description: Text('$load kg/s',style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.local_laundry_service,color: ColorStyle.tertiary),
                                        Text('Service')
                                      ],),
                                      description: Text(service,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.attach_money,color: ColorStyle.tertiary),
                                        Text('Total Cost',)
                                      ],),
                                      description: Text(total,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(children: [
                                        Icon(Icons.payments,color: ColorStyle.tertiary),
                                        Text('Payment Status')
                                      ],),
                                      description: Text(payment,style: TextStyle(fontWeight: FontWeight.bold),)
                                  ),
                                  const SizedBox(height: 10),

                                ],
                              ),
                            )
                        )
                    ),
                    isPaid || isComplete ? SizedBox.shrink() : Align(
                      alignment: Alignment.bottomCenter,
                      child: isComplete ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                              fixedSize: Size(MediaQuery.of(context).size.width, 20)
                          ),
                          onPressed: (){
                            paymentUpdate('walkin', walkinId);
                          },
                          child: const Text('Complete', style: TextStyle(color:Colors.white),)
                      ): Row(
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorStyle.tertiary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  fixedSize: Size(MediaQuery.of(context).size.width, 20)
                              ),
                              onPressed: (){
                                paymentUpdate('walkin', walkinId);
                              },
                              child: const Text('Paid', style: TextStyle(color:Colors.white),)
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: ColorStyle.tertiary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)
                                  ),
                                  fixedSize: Size(MediaQuery.of(context).size.width, 20)
                              ),
                              onPressed: (){
                                paymentUpdate('walkin', walkinId);
                              },
                              child: const Text('Paid', style: TextStyle(color:Colors.white),)
                          ),
                        ],
                      )
                    )
                  ],
                ),
              )
          );
        }
    );
  }


  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: ForAppBar(
                title: const Text('Booked'),
                tabBar: const TabBar(
                  indicatorColor: ColorStyle.primary,
                  labelColor: ColorStyle.tertiary,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Bookings'),
                    Tab(text: 'Walk-in'),
                  ],
                ),
                tabBarColor: Colors.grey.shade50,
              ),
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              )
          )
      );
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: ForAppBar(
          title: const Text('Booked'),
          tabBar: const TabBar(
            indicatorColor: ColorStyle.primary,
            labelColor: ColorStyle.tertiary,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(text: 'Bookings'),
              Tab(text: 'Walk-in'),
            ],
          ),
          tabBarColor: Colors.grey.shade50,
        ),
        body: TabBarView(
          children: [
            hasBook
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Name ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        Map book = bookings[index] as Map;
                        bool isStatus = book['Status'] == '0' && book['deleted_at'] == null;
                        bool isCancelled = book['deleted_at'] != null && book['Status'] == '0';
                        bool isPickup = book['Status'] == '4';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(book['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalBookings(
                                  '${book['Name']}',
                                  '${book['ContactNumber']}', '${book['LoadWeight']}', '${book['CustomerLoad']}',
                                  '${book['Schedule']}', '${book['PaymentStatus']}', '${book['ServiceName']}',
                                  '${book['BookingID']}',isCancelled, isPickup);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${book['Name']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${book['CustomerLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Completed Process Yet'),),
            hasWalkin
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Container(
                      color: ColorStyle.tertiary,
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(child: Text('Contact ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Load', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
                          Expanded(child: Text('Status', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center,)),
                        ],
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: walkins.length,
                      itemBuilder: (context, index) {
                        Map walk = walkins[index] as Map;
                        bool isStatus = walk['Status'] == '0' && walk['deleted_at'] == null;
                        bool isCancelled = walk['deleted_at'] != null && walk['Status'] == '0';
                        bool isComplete = walk['Status'] == '5';
                        String status = '';
                        Color? color;

                        if(isCancelled){
                          status = 'Cancelled';
                          color = Colors.red;
                        }else{
                          switch(walk['Status']){
                            case '1':
                              status = 'Washing';
                              color = Colors.blue;
                              break;
                            case '2':
                              status = 'Drying';
                              color = Colors.yellow;
                              break;
                            case '3':
                              status = 'Folding';
                              color = Colors.lightGreenAccent;
                              break;
                            case '4':
                              status = 'Pickup';
                              color = Colors.orange;
                              break;
                            default:
                              status = 'Complete';
                              color = Colors.green;
                          }
                        }

                        return InkWell(
                            onTap: (){
                              _bottomModalWalkins(
                                  '${walk['ContactNumber']}', '${walk['WalkinLoad']}', '${walk['Total']}',
                                  '${walk['DateIssued']}', '${walk['PaymentStatus']}', '${walk['ServiceName']}',
                                  '${walk['WalkinID']}', isCancelled,isComplete);
                            },
                            child: Ink(
                              color: Colors.white,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
                                ),
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Expanded(child: Text('${walk['ContactNumber']}',
                                      style: TextStyle(fontWeight: FontWeight.bold),)),
                                    Expanded(child: Text('${walk['WalkinLoad']} kg.',
                                        style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            status,
                                            style: TextStyle(
                                                color: color,
                                                fontWeight: FontWeight.bold
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
                : Center(child: const Text('No Completed Process Yet'),)
          ],
        ),
      ),
    );

  }
}