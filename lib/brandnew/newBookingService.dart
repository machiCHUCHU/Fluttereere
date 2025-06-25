

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/ConstWidgets.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/model/BookingInfo.dart';
import 'package:capstone/model/WalkinInfo.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/loginStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForRegisteredScreen extends StatefulWidget {
  const ForRegisteredScreen({super.key});

  @override
  State<ForRegisteredScreen> createState() => _ForRegisteredScreenState();
}

class _ForRegisteredScreenState extends State<ForRegisteredScreen> {
  final TextEditingController _load = TextEditingController();
  List<dynamic> customer = []; String? customerId; String? customerName; String customerImage ='';
  Map service = {}; String? serviceName;
  Map inventory = {}; String? detergent;
  String? serviceType; String serviceCost = ''; bool hasData = false; bool isLoading = true;
  List<DateTime?> date = []; String chosenDate = ''; String schedule = ''; int multiplier = 0;
  double weight = 0; int shopWeight = 0; int shopPrice = 0; int total = 0;
  String time = ''; String timeFormatted = '';

  void showTimePickerDialog() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          time = "${selectedTime.hour}:${selectedTime.minute}";
          timeFormatted = selectedTime.format(context);
        });
      } else {

      }
    });
  }


  Future<void> settingsDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getInfos('${prefs.getString('token')}');
    ApiResponse settingRes = await getInventory('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        service = response.data as Map;
        inventory = settingRes.data as Map;
        isLoading = false;
      });
    }else{
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> customerDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getCustomers('${prefs.get('token')}');

    if(response.error == null){
      setState(() {
        customer = response.data as List<dynamic>;
      });
    }else{
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  Future<void> datePick1() async {
    var pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(),
      dialogSize: const Size(325, 400),
      value: date,
      borderRadius: BorderRadius.circular(15),
    );
    setState(() {
      date = pickedDates!;
      chosenDate = DateFormat('yyyy-MM-dd').format(date[0]!);
      schedule = DateFormat('MM-dd-yyyy').format(date[0]!);
    });
  }

  Future<void> registeredAdd() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    BookingInfo info = BookingInfo(
        customerLoad: _load.text, schedule: '$chosenDate $time', customerId: customerId.toString(),
        serviceId: serviceName.toString(), loadCost: total.toString());
    ApiResponse response = await addBookings(info, '${prefs.getString('token')}');

    if(!mounted) return;

    if(response.error == null){
      await successDialog(context, '${response.data}');
      if(!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
    }else{
      await errorDialog(context, '${response.error}');
    }
  }

  void _bottomModalCustomer() {
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25))
      ),
      builder: (BuildContext context) {

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              height: MediaQuery.of(context).size.height * .5,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        'Select Customers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                      ),
                    ),
                  ),
                  const Divider(height: 0,),
                  Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(0),
                        itemCount: customer.length,
                        itemBuilder: (context, index) {
                          Map reg = customer[index] as Map;

                          bool hasImage = reg['CustomerImage'] != null;

                          return InkWell(
                            onTap: () {
                              modalSetState(() {
                                customerId = '${reg['CustomerID']}';
                              });
                              setState(() {
                                customerName = '${reg['CustomerName']}';
                                customerImage = '${reg['CustomerImage']}';
                              });
                            },
                            child: Material(
                              color: customerId == '${reg['CustomerID']}' ? ColorStyle.tertiary : Colors.white,
                              child: ListTile(
                                leading: ProfilePicture(
                                  name: '${reg['CustomerName']}',
                                  radius: 18,
                                  fontsize: 14,
                                  img: hasImage ? '$picaddress/${reg['CustomerImage']}' : null,
                                ),
                                title: Text(
                                  '${reg['CustomerName']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: customerId == '${reg['CustomerID']}' ? Colors.white : ColorStyle.tertiary,
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                subtitle: Text(
                                  '${reg['CustomerAddress']}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: customerId == '${reg['CustomerID']}' ? Colors.white : ColorStyle.tertiary,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }


  @override
  void initState(){
    super.initState();
    customerDisplay();
    settingsDisplay();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Set A Service'),
      ),
      body: isLoading ? loading() : Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,

                ),
                padding: const EdgeInsets.all(4),
                child: const Text(
                    'Select Registered Customer',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )
                ),
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height *.075),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                      ),
                      side: const BorderSide(style: BorderStyle.solid, width: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      backgroundColor: Colors.white
                  ),
                  onPressed: (){
                   _bottomModalCustomer();
                  },
                  child: Align(alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        customerName == null ? const SizedBox.shrink() : ProfilePicture(
                          name: '$customerName',
                          radius: 18,
                          fontsize: 14,
                          img: customerImage != 'null' ? '$picaddress/$customerImage' : null,
                        ),
                        const SizedBox(width: 5,),
                        Text(customerName == null ? 'Select Customer' : customerName.toString(),
                          style: const TextStyle(fontSize: 16, color: ColorStyle.tertiary),),
                      ],
                    )
                  )
              ),
              const SizedBox(height: 15,),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,

                ),
                padding: const EdgeInsets.all(4),
                child: const Text(
                    'Laundry Load (kg)',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _load,
                decoration: LoginStyle.addRegCustomer,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Field is required';
                  }
                  try {
                    weight = double.parse(value);
                  } catch (e) {
                    return 'Invalid number';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      weight = double.parse(value);
                      multiplier = (weight / shopWeight).ceil();
                      total = multiplier * shopPrice;
                    }
                  });
                },
              ),

              const SizedBox(height: 15,),

              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,

                ),
                padding: const EdgeInsets.all(4),
                child: const Text(
                    'Select Date',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )
                ),
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height *.075),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                      ),
                      side: const BorderSide(style: BorderStyle.solid, width: 1),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      backgroundColor: Colors.white
                  ),
                  onPressed: ()async{
                    await datePick1();
                    showTimePickerDialog();

                  },
                  child: Align(alignment: Alignment.centerLeft,
                    child: Text(schedule.isEmpty ? 'Select Schedule' : '$schedule $timeFormatted', style: const TextStyle(fontSize: 16, color: ColorStyle.tertiary),),)
              ),

              const SizedBox(height: 15,),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: ColorStyle.tertiary,
                ),
                padding: const EdgeInsets.all(4),
                child: const Text(
                    'Select Laundry Service',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white
                    )
                ),
              ),
              Container(
                constraints: const BoxConstraints(
                  maxHeight: 200
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey
                    )
                  ]
                ),
                child: ListView.builder(
                    itemCount: service['service'].length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      List<dynamic> services = service['service'] as List<dynamic>;
                      Map serve = services[index] as Map;

                      return Padding(
                        padding: const EdgeInsets.all(0),
                        child: Column(
                              children: [
                                const Divider(height: 0,),
                                ListTile(
                                  contentPadding: const EdgeInsets.all(8),
                                  onTap: (){
                                    setState(() {
                                      serviceName = '${serve['ServiceID']}';
                                      shopWeight = serve['LoadWeight'];
                                      shopPrice = serve['LoadPrice'];
                                      multiplier = (weight / shopWeight).ceil();


                                      total = multiplier * shopPrice;
                                    });
                                  },
                                  leading: const Icon(Icons.local_laundry_service,size: 48, color: ColorStyle.tertiary,),
                                  title: Text('${serve['ServiceName']}'),
                                  titleTextStyle: const TextStyle(fontSize: 14,color: Colors.black),
                                  subtitle: Text('₱${serve['LoadPrice']}.00/${serve['LoadWeight']} kg.'),
                                  subtitleTextStyle: const TextStyle(color: ColorStyle.tertiary),
                                  trailing: Radio(
                                    value: '${serve['ServiceID']}',
                                    activeColor: ColorStyle.tertiary,
                                    groupValue: serviceName,
                                    onChanged: (value) {
                                      setState(() {
                                        serviceName = value;
                                        shopWeight = serve['LoadWeight'];
                                        shopPrice = serve['LoadPrice'];
                                        multiplier = (weight / shopWeight).ceil();


                                        total = multiplier * shopPrice;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            )
                      );
                    }
                ),
              ),
              const SizedBox(height: 15,),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey,
                    )
                  ]
                ),
                padding: const EdgeInsets.all(12),
                child: RowItem(
                    title: const Text('Total Cost',style: TextStyle(fontSize: 14),),
                    description: Text('₱$total.00',style: const TextStyle(fontSize: 22,color: ColorStyle.tertiary),)
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            fixedSize: Size(MediaQuery.of(context).size.width, 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5)
            ),
            backgroundColor: ColorStyle.tertiary
          ),
          onPressed: (){
            if(_load.text.isEmpty || customerName == null || schedule.isEmpty || serviceName == null){
              warningDialog(context, 'Please fill up the form');
            }else{
              if(DateTime.parse(chosenDate).isBefore(DateTime.now().subtract(const Duration(days: 1)))){
                warningTextDialog(context, 'Invalid Date', 'The date you\'ve selected is in the past. Please choose another date');
              }else{
                registeredAdd();
              }
            }
          },
          child: const Text('Submit', style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}

class ForWalkinScreen extends StatefulWidget {
  const ForWalkinScreen({super.key});

  @override
  State<ForWalkinScreen> createState() => _ForWalkinScreenState();
}

class _ForWalkinScreenState extends State<ForWalkinScreen> {
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _load = TextEditingController();
  String serviceType = ''; String? serviceName; String serviceCost = ''; String detergent = '';
  bool hasData = false; bool isLoading = true; int multiplier = 0; double weight = 0;
  int shopWeight = 0; int shopPrice = 0; int total = 0;
  Map service = {}; Map inventory = {};

  Future<void> walkinAdd() async{
    final SharedPreferences pref = await SharedPreferences.getInstance();

    WalkinInfo info = WalkinInfo(
        contact: _contact.text, walkinLoad: _load.text, serviceId: serviceName.toString(), total: total.toString());

    ApiResponse apiResponse = await addWalkin(info,'${pref.getString('token')}');

    if(!mounted) return;

    if(apiResponse.error == null){
      await successDialog(context, '${apiResponse.data}');
      if(!mounted) return;
      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      await errorDialog(context, '${apiResponse.error}');
    }
  }

  Future<void> settingsDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getInfos('${prefs.getString('token')}');
    ApiResponse settingRes = await getInventory('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        service = response.data as Map;
        inventory = settingRes.data as Map;
        isLoading = false;
      });
    }else{
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  @override
  void initState(){
    super.initState();
    settingsDisplay();
  }

  String? serviceError;
  String? validateService(){
    if(serviceType.isEmpty){
      return 'Please select a service.';
    }else{
      return null;
    }
  }

  String? itemError;
  String? validateItem(){
    if(detergent.isEmpty){
      return 'Please select a detergent.';
    }else{
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {

    if(isLoading){
      return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: backAppBar(context, 'Book Service'),
          ),
          body: loading()
      );
    }
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: backAppBar(context, 'Book Service'),
        ),
      body: SingleChildScrollView(
        child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: ColorStyle.tertiary,
                    ),
                    child: const Text(
                      'Contact Number',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      )
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _contact,
                    decoration: LoginStyle.emailForm,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }else if(value.length < 10){
                        return 'Please input a Valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15,),

                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: ColorStyle.tertiary,

                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Text(
                        'Laundry Load (kg)',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )
                    ),
                  ),
                  TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _load,
                    decoration: LoginStyle.addRegCustomer,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Field is required';
                      }
                      try {
                        weight = double.parse(value);
                      } catch (e) {
                        return 'Invalid number';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          weight = double.parse(value);
                          multiplier = (weight / shopWeight).ceil();
                          total = multiplier * shopPrice;
                        }
                      });
                    },
                  ),

                  const SizedBox(height: 15,),
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: ColorStyle.tertiary,

                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Text(
                        'Select Laundry Service',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                        )
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 200
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(5))
                    ),
                    child: ListView.builder(
                        itemCount: service['service'].length,
                        shrinkWrap: true,
                        itemBuilder: (context,index){
                          List<dynamic> services = service['service'] as List<dynamic>;
                          Map serve = services[index] as Map;

                          return Padding(
                              padding: const EdgeInsets.all(0),
                              child: Column(
                                children: [
                                  const Divider(height: 0,),
                                  ListTile(
                                    contentPadding: const EdgeInsets.all(8),
                                    onTap: (){
                                      setState(() {
                                        serviceName = '${serve['ServiceID']}';
                                        shopWeight = serve['LoadWeight'];
                                        shopPrice = serve['LoadPrice'];
                                        multiplier = (weight / shopWeight).ceil();


                                        total = multiplier * shopPrice;
                                      });
                                    },
                                    leading: const Icon(Icons.local_laundry_service,size: 48,color: ColorStyle.tertiary,),
                                    title: Text('${serve['ServiceName']}'),
                                    titleTextStyle: const TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold),
                                    subtitle: Text('₱${serve['LoadPrice']}.00/${serve['LoadWeight']} kg.'),
                                    subtitleTextStyle: const TextStyle(color: ColorStyle.tertiary,fontSize: 12),
                                    trailing: Radio(
                                      value: '${serve['ServiceID']}',
                                      activeColor: ColorStyle.tertiary,
                                      groupValue: serviceName,
                                      onChanged: (value) {
                                        setState(() {
                                          serviceName = value;
                                          shopWeight = serve['LoadWeight'];
                                          shopPrice = serve['LoadPrice'];
                                          multiplier = (weight / shopWeight).ceil();


                                          total = multiplier * shopPrice;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              )
                          );
                        }
                    ),
                  ),
                  const SizedBox(height: 15,),

                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 1,
                              color: Colors.grey,
                          )
                        ]
                    ),
                    padding: const EdgeInsets.all(12),
                    child: RowItem(
                        title: const Text('Total Cost',style: TextStyle(fontSize: 14),),
                        description: Text('₱$total.00',style: const TextStyle(fontSize: 22,color: ColorStyle.tertiary),)
                    ),
                  )


                ],
              ),
            )
        ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: ColorStyle.tertiary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)
              )
          ),
          onPressed: (){
            if(_contact.text.isEmpty || _load.text.isEmpty || serviceName == null){
               warningDialog(context, 'Please fill up the form');
            }else{
              walkinAdd();
            }
          },
          child: const Text(
            'Add to List',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        ),
      )
    );
  }
}
