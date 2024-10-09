
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:date_picker_plus/date_picker_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewServiceBookingScreen extends StatefulWidget {
  final String shopId;
  const NewServiceBookingScreen({super.key, required this.shopId});

  @override
  State<NewServiceBookingScreen> createState() => _NewServiceBookingScreenState();
}

class _NewServiceBookingScreenState extends State<NewServiceBookingScreen> {
  List<dynamic> services = [];
  int? serviceId;
  String pickedDate = '';
  DateTime? dateSelected;
  bool isLoading = true;
  int total = 0;
  String load = '';
  String shopid = '';

  Future<void> datePicker() async{
    final date = await showDatePickerDialog(
      context: context,
      minDate: DateTime(2024),
      maxDate: DateTime(2100),
      initialDate: pickedDate == '' ? DateTime.now() : dateSelected,
      currentDate: pickedDate == '' ? DateTime.now() : dateSelected,
      slidersColor: ColorStyle.tertiary,
      highlightColor: ColorStyle.tertiary,
    );
    setState(() {
      pickedDate = DateFormat('yyyy-MM-dd').format(date!);
      dateSelected = DateTime.parse(pickedDate);
    });
  }

  Future<void> serviceSelection() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await selectService(widget.shopId, '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        services = response.data as List<dynamic>;
        isLoading = false;
      });
    }else{

    }
  }

  Future<void> serviceAvail() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await availService(
        load, '$total', pickedDate,
        shopid, '$serviceId', '${prefs.get('token')}');

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.popUntil(context, (route) => route.isFirst);
    }else{
      await warningTextDialog(context, 'Service Unavailable', '${response.error}');
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
  void initState(){
    super.initState();
    serviceSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avail Service'),
        titleTextStyle: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
      ),
      body: isLoading
          ? loading()
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: ColorStyle.tertiary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                  ),
                  child: const Text('Select Laundry Service',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
              ),
              ListView.builder(
                  itemCount: services.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                    Map serve = services[index] as Map;
                    List icon = [
                      'assets/sport-wear.png',
                      'assets/jacket.png',
                      'assets/bed-sheets.png'
                    ];
                    return Padding(
                      padding: const EdgeInsets.all(0),
                      child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                          ),
                          child: Column(
                            children: [
                              const Divider(height: 0,),
                              ListTile(
                                contentPadding: const EdgeInsets.all(8),
                                onTap: (){
                                  setState(() {
                                    serviceId = serve['ServiceID'];
                                    total = serve['LoadPrice'];
                                    shopid = '${serve['ShopID']}';
                                    load = '${serve['LoadWeight']}';
                                  });
                                },
                                leading: Image.asset(icon[index],color: ColorStyle.tertiary,),
                                title: Text('${serve['ServiceName']}'),
                                titleTextStyle: const TextStyle(fontSize: 14,color: Colors.black),
                                subtitle: Text('₱${serve['LoadPrice']}.00/${serve['LoadWeight']} kg.'),
                                subtitleTextStyle: const TextStyle(color: ColorStyle.tertiary),
                                trailing: Radio(
                                  value: serve['ServiceID'],
                                  activeColor: ColorStyle.tertiary,
                                  groupValue: serviceId,
                                  onChanged: (value) {
                                    setState(() {
                                      serviceId = value;
                                      total = serve['LoadPrice'];
                                      shopid = '${serve['ShopID']}';
                                      load = '${serve['LoadWeight']}';
                                    });
                                  },
                                ),
                              ),
                            ],
                          )
                      ),
                    );
                  }
              ),
              const SizedBox(height: 10,),

              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: ColorStyle.tertiary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                    child: const Text(
                      'Select Date',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),

                  ConstrainedBox(
                    constraints: const BoxConstraints.tightFor(
                      width: double.infinity,
                      height: 40,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                          ),
                          side: const BorderSide(color: ColorStyle.tertiary),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.all(8)
                      ),
                      onPressed: () {
                        datePicker();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: ColorStyle.tertiary,
                          ),
                          pickedDate == ''
                              ? const SizedBox.shrink()
                              : Text(pickedDate,style: const TextStyle(color: Colors.black),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30,),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0,2),
                      blurRadius: 2,
                      color: Colors.grey
                    )
                  ]
                ),
                child: RowItem(
                    title: const Text('Estimated Cost:', style: TextStyle(fontSize: 18),),
                    description: Text('₱$total.00', style: const TextStyle(color: ColorStyle.tertiary,fontSize: 22,fontWeight: FontWeight.bold),)
                ),
              ),
              const SizedBox(height: 15,),
              const Text(
                  'Note: Cost of the service is based on the weight of the laundry loads. The total amount to be paid will be determined upon dropping off your laundry at the shop.',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.blue
                ),
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorStyle.tertiary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(0)
          ),
          onPressed: (){
            if(serviceId == null || total == 0 || pickedDate == ''){
              warningDialog(context, 'Please fill up the form');
            }else if(dateSelected!.isBefore(DateTime.now().subtract(const Duration(days: 1)))){
              warningTextDialog(context, 'Invalid Date', 'The date you\'ve selected is in the past. Please select another date.');
            }else{
              serviceAvail();
            }
          },
          child: const Text('Place Laundry Service',style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
