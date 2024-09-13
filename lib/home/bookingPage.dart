import 'dart:ui';

import 'package:capstone/api_response.dart';
import 'package:capstone/drawer/ownerDrawer.dart';
import 'package:capstone/services/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int pendingCount = 0;
  int processCount = 0;
  int finishedCount = 0;
  bool isLoading = true;
  String? token;
  int? userid;
  int? shopid;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
    });

    pendingBookingsCount();
    processBookingsCount();
    finishedBookingsCount();
  }

  Future<void> pendingBookingsCount() async{
    ApiResponse apiResponse = await getPendingBookingCount(token.toString());

    if(apiResponse.error == null){
      setState(() {
        pendingCount = apiResponse.total!;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('${apiResponse.error}');
    }
  }

  Future<void> processBookingsCount() async{
    ApiResponse apiResponse = await getProcessBookingCount(token.toString());

    if(apiResponse.error == null){
      setState(() {
        processCount = apiResponse.total!;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('${apiResponse.error}');
    }
  }

  Future<void> finishedBookingsCount() async{
    ApiResponse apiResponse = await getFinishedBookingCount(token.toString());

    if(apiResponse.error == null){
      setState(() {
        finishedCount = apiResponse.total!;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('${apiResponse.error}');
    }
  }

  @override
  void initState(){
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                    elevation: 8,
                    shadowColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                      child: SizedBox(
                        height: 150,
                        width: 350,
                        child: InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const PendingBookingScreen()))
                            .then((_) => getUser());
                          },
                          borderRadius: BorderRadius.circular(10),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Pending\nBookings',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  height: 260,
                                  width: 125,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color(0xFFA7E6FF),
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)
                                      )
                                  ),
                                  child: Text(
                                    '${pendingCount}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 42
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ),
                    ),
                Card(
                  elevation: 8,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: SizedBox(
                      height: 150,
                      width: 350,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ProcessBookingScreen()))
                              .then((_) => getUser());
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'On-Process\nBookings',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 260,
                                width: 125,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(0xFFA7E6FF),
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                                ),
                                child: Text(
                                  '${processCount}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 42
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                ),
                Card(
                  elevation: 8,
                  shadowColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Container(
                      height: 150,
                      width: 350,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FinishedBookingScreen()))
                              .then((_) => getUser());
                        },
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Finished\nBookings',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                height: 260,
                                width: 125,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Color(0xFFA7E6FF),
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10))
                                ),
                                child: Text(
                                  '${finishedCount}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 42
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                )
              ],
            ),
          ],
        ),
    );
  }
}

class PendingBookingScreen extends StatefulWidget {
  const PendingBookingScreen({super.key});

  @override
  State<PendingBookingScreen> createState() => _PendingBookingScreenState();
}

class _PendingBookingScreenState extends State<PendingBookingScreen> {
  List<dynamic> pending = [];
  List<bool> expanded = [];
  List<dynamic> detergent = [];
  bool isLoading = true;
  String? token;
  int? userid;
  int? shopid;
  bool hasData = false;
  bool disable = true;
  String status = '';


  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
      pendingBookingsDisplay();
      detergentChoiceDisplay();
    });
  }

  Future<void> pendingBookingsDisplay() async{
    ApiResponse apiResponse = await getPendingBooking(token.toString());

    if(apiResponse.error == null){
      setState(() {
        pending = apiResponse.data as List<dynamic>;
        expanded = List.generate(pending.length, (index) => false);
        isLoading = false;
        hasData = pending.isNotEmpty;
      });
    } else {
      setState(() {
        isLoading = false;
        hasData = false;
      });
      print('${apiResponse.error}');
    }
  }

  Future<void> pendingBookingUpdate(String id, String stat, String detergentid) async{
    ApiResponse apiResponse = await pendingBookingStatus(
        id, stat,
        detergentid, token.toString()
    );

    if(apiResponse.error == null){
      setState(() {
        pendingBookingsDisplay();
      });
    }else{
      print(apiResponse.error);
    }
    if(apiResponse.status == '0'){
      _warningSnackbar();
    }else if(apiResponse.message == 'full'){
      _fullSnackbar();
    }
    else if(apiResponse.message == 'empty'){
      _detergentSnackbar();
    }

  }
  
  Future<void> detergentChoiceDisplay() async{
    ApiResponse apiResponse = await getInventory(token.toString());

    if(apiResponse.error == null){
      setState(() {
        detergent = apiResponse.data as List<dynamic>;
      });
    } else {
      print('${apiResponse.error}');
    }
  }

  void _warningSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Machine is currently occupied!',
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  void _fullSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Maximum Book Occupied for Today!',
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  void _detergentSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Detergent is Empty!',
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  void detergentChoiceDialog(String bookingID, String pendingStat){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return Container(
            alignment: Alignment.center,
            height: 100,
            child: AlertDialog(
              title: Text(
                  'Inventory',
                style: TextStyle(),
                textAlign: TextAlign.center,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              ),
              content: SizedBox(
                height: 300,
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: detergent.length,
                      itemBuilder: (context, index){
                        Map deter = detergent[index] as Map;

                        bool hasQuantity = deter['ItemQty'] != 0;
                        print(pendingStat);

                        return Card(
                            margin: EdgeInsets.all(10),
                            color: hasQuantity ? Color(0xFFE3F3FF) : Colors.grey,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)
                            ),
                            elevation: 8,
                            shadowColor: Colors.black,
                            child: InkWell(
                              onTap: hasQuantity ? ()
                              {
                                pendingBookingUpdate(bookingID.toString(), pendingStat.toString(), '${deter['InventoryID']}');
                                Navigator.pop(context);
                              } : null,
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height: 50,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(width: 10,),
                                    Text(
                                      '${index + 1}. ',
                                      style: TextStyle(
                                          fontSize: 24,
                                          color: Color(0xFF597FaF),
                                          fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '${deter['ItemName']}',
                                        style: TextStyle(
                                            fontSize: 24,
                                            color: Color(0xFF597FaF),
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(left: 20),
                                          child: Row(
                                            children: [
                                              VerticalDivider(
                                                color: Colors.grey,
                                                thickness: 2,
                                              ),
                                              Text(
                                                '${deter['ItemQty']}',
                                                style: TextStyle(
                                                    fontSize: 24,
                                                    color: Color(0xFF597FaF),
                                                    fontWeight: FontWeight.bold
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        )
                                    )
                                  ],
                                ),
                              ),
                            )
                        );
                      }
                  ),
                ),
              ),
              ),
          );
        }
    );
  }

  @override
  void initState(){
    super.initState();
    getUser();
    expanded = List.generate(pending.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Scaffold(
          appBar: AppBar(
            title: Text('Bookings'),
          ),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          )
      );
    }

    if(hasData == false){
      return Scaffold(
          appBar: AppBar(
            title: Text('Bookings'),
          ),
          body: const Center(
              child: Text(
                  'There\'s no pending laundry at the moment.'
              )
          )
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bookings',
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: pending.length,
                  itemBuilder: (context, index){
                    Map book = pending[index] as Map;


                    return Card(
                        margin: EdgeInsets.all(20),
                        elevation: 10,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: InkWell(
                          onTap: (){
                            setState(() {
                              expanded[index] = !expanded[index];
                              print(expanded[index]);
                            });
                          },
                          child: AnimatedContainer(
                              height: expanded[index] ? 500: 200,
                              width: double.infinity,
                              curve: Curves.linear,
                              padding: EdgeInsets.all(10),
                              duration: Duration(
                                  milliseconds: 300
                              ),
                              child: Builder(
                                  builder: (BuildContext context){
                                    if (expanded[index] == false){
                                      return Column(
                                        children: [
                                          Text(
                                            '${book['Name']}',
                                            style: const TextStyle(
                                                color: Color(0xFF4A5667),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${book['ContactNumber']}',
                                            style: TextStyle(
                                                color: Color(0xFF4A5667),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          const Text(
                                            'On-Queue',
                                            style: TextStyle(
                                                color: Color(0xFF4A5667),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24
                                            ),
                                          ),

                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Date\n${book['DateIssued']}',
                                                  style: TextStyle(
                                                      fontSize: 16
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  'Time\n${book['TimeIssued']}',
                                                  style: TextStyle(
                                                      fontSize: 16
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ),

                                        ],
                                      );
                                    }
                                    else{
                                      return Column(
                                        children: [
                                          Text(
                                            '${book['Name']}',
                                            style: TextStyle(
                                                color: Color(0xFF4A5667),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            '${book['ContactNumber']}',
                                            style: TextStyle(
                                                color: Color(0xFF4A5667),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24
                                            ),
                                          ),
                                          SizedBox(height: 20,),
                                          Text(
                                            'On-Queue',
                                            style: TextStyle(
                                                color: Color(0xFF4A5667),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24
                                            ),
                                          ),

                                          SizedBox(height: 20,),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Laundry Load: ${book['CustomerLoad']}kgs.',
                                                  style: TextStyle(
                                                      color: Color(0xFF4A5667),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Laundry Preference:',
                                                  style: TextStyle(
                                                      color: Color(0xFF4A5667),
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 24
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    'Wash:',
                                                    style: TextStyle(
                                                        fontSize: 24
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: 50,
                                                    width: 200,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    child: Text(
                                                      '${book['WashingPref']}'.toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),

                                          Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Text(
                                                    'Dry:',
                                                    style: TextStyle(
                                                        fontSize: 24
                                                    ),
                                                  ),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    height: 50,
                                                    width: 200,
                                                    margin: EdgeInsets.only(left: 15),
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius: BorderRadius.circular(20)
                                                    ),
                                                    child: Text(
                                                      '${book['DryingPref']} TEMP'.toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  )
                                                ],
                                              )
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.red,
                                                      elevation: 5,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                      )
                                                  ),
                                                  onPressed: (){
                                                    setState(() {

                                                    });
                                                  },
                                                  child: const Text(
                                                    'Decline',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                              ),
                                              ElevatedButton(
                                                  style:ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.green,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(10)
                                                      )
                                                  ),
                                                  onPressed: (){
                                                    detergentChoiceDialog('${book['BookingID']}', 1.toString());

                                                  },
                                                  child: const Text(
                                                    'Accept',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                              )
                                            ],
                                          ),


                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  'Date\n${book['DateIssued']}',
                                                  style: TextStyle(
                                                      fontSize: 16
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  'Time\n${book['TimeIssued']}',
                                                  style: TextStyle(
                                                      fontSize: 16
                                                  ),
                                                  textAlign: TextAlign.center,
                                                )
                                              ],
                                            ),
                                          ),

                                        ],
                                      );
                                    }
                                  }
                              )

                          ),
                        )
                    );
                  }
              )
            ],
          )
        )
    );
  }
}

class ProcessBookingScreen extends StatefulWidget {
  const ProcessBookingScreen({super.key});

  @override
  State<ProcessBookingScreen> createState() => _ProcessBookingScreenState();
}

class _ProcessBookingScreenState extends State<ProcessBookingScreen> {
  List<dynamic> process = [];
  List<bool> expanded = [];
  bool isLoading = true;
  String stat = '';
  int update = 0;
  String? token;
  int? userid;
  int? shopid;
  bool hasData = false;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
      processBookingsDisplay();
    });
  }

  Future<void> processBookingsDisplay() async{
    ApiResponse apiResponse = await getProcessBooking(token.toString());

    if(apiResponse.error == null){
      setState(() {
        process = apiResponse.data as List<dynamic>;
        expanded = List.generate(process.length, (index) => false);
        isLoading = false;
        hasData = process.isNotEmpty;
      });
    } else {
      setState(() {
        isLoading = false;
        hasData = false;
      });
      print('${apiResponse.error}');
    }
  }

  Future<void> processBookingUpdate(String id, String stat) async{
    ApiResponse apiResponse = await processBookingStatus(
        id, stat, token.toString()
    );



    if(apiResponse.error == null){
      setState(() {
        processBookingsDisplay();
      });
    }else{
      print(apiResponse.error);
    }

    if(apiResponse.status == '0'){
      _warningSnackbar();
    }

    if(apiResponse.status == '2'){
      _sentSnackBar();
    }
  }

  void _warningSnackbar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.error(
          message: 'Machine is currently occupied!',
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }

  void _sentSnackBar(){
    showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.success(
          message: 'Customer has been notified!',
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontWeight: FontWeight.bold
          ),
        )
    );
  }
  @override
  void initState(){
    super.initState();
    getUser();
    expanded = List.generate(process.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    print(hasData);
    if(isLoading){
      return Scaffold(
          appBar: AppBar(
            title: Text('Bookings'),
          ),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          )
      );
    }

    if(hasData == false){
      return Scaffold(
          appBar: AppBar(
            title: Text('Bookings'),
          ),
          body: const Center(
              child: Text(
                  'There\'s no current laundry processing at the moment'
              )
          )
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Bookings',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [

                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: process.length,
                    itemBuilder: (context, index){
                      Map book = process[index] as Map;

                      if('${book['Status']}' == '1'){
                          stat = 'washing';
                      }else if('${book['Status']}' == '2'){
                        stat = 'drying';
                      }else if('${book['Status']}' == '3'){
                        stat = 'folding';
                      }else if('${book['Status']}' == '4'){
                        stat = 'Pickup';
                      }


                      return Card(
                          margin: EdgeInsets.all(20),
                          elevation: 10,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                expanded[index] = !expanded[index];
                                print(expanded[index]);
                              });
                            },
                            child: AnimatedContainer(
                                height: expanded[index] ? 500: 200,
                                width: double.infinity,
                                curve: Curves.linear,
                                padding: EdgeInsets.all(10),
                                duration: Duration(
                                    milliseconds: 300
                                ),
                                child: Builder(
                                    builder: (BuildContext context){
                                      if (expanded[index] == false){
                                        return Column(
                                          children: [
                                            Text(
                                              '${book['Name']}',
                                              style: const TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${book['ContactNumber']}',
                                              style: TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                             Text(
                                              stat.toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                            ),

                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Date\n${book['DateIssued']}',
                                                    style: TextStyle(
                                                        fontSize: 16
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    'Time\n${book['TimeIssued']}',
                                                    style: TextStyle(
                                                        fontSize: 16
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),

                                          ],
                                        );
                                      }
                                      else{
                                        return Column(
                                          children: [
                                            Text(
                                              '${book['Name']}',
                                              style: TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${book['ContactNumber']}',
                                              style: TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            Text(
                                              stat.toUpperCase(),
                                              style: TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                            ),

                                            SizedBox(height: 20,),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Laundry Load: ${book['CustomerLoad']}kgs.',
                                                    style: TextStyle(
                                                        color: Color(0xFF4A5667),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Laundry Preference:',
                                                    style: TextStyle(
                                                        color: Color(0xFF4A5667),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      'Wash:',
                                                      style: TextStyle(
                                                          fontSize: 24
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      height: 50,
                                                      width: 200,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius: BorderRadius.circular(20)
                                                      ),
                                                      child: Text(
                                                        '${book['WashingPref']}'.toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),

                                            Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      'Dry:',
                                                      style: TextStyle(
                                                          fontSize: 24
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      height: 50,
                                                      width: 200,
                                                      margin: EdgeInsets.only(left: 15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius: BorderRadius.circular(20)
                                                      ),
                                                      child: Text(
                                                        '${book['DryingPref']} TEMP'.toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),

                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(5)
                                                  ),
                                                ),
                                                onPressed: (){
                                                  update = int.parse('${book['Status']}')+ 1;
                                                  setState(() {
                                                    processBookingUpdate('${book['BookingID']}', update.toString());
                                                  });
                                                },
                                                child: const Text(
                                                  'Update',
                                                  style: TextStyle(
                                                    color: Colors.white
                                                  ),
                                                )
                                            ),

                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Date\n${book['DateIssued']}',
                                                    style: TextStyle(
                                                        fontSize: 16
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    'Time\n${book['TimeIssued']}',
                                                    style: TextStyle(
                                                        fontSize: 16
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),

                                          ],
                                        );
                                      }
                                    }
                                )

                            ),
                          )
                      );
                    }
                )
              ],
            )
        )
    );
  }
}

class FinishedBookingScreen extends StatefulWidget {
  const FinishedBookingScreen({super.key});

  @override
  State<FinishedBookingScreen> createState() => _FinishedBookingScreenState();
}

class _FinishedBookingScreenState extends State<FinishedBookingScreen> {
  List<dynamic> finished = [];
  List<bool> expanded = [];
  bool isLoading = true;
  String? token;
  int? userid;
  int? shopid;
  bool hasData = false;

  void getUser() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token');
      userid = prefs.getInt('userid');
      shopid = prefs.getInt('shopid');
      finishedBookingsDisplay();
    });
  }

  Future<void> finishedBookingsDisplay() async{
    ApiResponse apiResponse = await getFinishedBooking(token.toString());

    if(apiResponse.error == null){
      setState(() {
        finished = apiResponse.data as List<dynamic>;
        expanded = List.generate(finished.length, (index) => false);
        isLoading = false;
        hasData = finished.isNotEmpty;
      });
    } else {
      setState(() {
        isLoading = false;
        hasData = false;
      });
      print('${apiResponse.error}');
    }
  }

  @override
  void initState(){
    super.initState();
    getUser();
    expanded = List.generate(finished.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Scaffold(
          appBar: AppBar(
            title: Text('Bookings'),
          ),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          )
      );
    }

    if(hasData == false){
      return Scaffold(
          appBar: AppBar(
            title: Text('Bookings'),
          ),
          body: const Center(
              child: Text(
                  'There\'s no booked laundry finished.'
              )
          )
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Bookings',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              children: [

                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: finished.length,
                    itemBuilder: (context, index){
                      Map book = finished[index] as Map;

                      return Card(
                          margin: EdgeInsets.all(20),
                          elevation: 10,
                          shadowColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)
                          ),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                expanded[index] = !expanded[index];
                                print(expanded[index]);
                              });
                            },
                            child: AnimatedContainer(
                                height: expanded[index] ? 500: 200,
                                width: double.infinity,
                                curve: Curves.linear,
                                padding: EdgeInsets.all(10),
                                duration: Duration(
                                    milliseconds: 300
                                ),
                                child: Builder(
                                    builder: (BuildContext context){
                                      if (expanded[index] == false){
                                        return Column(
                                          children: [
                                            Text(
                                              '${book['Name']}',
                                              style: const TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${book['ContactNumber']}',
                                              style: TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            Text(
                                              'Complete',
                                              style: TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                            ),

                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Date\n${book['DateIssued']}',
                                                    style: TextStyle(
                                                        fontSize: 16
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    'Time\n${book['TimeIssued']}',
                                                    style: TextStyle(
                                                        fontSize: 16
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),

                                          ],
                                        );
                                      }else{
                                        return Column(
                                          children: [
                                            Text(
                                              '${book['Name']}',
                                              style: TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${book['ContactNumber']}',
                                              style: TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            Text(
                                              'Complete',
                                              style: TextStyle(
                                                  color: Color(0xFF4A5667),
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24
                                              ),
                                            ),

                                            SizedBox(height: 20,),
                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    'Laundry Load: ${book['CustomerLoad']}kgs.',
                                                    style: TextStyle(
                                                        color: Color(0xFF4A5667),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Padding(
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Laundry Preference:',
                                                    style: TextStyle(
                                                        color: Color(0xFF4A5667),
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 24
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      'Wash:',
                                                      style: TextStyle(
                                                          fontSize: 24
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      height: 50,
                                                      width: 200,
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius: BorderRadius.circular(20)
                                                      ),
                                                      child: Text(
                                                        '${book['WashingPref']}'.toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),

                                            Expanded(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Text(
                                                      'Dry:',
                                                      style: TextStyle(
                                                          fontSize: 24
                                                      ),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      height: 50,
                                                      width: 200,
                                                      margin: EdgeInsets.only(left: 15),
                                                      decoration: BoxDecoration(
                                                          color: Colors.grey,
                                                          borderRadius: BorderRadius.circular(20)
                                                      ),
                                                      child: Text(
                                                        '${book['DryingPref']} TEMP'.toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight: FontWeight.bold
                                                        ),
                                                        textAlign: TextAlign.center,
                                                      ),
                                                    )
                                                  ],
                                                )
                                            ),

                                            Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Date\n${book['DateIssued']}',
                                                    style: TextStyle(
                                                        fontSize: 16
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    'Time\n${book['TimeIssued']}',
                                                    style: TextStyle(
                                                        fontSize: 16
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  )
                                                ],
                                              ),
                                            ),

                                          ],
                                        );
                                      }
                                    }
                                )

                            ),
                          )
                      );
                    }
                )
              ],
            )
        )
    );
  }
}