import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/services/timelineservices.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewNotificationInfoScreen extends StatefulWidget {
  final String bookId;
  final String title;
  final String notifid;
  const NewNotificationInfoScreen({super.key, required this.bookId, required this.title, required this.notifid});

  @override
  State<NewNotificationInfoScreen> createState() => _NewNotificationInfoScreenState();
}

class _NewNotificationInfoScreenState extends State<NewNotificationInfoScreen> {
  List<dynamic> summary = [];
  Map summ = {};
  bool isLoading = true;

   Future<void> summaryDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getSummary(widget.bookId, '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        summary = response.data as List<dynamic>;
        summ = summary[0] as Map;
        isLoading = false;
      });
    }else{
    }
  }

  Future<void> laundryConfirmation(String confirm) async{
     final SharedPreferences prefs = await SharedPreferences.getInstance();
     ApiResponse response = await confirmLaundry(widget.bookId, confirm, widget.notifid,'${prefs.getString('token')}');

     if(response.error == null){
       if(confirm == '1'){
         await successTextDialog(context, 'Laundry Request Confirmed', '${response.data}');
       }else{
         await warningDialog(context, '${response.data}');
       }

       Navigator.pop(context,true);
     }else{
       Navigator.pop(context,true);
     }
  }


  @override
  void initState() {
    super.initState();
    summaryDisplay();
  }

  @override
  Widget build(BuildContext context) {
     print(summ['IsConfirmed']);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Details'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context,true);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),

      ),
      body: Padding(
          padding: const EdgeInsets.all(8),
          child: isLoading
              ? loading()
              : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: ColorStyle.tertiary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                ),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Laundry Shop Owner',style: TextStyle(fontSize: 10)),
                    Text('${summ['OwnerName']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    const SizedBox(height: 5,),
                    const Text('Address',style: TextStyle(fontSize: 10)),
                    Text('${summ['OwnerAddress']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    const SizedBox(height: 5,),
                    const Text('Shop Name',style: TextStyle(fontSize: 10)),
                    Text('${summ['ShopName']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    const SizedBox(height: 5,),
                    const Text('Shop Address',style: TextStyle(fontSize: 10)),
                    Text('${summ['ShopAddress']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),


                    const Divider(),
                    const Text('Customer Name',style: TextStyle(fontSize: 10)),
                    Text('${summ['CustomerName']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    const SizedBox(height: 5,),
                    const Text('Customer Address',style: TextStyle(fontSize: 10)),
                    Text('${summ['CustomerAddress']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    const SizedBox(height: 5,),
                    const Text('Customer Contact',style: TextStyle(fontSize: 10)),
                    Text('${summ['CustomerContactNumber']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    const Divider(height: 30,),

                    const Text('Laundry Details', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    RowItem(
                        title: const Text('Service Availed'),
                        description: Text('${summ['ServiceName']}', style: const TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    RowItem(
                        title: const Text('Laundry Type'),
                        description: Text('${summ['LoadType']}', style: const TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    RowItem(
                        title: const Text('Laundry Load'),
                        description: Text('${summ['CustomerLoad']} kg/s', style: const TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    RowItem(
                        title: const Text('Payment Status'),
                        description: Text('${summ['PaymentStatus']}', style: const TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    RowItem(
                        title: const Text('Date'),
                        description: Text('${summ['Schedule']}', style: const TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    const Divider(),
                    RowItem(
                        title: const Text('Service Fee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                        description: Text('₱${summ['LoadCost']}.00', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              summ['IsConfirmed'] == '1' || summ['deleted_at'] != null
                ? const SizedBox.shrink()
                  : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)
                          ),
                          foregroundColor: ColorStyle.tertiary,
                          side: BorderSide(color: ColorStyle.tertiary)
                      ),
                      onPressed: (){
                        laundryConfirmation('0');
                      },
                      child: const Text('Cancel')
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                        ),
                        foregroundColor:Colors.white,
                        backgroundColor: ColorStyle.tertiary,
                      ),
                      onPressed: (){
                        laundryConfirmation('1');
                      },
                      child: const Text('Confirm')
                  )
                ],
              )
            ],
          ),
      ),
    );
  }
}

class LaundryUpdatesScreen extends StatefulWidget {
  final String title;
  final String bookId;
  const LaundryUpdatesScreen({super.key, required this.title, required this.bookId});

  @override
  State<LaundryUpdatesScreen> createState() => _LaundryUpdatesScreenState();
}

class _LaundryUpdatesScreenState extends State<LaundryUpdatesScreen> {
  List<dynamic> summary = [];
  Map summ = {};
  bool isLoading = true;

  Future<void> summaryDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getSummary(widget.bookId, '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        summary = response.data as List<dynamic>;
        summ = summary[0] as Map;
        isLoading = false;
      });
    }else{
    }
  }

  @override
  void initState() {
    summaryDisplay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.bookId);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Details'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context,true);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),

      ),
      body: isLoading
          ? loading()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Laundry Shop Owner',style: TextStyle(fontSize: 10)),
                      Text('${summ['OwnerName']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                      const SizedBox(height: 5,),
                      const Text('Address',style: TextStyle(fontSize: 10)),
                      Text('${summ['OwnerAddress']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                      const SizedBox(height: 5,),
                      const Text('Shop Name',style: TextStyle(fontSize: 10)),
                      Text('${summ['ShopName']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                      const SizedBox(height: 5,),
                      const Text('Shop Address',style: TextStyle(fontSize: 10)),
                      Text('${summ['ShopAddress']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),


                      const Divider(),
                      const Text('Customer Name',style: TextStyle(fontSize: 10)),
                      Text('${summ['CustomerName']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                      const SizedBox(height: 5,),
                      const Text('Customer Address',style: TextStyle(fontSize: 10)),
                      Text('${summ['CustomerAddress']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                      const SizedBox(height: 5,),
                      const Text('Customer Contact',style: TextStyle(fontSize: 10)),
                      Text('${summ['CustomerContactNumber']}',style: const TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                      const Divider(height: 30,),

                      const Text('Laundry Details', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                      RowItem(
                          title: const Text('Service Availed'),
                          description: Text('${summ['ServiceName']}', style: const TextStyle(fontWeight: FontWeight.bold),)
                      ),
                      RowItem(
                          title: const Text('Laundry Type'),
                          description: Text('${summ['LoadType']}', style: const TextStyle(fontWeight: FontWeight.bold),)
                      ),
                      RowItem(
                          title: const Text('Laundry Load'),
                          description: Text('${summ['CustomerLoad']} kg/s', style: const TextStyle(fontWeight: FontWeight.bold),)
                      ),
                      RowItem(
                          title: const Text('Payment Status'),
                          description: Text('${summ['PaymentStatus']}', style: const TextStyle(fontWeight: FontWeight.bold),)
                      ),
                      RowItem(
                          title: const Text('Date'),
                          description: Text('${summ['Schedule']}', style: const TextStyle(fontWeight: FontWeight.bold),)
                      ),
                      const Divider(),
                      RowItem(
                          title: const Text('Service Fee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                          description: Text('₱${summ['LoadCost']}.00', style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

