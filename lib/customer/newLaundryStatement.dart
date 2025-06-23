import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewLaundryStatementScreen extends StatefulWidget {
  final String bookId;
  const NewLaundryStatementScreen({super.key, required this.bookId});

  @override
  State<NewLaundryStatementScreen> createState() => _NewLaundryStatementScreenState();
}

class _NewLaundryStatementScreenState extends State<NewLaundryStatementScreen> {
  List<dynamic> summary = []; List<dynamic> timeline = [];
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
      await errorDialog(context, '${response.error}');
    }
  }
  @override
  void initState() {
    summaryDisplay();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laundry Statement'),
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
        child:  Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                    blurRadius: .5,
                    offset: Offset(0, 0)
                )
              ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: ColorStyle.tertiary,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                ),
                child: const Text(
                  'Laundry Service Details',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
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
                        description: Text('${summ['CustomerLoad']} kg', style: const TextStyle(fontWeight: FontWeight.bold),)
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
