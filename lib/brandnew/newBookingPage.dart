import 'dart:core';

import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/loginStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewBookingScreen extends StatefulWidget {
  const NewBookingScreen({super.key});

  @override
  State<NewBookingScreen> createState() => _NewBookingScreenState();
}

class _NewBookingScreenState extends State<NewBookingScreen> {
  String? token;
  int? userid;
  int? shopid;
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;
  final TextEditingController _finalWeight = TextEditingController();
  String _finalCost = '';

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];


  Future<void> bookingsDisplay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getBookings('${prefs.getString('token')}');

    if (response.error == null) {
        setState(() {
          bookings = response.data as List<dynamic>;
          hasBook = bookings.isNotEmpty;
          isLoading = false;
        });
    } else {
      isLoading = false;
      print(response.error);
    }
  }

  Future<void> walkinDisplay() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getWalkin('${prefs.getString('token')}');

    if (response.error == null) {
        setState(() {
          walkins = response.data as List<dynamic>;
          hasWalkin = walkins.isNotEmpty;
        });
    } else {
      print(response.error);
    }
  }

  Future<void> walkinUpdate(String stat, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response =
        await updateWalkin(stat, '${prefs.getString('token')}', id);

    if (response.error == null) {
      if (stat == '1') {
        await successDialog(context, '${response.data}');
        Navigator.pop(context);
      } else {
        await warningDialog(context, '${response.data}');
        Navigator.pop(context);
      }
      walkinDisplay();
    } else {
      await errorDialog(context, '${response.error}');
      print(response.error);
    }
  }

  Future<void> bookingUpdate(String stat, String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response =
        await updateBooking(stat, '${prefs.getString('token')}', id,_finalWeight.text,_finalCost);

    if (response.error == null) {
      if (stat == '1') {
        await successDialog(context, '${response.data}');
        Navigator.pop(context);
      } else {
        await warningDialog(context, '${response.data}');
        Navigator.pop(context);
      }
      bookingsDisplay();
    } else {
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalBookings(
      String name, String contact, String load, String total, String date,
      String payment, String service, String bookingId, String customerImage, String customerAddress
      ,String loadprice, String loadweight) {
    _finalWeight.text = load;
    int multiplier = 0;

    print(_finalWeight.text);

    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 32,
                      color: ColorStyle.tertiary,
                    ),
                    Text(
                      ' Confirm Laundry Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ProfilePicture(
                          name: name,
                          fontsize: 14,
                          radius: 18,
                          img: customerImage == 'null' || customerImage == null
                              ? null
                              : '$picaddress/$customerImage',
                        ),
                        title: Text(name),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              customerAddress,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contact Information',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    contact,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date Requested',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    date,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Service Availed',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    service,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment Status',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    payment,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Total Payment',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '₱$total.00',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: RowItem(
                          title: const Text(
                            'Total Weight',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          description: TextField(
                            controller: _finalWeight,
                            keyboardType:
                            const TextInputType.numberWithOptions(decimal: true),
                            decoration: const InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(8),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        foregroundColor: ColorStyle.tertiary,
                        side: const BorderSide(color: ColorStyle.tertiary),
                        fixedSize:
                        Size(MediaQuery.of(context).size.width * .42, 30),
                      ),
                      onPressed: () {
                        bookingUpdate('2',
                            bookingId);
                      },
                      child: const Text('Decline'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        backgroundColor: ColorStyle.tertiary,
                        foregroundColor: Colors.white,
                        fixedSize:
                        Size(MediaQuery.of(context).size.width * .42, 30),
                      ),
                      onPressed: () {
                        if (_finalWeight.text.isNotEmpty) {
                          multiplier = (int.parse(_finalWeight.text) / int.parse(loadweight)).ceil();
                          _finalCost = (multiplier * int.parse(loadprice)).toString();
                        }
                        bookingUpdate('1',
                            bookingId);
                      },
                      child: const Text('Proceed'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  void _bottomModalWalkins(
      String contact, String load, String total, String date, String payment,
      String service, String walkinId) {
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          return SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.directions_walk_outlined,
                          size: 32,
                          color: ColorStyle.tertiary,
                        ),
                        Text(
                          ' Confirm Laundry Details',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RowItem(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Contact Information',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        contact,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  description: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Date Requested',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        date,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RowItem(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Service Availed',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        service,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  description: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Payment Status',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        payment,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                const Text(
                                  'Total Payment',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                Text(
                                  '₱$total.00',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            foregroundColor: ColorStyle.tertiary,
                            side: const BorderSide(color: ColorStyle.tertiary),
                            fixedSize:
                            Size(MediaQuery.of(context).size.width * .42, 30),
                          ),
                          onPressed: () {
                            walkinUpdate('2', walkinId);
                          },
                          child: const Text('Decline'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            backgroundColor: ColorStyle.tertiary,
                            foregroundColor: Colors.white,
                            fixedSize:
                            Size(MediaQuery.of(context).size.width * .42, 30),
                          ),
                          onPressed: () {
                            walkinUpdate('1', walkinId);
                          },
                          child: const Text('Proceed'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    bookingsDisplay();
    walkinDisplay();
  }

  @override
  Widget build(BuildContext context) {
    print(hasWalkin);
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Booked'),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                  leading: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
                  ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const TabBar(
                      indicatorColor: ColorStyle.primary,
                      labelColor: ColorStyle.tertiary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Bookings'),
                        Tab(text: 'Walk-in'),
                      ],
                    ),
                  ),
                )
              ),
              body: isLoading ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              ) : TabBarView(
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
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Name ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              Map book = bookings[index] as Map;
                              bool isCancelled = book['deleted_at'] != null &&
                                  book['Status'] == '0';

                              if (isCancelled) {
                              } else {
                                switch (book['Status']) {
                                  case '1':
                                    break;
                                  case '2':
                                    break;
                                  case '3':
                                    break;
                                  case '4':
                                    break;
                                  default:
                                }
                              }

                              return InkWell(
                                  onTap: () {
                                    _bottomModalBookings(
                                        '${book['CustomerName']}',
                                        '${book['CustomerContactNumber']}',
                                        '${book['CustomerLoad']}',
                                        '${book['LoadCost']}',
                                        '${book['Schedule']}',
                                        '${book['PaymentStatus']}',
                                        '${book['ServiceName']}',
                                        '${book['BookingID']}',
                                        '${book['CustomerImage']}',
                                        '${book['CustomerAddress']}',
                                        '${book['LoadPrice']}',
                                        '${book['LoadWeight']}');
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                '${book['CustomerName']}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              )),
                                          Expanded(
                                              child: Text(
                                                  '${book['CustomerLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold))),
                                          const Expanded(
                                              child: Text(
                                                  'Pending',
                                                  style: TextStyle(
                                                      color: Colors.amberAccent,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                      : const Center(
                    child: Text('No Bookings Yet'),
                  ),
                  hasWalkin
                      ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            color: ColorStyle.tertiary,
                            padding: const EdgeInsets.all(8),
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Contact ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                      'Status',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: walkins.length,
                            itemBuilder: (context, index) {
                              Map walk = walkins[index] as Map;

                              bool isCancelled = walk['deleted_at'] != null &&
                                  walk['Status'] == '0';

                              if (isCancelled) {
                              } else {
                                switch (walk['Status']) {
                                  case '1':
                                    break;
                                  case '2':
                                    break;
                                  case '3':
                                    break;
                                  case '4':
                                    break;
                                  default:
                                }
                              }

                              return InkWell(
                                  onTap: () {
                                    _bottomModalWalkins(
                                        '${walk['ContactNumber']}',
                                        '${walk['WalkinLoad']}',
                                        '${walk['Total']}',
                                        '${walk['DateIssued']}',
                                        '${walk['PaymentStatus']}',
                                        '${walk['ServiceName']}',
                                        '${walk['WalkinID']}',);
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                                '${walk['ContactNumber']}',
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              )),
                                          Expanded(
                                              child: Text(
                                                  '${walk['WalkinLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold))),
                                          const Expanded(
                                              child: Text(
                                                  'Pending',
                                                  style: TextStyle(
                                                      color: Colors.amberAccent,
                                                      fontWeight:
                                                      FontWeight
                                                          .bold),
                                                  textAlign:
                                                  TextAlign.center,
                                                ),
                                              ),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                      : const Center(
                    child: Text('No Walkins Yet'),
                  )
                ],
              )
          )
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
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        token = prefs.getString('token');
        userid = prefs.getInt('userid');
        shopid = prefs.getInt('shopid');
      });
    washDisplay();
  }

  Future<void> washDisplay() async {
    ApiResponse response = await getWashing(token.toString());

    if (response.error == null) {
      setState(() {
        bookings = response.data as List<dynamic>;
        walkins = response.data1 as List<dynamic>;
        hasBook = bookings.isNotEmpty;
        hasWalkin = walkins.isNotEmpty;
        isLoading = false;
      });
    } else {
    }
  }

  Future<void> paymentUpdate(String type, String id) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response =
        await updatePayment(type, id, '${prefs.getString('token')}');

    Navigator.pop(context);

    if (response.error == null) {
      await successDialog(context, '${response.data}');
      Navigator.pop(context);

        getUser();

    } else {
      await errorDialog(context, '${response.error}');
    }
  }



  /*void _bottomModalBookings(
      String name, String contact, String load, String total, String date,
      String payment, String service, String bookingId, bool isCancelled) {
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Booking ID: $bookingId',
                      style: LoginStyle.modalTitle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.calendar_month,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Date',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        date,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.person,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Name',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.call,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Contact Number',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        contact,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.monitor_weight,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Load',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        '$load kg/s',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.local_laundry_service,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Service',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        service,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.attach_money,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Total Cost',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        total,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.person,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Payment Status',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        payment,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ))),
                    isPaid || isCancelled
                        ? const SizedBox.shrink()
                        : Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorStyle.tertiary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width, 20)),
                                onPressed: () {
                                  paymentUpdate('booking', bookingId);
                                },
                                child: const Text(
                                  'Paid',
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                  ],
                ),
              ));
        });
  }*/

  void _bottomModalBookings(
      String name, String contact, String load, String total, String date,
      String payment, String service, String bookingId, String customerImage, String customerAddress
      ) {
    bool isPaid = payment == 'paid';

    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 32,
                      color: ColorStyle.tertiary,
                    ),
                    Text(
                      ' Laundry Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ProfilePicture(
                          name: name,
                          fontsize: 14,
                          radius: 18,
                          img: customerImage == 'null' || customerImage == null
                              ? null
                              : '$picaddress/$customerImage',
                        ),
                        title: Text(name),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              customerAddress,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contact Information',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    contact,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date Requested',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    date,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Service Availed',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    service,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment Status',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    payment,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Payment',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '₱$total.00',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Laundry Weight',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '$load kg/s',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isPaid
                  ? const SizedBox.shrink()
                  : Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorStyle.tertiary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        fixedSize: Size(
                            MediaQuery.of(context).size.width, 20)),
                    onPressed: () {
                      paymentUpdate('booking', bookingId);
                    },
                    child: const Text(
                      'Paid',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  void _bottomModalWalkins(
      String contact, String load, String total, String date, String payment,
      String service, String walkinId) {
    bool isPaid = payment == 'paid';
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_walk_outlined,
                        size: 32,
                        color: ColorStyle.tertiary,
                      ),
                      Text(
                        ' Laundry Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Contact Information',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      contact,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Date Requested',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      date,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Service Availed',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      service,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Payment Status',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      payment,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RowItem(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Payment',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        '₱$total.00',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  description: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Laundry Weight',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        '$load kg/s',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                isPaid
                    ? const SizedBox.shrink()
                    : Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorStyle.tertiary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width, 20)),
                        onPressed: () {
                          paymentUpdate('walkin', walkinId);
                        },
                        child: const Text(
                          'Paid',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          );
        });
  }

  /*void _bottomModalWalkins(
      String contact, String load, String total, String date, String payment,
      String service, String walkinId, bool isCancelled) {
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Walkin ID: $walkinId',
                      style: LoginStyle.modalTitle,
                    ),
                    const Divider(),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.calendar_month,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Date',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        date,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color: ColorStyle.tertiary,
                                          ),
                                          Text('Contact')
                                        ],
                                      ),
                                      description: Text(
                                        contact,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.monitor_weight,
                                              color: ColorStyle.tertiary),
                                          Text('Load')
                                        ],
                                      ),
                                      description: Text(
                                        '$load kg/s',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.local_laundry_service,
                                              color: ColorStyle.tertiary),
                                          Text('Service')
                                        ],
                                      ),
                                      description: Text(
                                        service,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.attach_money,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Total Cost',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        total,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.payments,
                                              color: ColorStyle.tertiary),
                                          Text('Payment Status')
                                        ],
                                      ),
                                      description: Text(
                                        payment,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ))),
                    isPaid || isCancelled
                        ? const SizedBox.shrink()
                        : Align(
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: ColorStyle.tertiary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    fixedSize: Size(
                                        MediaQuery.of(context).size.width, 20)),
                                onPressed: () {
                                  paymentUpdate('walkin', walkinId);
                                },
                                child: const Text(
                                  'Paid',
                                  style: TextStyle(color: Colors.white),
                                )),
                          )
                  ],
                ),
              ));
        });
  }*/

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                  title: const Text('Washing'),
                  titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                  leading: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(kToolbarHeight),
                    child: Container(
                      color: Colors.grey.shade200,
                      child: const TabBar(
                        indicatorColor: ColorStyle.primary,
                        labelColor: ColorStyle.tertiary,
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: 'Bookings'),
                          Tab(text: 'Walk-in'),
                        ],
                      ),
                    ),
                  )
              ),
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              )));
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Washing'),
            titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Container(
                color: Colors.grey.shade200,
                child: const TabBar(
                  indicatorColor: ColorStyle.primary,
                  labelColor: ColorStyle.tertiary,
                  unselectedLabelColor: Colors.grey,
                  tabs: [
                    Tab(text: 'Bookings'),
                    Tab(text: 'Walk-in'),
                  ],
                ),
              ),
            )
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
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Name ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              Map book = bookings[index] as Map;
                              bool isCancelled = book['deleted_at'] != null &&
                                  book['Status'] == '0';
                              String status = '';
                              Color? color;

                              if (isCancelled) {
                                status = 'Cancelled';
                                color = Colors.red;
                              } else {
                                switch (book['Status']) {
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
                                  onTap: () {
                                    _bottomModalBookings(
                                        '${book['CustomerName']}',
                                        '${book['CustomerContactNumber']}',
                                        '${book['CustomerLoad']}',
                                        '${book['LoadCost']}',
                                        '${book['Schedule']}',
                                        '${book['PaymentStatus']}',
                                        '${book['ServiceName']}',
                                        '${book['BookingID']}',
                                        '${book['CustomerImage']}',
                                        '${book['CustomerAddress']}');
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            '${book['CustomerName']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(
                                              child: Text(
                                                  '${book['CustomerLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No Washing Process Yet'),
                  ),
            hasWalkin
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            color: ColorStyle.tertiary,
                            padding: const EdgeInsets.all(8),
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Contact ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: walkins.length,
                            itemBuilder: (context, index) {
                              Map walk = walkins[index] as Map;
                              bool isCancelled = walk['deleted_at'] != null &&
                                  walk['Status'] == '0';
                              String status = '';
                              Color? color;

                              if (isCancelled) {
                                status = 'Cancelled';
                                color = Colors.red;
                              } else {
                                switch (walk['Status']) {
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
                                  onTap: () {
                                    _bottomModalWalkins(
                                        '${walk['ContactNumber']}',
                                        '${walk['WalkinLoad']}',
                                        '${walk['Total']}',
                                        '${walk['DateIssued']}',
                                        '${walk['PaymentStatus']}',
                                        '${walk['ServiceName']}',
                                        '${walk['WalkinID']}',);
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            '${walk['ContactNumber']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(
                                              child: Text(
                                                  '${walk['WalkinLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No Washing Process Yet'),
                  )
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
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        token = prefs.getString('token');
        userid = prefs.getInt('userid');
        shopid = prefs.getInt('shopid');
      });
    dryDisplay();
  }

  Future<void> dryDisplay() async {
    ApiResponse response = await getDrying(token.toString());

    if (response.error == null) {

        setState(() {
          bookings = response.data as List<dynamic>;
          walkins = response.data1 as List<dynamic>;
          hasBook = bookings.isNotEmpty;
          hasWalkin = walkins.isNotEmpty;
          isLoading = false;
        });

    } else {
    }
  }

  Future<void> paymentUpdate(String type, String id) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response =
        await updatePayment(type, id, '${prefs.getString('token')}');

    Navigator.pop(context);

    if (response.error == null) {
      await successDialog(context, '${response.data}');
      Navigator.pop(context);

        getUser();

    } else {
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalBookings(
      String name, String contact, String load, String total, String date,
      String payment, String service, String bookingId, String customerImage, String customerAddress
      ) {
    bool isPaid = payment == 'paid';

    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 32,
                      color: ColorStyle.tertiary,
                    ),
                    Text(
                      ' Laundry Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ProfilePicture(
                          name: name,
                          fontsize: 14,
                          radius: 18,
                          img: customerImage == 'null' || customerImage == null
                              ? null
                              : '$picaddress/$customerImage',
                        ),
                        title: Text(name),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              customerAddress,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contact Information',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    contact,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date Requested',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    date,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Service Availed',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    service,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment Status',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    payment,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Payment',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '₱$total.00',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Laundry Weight',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '$load kg/s',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isPaid
                  ? const SizedBox.shrink()
                  : Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorStyle.tertiary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        fixedSize: Size(
                            MediaQuery.of(context).size.width, 20)),
                    onPressed: () {
                      paymentUpdate('booking', bookingId);
                    },
                    child: const Text(
                      'Paid',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  void _bottomModalWalkins(
      String contact, String load, String total, String date, String payment,
      String service, String walkinId) {
    bool isPaid = payment == 'paid';
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_walk_outlined,
                        size: 32,
                        color: ColorStyle.tertiary,
                      ),
                      Text(
                        ' Laundry Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Contact Information',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      contact,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Date Requested',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      date,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Service Availed',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      service,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Payment Status',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      payment,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RowItem(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Payment',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        '₱$total.00',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  description: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Laundry Weight',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        '$load kg/s',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                isPaid
                    ? const SizedBox.shrink()
                    : Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorStyle.tertiary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width, 20)),
                        onPressed: () {
                          paymentUpdate('walkin', walkinId);
                        },
                        child: const Text(
                          'Paid',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Drying'),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                  leading: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
                  ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const TabBar(
                      indicatorColor: ColorStyle.primary,
                      labelColor: ColorStyle.tertiary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Bookings'),
                        Tab(text: 'Walk-in'),
                      ],
                    ),
                  ),
                )
              ),
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              )));
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
                title: const Text('Drying'),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const TabBar(
                      indicatorColor: ColorStyle.primary,
                      labelColor: ColorStyle.tertiary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Bookings'),
                        Tab(text: 'Walk-in'),
                      ],
                    ),
                  ),
                )
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
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Name ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              Map book = bookings[index] as Map;
                              bool isCancelled = book['deleted_at'] != null &&
                                  book['Status'] == '0';
                              String status = '';
                              Color? color;

                              if (isCancelled) {
                                status = 'Cancelled';
                                color = Colors.red;
                              } else {
                                switch (book['Status']) {
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
                                  onTap: () {
                                    _bottomModalBookings(
                                        '${book['CustomerName']}',
                                        '${book['CustomerContactNumber']}',
                                        '${book['LoadWeight']}',
                                        '${book['CustomerLoad']}',
                                        '${book['Schedule']}',
                                        '${book['PaymentStatus']}',
                                        '${book['ServiceName']}',
                                        '${book['BookingID']}',
                                        '${book['CustomerImage']}',
                                        '${book['CustomerAddress']}');
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            '${book['CustomerName']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(
                                              child: Text(
                                                  '${book['CustomerLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No Drying Process Yet'),
                  ),
            hasWalkin
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            color: ColorStyle.tertiary,
                            padding: const EdgeInsets.all(8),
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Contact ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: walkins.length,
                            itemBuilder: (context, index) {
                              Map walk = walkins[index] as Map;
                              bool isCancelled = walk['deleted_at'] != null &&
                                  walk['Status'] == '0';
                              String status = '';
                              Color? color;

                              if (isCancelled) {
                                status = 'Cancelled';
                                color = Colors.red;
                              } else {
                                switch (walk['Status']) {
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
                                  onTap: () {
                                    _bottomModalWalkins(
                                        '${walk['ContactNumber']}',
                                        '${walk['WalkinLoad']}',
                                        '${walk['Total']}',
                                        '${walk['DateIssued']}',
                                        '${walk['PaymentStatus']}',
                                        '${walk['ServiceName']}',
                                        '${walk['WalkinID']}',);
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            '${walk['ContactNumber']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(
                                              child: Text(
                                                  '${walk['WalkinLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No Drying Process Yet'),
                  )
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
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        token = prefs.getString('token');
        userid = prefs.getInt('userid');
        shopid = prefs.getInt('shopid');
      });

    foldDisplay();
  }

  Future<void> foldDisplay() async {
    ApiResponse response = await getFolding(token.toString());

    if (response.error == null) {

        setState(() {
          bookings = response.data as List<dynamic>;
          walkins = response.data1 as List<dynamic>;
          hasBook = bookings.isNotEmpty;
          hasWalkin = walkins.isNotEmpty;
          isLoading = false;
        });

    } else {
    }
  }

  Future<void> paymentUpdate(String type, String id) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response =
        await updatePayment(type, id, '${prefs.getString('token')}');

    Navigator.pop(context);

    if (response.error == null) {
      await successDialog(context, '${response.data}');
      Navigator.pop(context);

        getUser();

    } else {
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalBookings(
      String name, String contact, String load, String total, String date,
      String payment, String service, String bookingId, String customerImage, String customerAddress
      ) {
    bool isPaid = payment == 'paid';

    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 32,
                      color: ColorStyle.tertiary,
                    ),
                    Text(
                      ' Laundry Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ProfilePicture(
                          name: name,
                          fontsize: 14,
                          radius: 18,
                          img: customerImage == 'null' || customerImage == null
                              ? null
                              : '$picaddress/$customerImage',
                        ),
                        title: Text(name),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              customerAddress,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contact Information',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    contact,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date Requested',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    date,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Service Availed',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    service,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment Status',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    payment,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Total Payment',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              '₱$total.00',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isPaid
                  ? const SizedBox.shrink()
                  : Align(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ColorStyle.tertiary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)),
                        fixedSize: Size(
                            MediaQuery.of(context).size.width, 20)),
                    onPressed: () {
                      paymentUpdate('booking', bookingId);
                    },
                    child: const Text(
                      'Paid',
                      style: TextStyle(color: Colors.white),
                    )),
              )
            ],
          ),
        );
      },
    );
  }

  void _bottomModalWalkins(
      String contact, String load, String total, String date, String payment,
      String service, String walkinId) {
    bool isPaid = payment == 'paid';
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_walk_outlined,
                        size: 32,
                        color: ColorStyle.tertiary,
                      ),
                      Text(
                        ' Laundry Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Contact Information',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      contact,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Date Requested',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      date,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Service Availed',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      service,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Payment Status',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      payment,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              const Text(
                                'Total Payment',
                                style: TextStyle(color: Colors.grey),
                              ),
                              Text(
                                '₱$total.00',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                isPaid
                    ? const SizedBox.shrink()
                    : Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorStyle.tertiary,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width, 20)),
                        onPressed: () {
                          paymentUpdate('walkin', walkinId);
                        },
                        child: const Text(
                          'Paid',
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Folding'),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                  leading: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
                  ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const TabBar(
                      indicatorColor: ColorStyle.primary,
                      labelColor: ColorStyle.tertiary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Bookings'),
                        Tab(text: 'Walk-in'),
                      ],
                    ),
                  ),
                )
              ),
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              )));
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
                title: const Text('Folding'),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const TabBar(
                      indicatorColor: ColorStyle.primary,
                      labelColor: ColorStyle.tertiary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Bookings'),
                        Tab(text: 'Walk-in'),
                      ],
                    ),
                  ),
                )
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
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Name ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              Map book = bookings[index] as Map;
                              bool isCancelled = book['deleted_at'] != null &&
                                  book['Status'] == '0';
                              String status = '';
                              Color? color;

                              if (isCancelled) {
                                status = 'Cancelled';
                                color = Colors.red;
                              } else {
                                switch (book['Status']) {
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
                                  onTap: () {
                                    _bottomModalBookings(
                                        '${book['CustomerName']}',
                                        '${book['CustomerContactNumber']}',
                                        '${book['LoadWeight']}',
                                        '${book['CustomerLoad']}',
                                        '${book['Schedule']}',
                                        '${book['PaymentStatus']}',
                                        '${book['ServiceName']}',
                                        '${book['BookingID']}',
                                        '${book['CustomerImage']}',
                                        '${book['CustomerAddress']}');
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            '${book['CustomerName']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(
                                              child: Text(
                                                  '${book['CustomerLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No Folding Process Yet'),
                  ),
            hasWalkin
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            color: ColorStyle.tertiary,
                            padding: const EdgeInsets.all(8),
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Contact ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: walkins.length,
                            itemBuilder: (context, index) {
                              Map walk = walkins[index] as Map;
                              bool isCancelled = walk['deleted_at'] != null &&
                                  walk['Status'] == '0';
                              String status = '';
                              Color? color;

                              if (isCancelled) {
                                status = 'Cancelled';
                                color = Colors.red;
                              } else {
                                switch (walk['Status']) {
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
                                  onTap: () {
                                    _bottomModalWalkins(
                                        '${walk['ContactNumber']}',
                                        '${walk['WalkinLoad']}',
                                        '${walk['Total']}',
                                        '${walk['DateIssued']}',
                                        '${walk['PaymentStatus']}',
                                        '${walk['ServiceName']}',
                                        '${walk['WalkinID']}',);
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            '${walk['ContactNumber']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(
                                              child: Text(
                                                  '${walk['WalkinLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No Folding Process Yet'),
                  )
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
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

      setState(() {
        token = prefs.getString('token');
        userid = prefs.getInt('userid');
        shopid = prefs.getInt('shopid');
      });

    pickDisplay();
  }

  Future<void> pickDisplay() async {
    ApiResponse response = await getPickup(token.toString());

    if (response.error == null) {

        setState(() {
          bookings = response.data as List<dynamic>;
          walkins = response.data1 as List<dynamic>;
          hasBook = bookings.isNotEmpty;
          hasWalkin = walkins.isNotEmpty;
          isLoading = false;
        });

    } else {
    }
  }

  Future<void> paymentUpdate(String type, String id) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response =
        await updatePayment(type, id, '${prefs.getString('token')}');

    Navigator.pop(context);

    if (response.error == null) {
      await successDialog(context, '${response.data}');
      Navigator.pop(context);

        getUser();

    } else {
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> completeUpdate(String type, String id, String paid) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response =
        await updateComplete(type, id, paid, '${prefs.getString('token')}');

    Navigator.pop(context);

    if (response.error == null) {
      await successDialog(context, '${response.data}');
      Navigator.pop(context);

        getUser();

    } else {
      await errorDialog(context, '${response.error}');
    }
  }

  /*void _bottomModalBookings(
      String name, String contact, String load, String total, String date,
      String payment, String service, String bookingId, bool isCancelled, bool isPending) {
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Booking ID: $bookingId',
                      style: LoginStyle.modalTitle,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.calendar_month,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Date',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        date,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.person,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Name',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.call,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Contact Number',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        contact,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.monitor_weight,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Load',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        '$load kg/s',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.local_laundry_service,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Service',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        service,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.attach_money,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Total Cost',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        total,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.person,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Payment Status',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        payment,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ))),
                    isPaid
                        ? isPending
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorStyle.tertiary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width,
                                            20)),
                                    onPressed: () {
                                      completeUpdate(
                                          'booking', bookingId, 'paid');
                                    },
                                    child: const Text(
                                      'Complete',
                                      style: TextStyle(color: Colors.white),
                                    )))
                            : const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorStyle.tertiary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width *
                                              .40,
                                          20)),
                                  onPressed: () {
                                    paymentUpdate('booking', bookingId);
                                  },
                                  child: const Text(
                                    'Paid',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorStyle.tertiary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width *
                                              .40,
                                          20)),
                                  onPressed: () {
                                    completeUpdate(
                                        'booking', bookingId, 'notpaid');
                                  },
                                  child: const Text(
                                    'Complete',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          )
                  ],
                ),
              ));
        });
  }

  void _bottomModalWalkins(
      String contact, String load, String total, String date, String payment,
      String service, String walkinId, bool isCancelled, bool isPending) {
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          bool isPaid = payment == 'paid';
          return SizedBox(
              height: MediaQuery.of(context).size.height * .5,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Walkin ID: $walkinId',
                      style: LoginStyle.modalTitle,
                    ),
                    const Divider(),
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.calendar_month,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Date',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        date,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(
                                            Icons.call,
                                            color: ColorStyle.tertiary,
                                          ),
                                          Text('Contact')
                                        ],
                                      ),
                                      description: Text(
                                        contact,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.monitor_weight,
                                              color: ColorStyle.tertiary),
                                          Text('Load')
                                        ],
                                      ),
                                      description: Text(
                                        '$load kg/s',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.local_laundry_service,
                                              color: ColorStyle.tertiary),
                                          Text('Service')
                                        ],
                                      ),
                                      description: Text(
                                        service,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.attach_money,
                                              color: ColorStyle.tertiary),
                                          Text(
                                            'Total Cost',
                                          )
                                        ],
                                      ),
                                      description: Text(
                                        total,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                  RowItem(
                                      title: const Row(
                                        children: [
                                          Icon(Icons.payments,
                                              color: ColorStyle.tertiary),
                                          Text('Payment Status')
                                        ],
                                      ),
                                      description: Text(
                                        payment,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            ))),
                    isPaid
                        ? isPending
                            ? Align(
                                alignment: Alignment.bottomCenter,
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorStyle.tertiary,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        fixedSize: Size(
                                            MediaQuery.of(context).size.width,
                                            20)),
                                    onPressed: () {
                                      completeUpdate(
                                          'walkin', walkinId, 'paid');
                                    },
                                    child: const Text(
                                      'Complete',
                                      style: TextStyle(color: Colors.white),
                                    )))
                            : const SizedBox.shrink()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorStyle.tertiary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width *
                                              .40,
                                          20)),
                                  onPressed: () {
                                    paymentUpdate('walkin', walkinId);
                                  },
                                  child: const Text(
                                    'Paid',
                                    style: TextStyle(color: Colors.white),
                                  )),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorStyle.tertiary,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      fixedSize: Size(
                                          MediaQuery.of(context).size.width *
                                              .40,
                                          20)),
                                  onPressed: () {
                                    completeUpdate(
                                        'walkin', walkinId, 'notpaid');
                                  },
                                  child: const Text(
                                    'Complete',
                                    style: TextStyle(color: Colors.white),
                                  )),
                            ],
                          )
                  ],
                ),
              ));
        });
  }*/

  void _bottomModalBookings(
      String name, String contact, String load, String total, String date,
      String payment, String service, String bookingId, String customerImage, String customerAddress,
      bool isPending
      ) {
    bool isPaid = payment == 'paid';

    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 32,
                      color: ColorStyle.tertiary,
                    ),
                    Text(
                      ' Laundry Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ProfilePicture(
                          name: name,
                          fontsize: 14,
                          radius: 18,
                          img: customerImage == 'null' || customerImage == null
                              ? null
                              : '$picaddress/$customerImage',
                        ),
                        title: Text(name),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              customerAddress,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contact Information',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    contact,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date Requested',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    date,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Service Availed',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    service,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment Status',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    payment,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Payment',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '₱$total.00',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Laundry Weight',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '$load kg/s',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              isPaid
                  ? isPending
                  ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorStyle.tertiary,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5)),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width,
                                20)),
                        onPressed: () {
                          completeUpdate(
                              'booking', bookingId, 'paid');
                        },
                        child: const Text(
                          'Complete',
                          style: TextStyle(color: Colors.white),
                        )),
                  ))
                  : const SizedBox.shrink()
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorStyle.tertiary,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(5)),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width *
                                  .40,
                              20)),
                      onPressed: () {
                        paymentUpdate('booking', bookingId);
                      },
                      child: const Text(
                        'Paid',
                        style: TextStyle(color: Colors.white),
                      )),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: ColorStyle.tertiary,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(5)),
                          fixedSize: Size(
                              MediaQuery.of(context).size.width *
                                  .40,
                              20)),
                      onPressed: () {
                        completeUpdate(
                            'booking', bookingId, 'notpaid');
                      },
                      child: const Text(
                        'Complete',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _bottomModalWalkins(
      String contact, String load, String total, String date, String payment,
      String service, String walkinId,bool isCancelled, bool isPending) {
    bool isPaid = payment == 'paid';
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_walk_outlined,
                        size: 32,
                        color: ColorStyle.tertiary,
                      ),
                      Text(
                        ' Laundry Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Contact Information',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      contact,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Date Requested',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      date,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Service Availed',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      service,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Payment Status',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      payment,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RowItem(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Payment',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        '₱$total.00',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  description: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Laundry Weight',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        '$load kg/s',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
                isPaid
                    ? isPending
                    ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: ColorStyle.tertiary,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(5)),
                              fixedSize: Size(
                                  MediaQuery.of(context).size.width,
                                  20)),
                          onPressed: () {
                            completeUpdate(
                                'walkin', walkinId, 'paid');
                          },
                          child: const Text(
                            'Complete',
                            style: TextStyle(color: Colors.white),
                          )),
                    ))
                    : const SizedBox.shrink()
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorStyle.tertiary,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5)),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width *
                                    .40,
                                20)),
                        onPressed: () {
                          paymentUpdate('walkin', walkinId);
                        },
                        child: const Text(
                          'Paid',
                          style: TextStyle(color: Colors.white),
                        )),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: ColorStyle.tertiary,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(5)),
                            fixedSize: Size(
                                MediaQuery.of(context).size.width *
                                    .40,
                                20)),
                        onPressed: () {
                          completeUpdate(
                              'walkin', walkinId, 'notpaid');
                        },
                        child: const Text(
                          'Complete',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Pick-up'),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                  leading: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
                  ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const TabBar(
                      indicatorColor: ColorStyle.primary,
                      labelColor: ColorStyle.tertiary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Bookings'),
                        Tab(text: 'Walk-in'),
                      ],
                    ),
                  ),
                )
              ),
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              )));
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
                title: const Text('Pick-up'),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const TabBar(
                      indicatorColor: ColorStyle.primary,
                      labelColor: ColorStyle.tertiary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Bookings'),
                        Tab(text: 'Walk-in'),
                      ],
                    ),
                  ),
                )
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
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Name ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              Map book = bookings[index] as Map;
                              bool isCancelled = book['deleted_at'] != null &&
                                  book['Status'] == '0';
                              bool isPending = book['Status'] == '4';
                              String status = '';
                              Color? color;

                              if (isCancelled) {
                                status = 'Cancelled';
                                color = Colors.red;
                              } else {
                                switch (book['Status']) {
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
                                  onTap: () {
                                    _bottomModalBookings(
                                        '${book['CustomerName']}',
                                        '${book['CustomerContactNumber']}',
                                        '${book['LoadWeight']}',
                                        '${book['CustomerLoad']}',
                                        '${book['Schedule']}',
                                        '${book['PaymentStatus']}',
                                        '${book['ServiceName']}',
                                        '${book['BookingID']}',
                                        '${book['CustomerImage']}',
                                        '${book['CustomerAddress']}',
                                        isPending);
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            '${book['CustomerName']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(
                                              child: Text(
                                                  '${book['CustomerLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No Pickups Process Yet'),
                  ),
            hasWalkin
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            color: ColorStyle.tertiary,
                            padding: const EdgeInsets.all(8),
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Contact ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: walkins.length,
                            itemBuilder: (context, index) {
                              Map walk = walkins[index] as Map;
                              bool isCancelled = walk['deleted_at'] != null &&
                                  walk['Status'] == '0';
                              bool isPending = walk['Status'] == '4';
                              String status = '';
                              Color? color;

                              if (isCancelled) {
                                status = 'Cancelled';
                                color = Colors.red;
                              } else {
                                switch (walk['Status']) {
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
                                  onTap: () {
                                    _bottomModalWalkins(
                                        '${walk['ContactNumber']}',
                                        '${walk['WalkinLoad']}',
                                        '${walk['Total']}',
                                        '${walk['DateIssued']}',
                                        '${walk['PaymentStatus']}',
                                        '${walk['ServiceName']}',
                                        '${walk['WalkinID']}',
                                        isCancelled,
                                        isPending);
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            '${walk['ContactNumber']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(
                                              child: Text(
                                                  '${walk['WalkinLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No Pickups Process Yet'),
                  )
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
  Map home = {};
  Map appbar = {};
  bool hasWalkin = false;
  bool hasBook = false;
  bool isLoading = true;

  List<dynamic> bookings = [];
  List<dynamic> walkins = [];

  void getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        token = prefs.getString('token');
        userid = prefs.getInt('userid');
        shopid = prefs.getInt('shopid');
      });
    dryDisplay();
  }

  Future<void> dryDisplay() async {
    ApiResponse response = await getComplete(token.toString());

    if (response.error == null) {
      setState(() {
        bookings = response.data as List<dynamic>;
        walkins = response.data1 as List<dynamic>;
        hasBook = bookings.isNotEmpty;
        hasWalkin = walkins.isNotEmpty;
        isLoading = false;
      });
    } else {
    }
  }

  Future<void> paymentUpdate(String type, String id) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          );
        });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response =
        await updatePayment(type, id, '${prefs.getString('token')}');

    if(!mounted) return;
    Navigator.pop(context);

    if (response.error == null) {
      if(!mounted) return;
      await successDialog(context, '${response.data}');
      if(!mounted) return;
      Navigator.pop(context);

        getUser();

    } else {
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalBookings(
      String name, String contact, String load, String total, String date,
      String payment, String service, String bookingId, String customerImage, String customerAddress
      ) {
    bool isPaid = payment == 'paid';

    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 32,
                      color: ColorStyle.tertiary,
                    ),
                    Text(
                      ' Laundry Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ProfilePicture(
                          name: name,
                          fontsize: 14,
                          radius: 18,
                          img: customerImage == 'null' || customerImage == null
                              ? null
                              : '$picaddress/$customerImage',
                        ),
                        title: Text(name),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              customerAddress,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contact Information',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    contact,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date Requested',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    date,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Service Availed',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    service,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment Status',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    payment,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Payment',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '₱$total.00',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Laundry Weight',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      '$load kg/s',
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                )
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _bottomModalWalkins(
      String contact, String load, String total, String date, String payment,
      String service, String walkinId) {
    bool isPaid = payment == 'paid';
    showMaterialModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
        builder: (context) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .5,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.directions_walk_outlined,
                        size: 32,
                        color: ColorStyle.tertiary,
                      ),
                      Text(
                        ' Laundry Details',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Contact Information',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      contact,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Date Requested',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      date,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 0),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RowItem(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Service Availed',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      service,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                description: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Payment Status',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    Text(
                                      payment,
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              RowItem(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Total Payment',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        '₱$total.00',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  description: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Laundry Weight',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        '$load kg/s',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )
                              )
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return DefaultTabController(
          length: 2,
          child: Scaffold(
              appBar: AppBar(
                title: const Text('Completed'),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                  leading: IconButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
                  ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const TabBar(
                      indicatorColor: ColorStyle.primary,
                      labelColor: ColorStyle.tertiary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Bookings'),
                        Tab(text: 'Walk-in'),
                      ],
                    ),
                  ),
                )
              ),
              body: Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colors.black,
                  size: 50,
                ),
              )));
    }
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
                title: const Text('Completed'),
                titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Container(
                    color: Colors.grey.shade200,
                    child: const TabBar(
                      indicatorColor: ColorStyle.primary,
                      labelColor: ColorStyle.tertiary,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(text: 'Bookings'),
                        Tab(text: 'Walk-in'),
                      ],
                    ),
                  ),
                )
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
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Name ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: bookings.length,
                            itemBuilder: (context, index) {
                              Map book = bookings[index] as Map;
                              bool isCancelled = book['deleted_at'] != null &&
                                  book['Status'] == '0';
                              bool isPickup = book['Status'] == '4';
                              String status = '';
                              Color? color;

                              if (isCancelled) {
                                status = 'Cancelled';
                                color = Colors.red;
                              } else {
                                switch (book['Status']) {
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
                                  onTap: () {
                                    _bottomModalBookings(
                                        '${book['CustomerName']}',
                                        '${book['CustomerContactNumber']}',
                                        '${book['CustomerLoad']}',
                                        '${book['LoadCost']}',
                                        '${book['Schedule']}',
                                        '${book['PaymentStatus']}',
                                        '${book['ServiceName']}',
                                        '${book['BookingID']}',
                                        '${book['CustomerImage']}',
                                        '${book['CustomerAddress']}');
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            '${book['CustomerName']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(
                                              child: Text(
                                                  '${book['CustomerLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No Completed Process Yet'),
                  ),
            hasWalkin
                ? SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            color: ColorStyle.tertiary,
                            padding: const EdgeInsets.all(8),
                            child: const Row(
                              children: [
                                Expanded(
                                    child: Text('Contact ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text('Load',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white))),
                                Expanded(
                                    child: Text(
                                  'Status',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                  textAlign: TextAlign.center,
                                )),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: walkins.length,
                            itemBuilder: (context, index) {
                              Map walk = walkins[index] as Map;
                              bool isCancelled = walk['deleted_at'] != null &&
                                  walk['Status'] == '0';
                              bool isComplete = walk['Status'] == '5';
                              String status = '';
                              Color? color;

                              if (isCancelled) {
                                status = 'Cancelled';
                                color = Colors.red;
                              } else {
                                switch (walk['Status']) {
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
                                  onTap: () {
                                    _bottomModalWalkins(
                                        '${walk['ContactNumber']}',
                                        '${walk['WalkinLoad']}',
                                        '${walk['Total']}',
                                        '${walk['DateIssued']}',
                                        '${walk['PaymentStatus']}',
                                        '${walk['ServiceName']}',
                                        '${walk['WalkinID']}',);
                                  },
                                  child: Ink(
                                    color: Colors.white,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey.shade300)),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            '${walk['ContactNumber']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Expanded(
                                              child: Text(
                                                  '${walk['WalkinLoad']} kg.',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold))),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              status,
                                              style: TextStyle(
                                                  color: color,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No Completed Process Yet'),
                  )
          ],
        ),
      ),
    );
  }
}
