import 'package:capstone/api_response.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewNotificationInfoScreen extends StatefulWidget {
  final String bookId;
  final String title;
  const NewNotificationInfoScreen({super.key, required this.bookId, required this.title});

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
      print(response.error);
    }
  }

  Center loading(){
    return Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: Colors.black,
        size: 50,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    summaryDisplay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Details'),
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
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
                decoration: BoxDecoration(
                    color: ColorStyle.tertiary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                ),
                child: Text(
                  '${widget.title}',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
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
                    Text('${summ['OwnerName']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    const SizedBox(height: 5,),
                    const Text('Address',style: TextStyle(fontSize: 10)),
                    Text('${summ['OwnerAddress']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    const SizedBox(height: 5,),
                    const Text('Shop Name',style: TextStyle(fontSize: 10)),
                    Text('${summ['ShopName']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    const SizedBox(height: 5,),
                    const Text('Shop Address',style: TextStyle(fontSize: 10)),
                    Text('${summ['ShopAddress']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),


                    const Divider(),
                    const Text('Customer Name',style: TextStyle(fontSize: 10)),
                    Text('${summ['CustomerName']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    const SizedBox(height: 5,),
                    const Text('Customer Address',style: TextStyle(fontSize: 10)),
                    Text('${summ['CustomerAddress']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),

                    const SizedBox(height: 5,),
                    const Text('Customer Contact',style: TextStyle(fontSize: 10)),
                    Text('${summ['CustomerContactNumber']}',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),),
                    const Divider(height: 30,),

                    const Text('Laundry Details', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    RowItem(
                        title: const Text('Service Availed'),
                        description: Text('${summ['ServiceName']}', style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    RowItem(
                        title: const Text('Laundry Load'),
                        description: Text('${summ['CustomerLoad']} kg/s', style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    RowItem(
                        title: const Text('Payment Status'),
                        description: Text('${summ['PaymentStatus']}', style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    RowItem(
                        title: const Text('Date'),
                        description: Text('${summ['Schedule']}', style: TextStyle(fontWeight: FontWeight.bold),)
                    ),
                    const Divider(),
                    RowItem(
                        title: const Text('Service Fee', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                        description: Text('₱${summ['LoadCost']}.00', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),)
                    )
                  ],
                ),
              )
            ],
          ),
      ),
    );
  }
}
