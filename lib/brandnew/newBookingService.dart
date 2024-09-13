import 'dart:ui';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/setWidget/appbar.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/invStyle.dart';
import 'package:capstone/styles/loginStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/signupStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForRegisteredScreen extends StatefulWidget {
  const ForRegisteredScreen({super.key});

  @override
  State<ForRegisteredScreen> createState() => _ForRegisteredScreenState();
}

class _ForRegisteredScreenState extends State<ForRegisteredScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _load = TextEditingController();
  List<dynamic> customer = []; String? customerName;
  List<dynamic> service = []; String? serviceName;
  List<dynamic> inventory = []; String? detergent;

  String? serviceType;
  String serviceCost = '';
  bool hasData = false;
  bool isLoading = true;
  List<DateTime?> date = [];
  String chosenDate = '';
  String schedule = '';




  Future<void> settingsDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getInfos('${prefs.getString('token')}');
    ApiResponse settingRes = await getInventory('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        service = response.data1 as List<dynamic>;
        inventory = settingRes.data as List<dynamic>;
        isLoading = false;
      });
    }else{

    }
  }

  Future<void> customerDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getCustomers('${prefs.get('token')}');

    if(response.error == null){
      customer = response.data as List<dynamic>;
    }else{
      errorDialog(context, '${response.error}');
    }
  }

  Future<void> datepick1() async {
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
    });
  }

  TimeOfDay selectedTime = TimeOfDay.now();

  String _timeOfDayTo24HourString(BuildContext context, TimeOfDay time) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return localizations.formatTimeOfDay(time, alwaysUse24HourFormat: true);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  Future<void> registeredAdd() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await addBookings(
        _load.text, schedule,
        customerName.toString(), serviceName.toString(),
        '${prefs.getString('token')}');

    if(response.error == null){
      successDialog(context, '${response.data}');
    }else{
      errorDialog(context, '${response.error}');
    }
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
      appBar: const ForAppBar(
        title: Text('Book Service'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Customer',
                  style: SignupStyle.formTitle,
                ),
                const SizedBox(height: 5,),
                DropdownButtonFormField<String>(
                  decoration: SignupStyle.allForm,
                  hint: const Text('Choose Customer'),
                  value: customerName,
                  items: customer.map<DropdownMenuItem<String>>((dynamic customer){
                    return DropdownMenuItem<String>(
                        value: customer['CustomerID'].toString(),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage('$picaddress/${customer['Image']}'),
                            ),
                            Text('${customer['Name']}')
                          ],
                        )
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      customerName = newValue;
                      print(customerName);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required.';
                    }
                    return null;
                  },
                ),

                const Text(
                  'Laundry Load',
                  style: LoginStyle.formTitle,
                ),
                const SizedBox(height: 5,),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _load,
                  decoration: LoginStyle.emailForm,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Field is required';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15,),

                const Text(
                  'Schedule',
                  style: LoginStyle.formTitle,
                ),
                const SizedBox(height: 5,),
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height *.075),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: BorderSide(style: BorderStyle.solid, width: 2),
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      backgroundColor: Colors.white
                    ),
                    onPressed: ()async{
                      await datepick1();
                      _selectTime(context);
                      setState(() {
                        schedule = '$chosenDate ${_timeOfDayTo24HourString(context, selectedTime)}';
                      });
                    },
                    child: Align(alignment: Alignment.centerLeft,
                      child: Text(schedule.isEmpty ? 'Select Schedule' : schedule, style: TextStyle(fontSize: 16, color: Colors.black54),),)
                ),

                const SizedBox(height: 15,),
                const Text(
                  'Service',
                  style: SignupStyle.formTitle,
                ),
                const SizedBox(height: 5,),
                DropdownButtonFormField<String>(
                  decoration: SignupStyle.allForm,
                  hint: const Text('Choose Service'),
                  value: serviceName,
                  items: service.map<DropdownMenuItem<String>>((dynamic service){
                    return DropdownMenuItem<String>(
                        value: service['ServiceID'].toString(),
                        child: Text('${service['ServiceName']}')
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      serviceName = newValue;
                      print(serviceName);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required.';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15,),
                const Text(
                  'Detergent',
                  style: SignupStyle.formTitle,
                ),
                const SizedBox(height: 5,),
                DropdownButtonFormField<String>(
                  decoration: SignupStyle.allForm,
                  hint: const Text('Choose Detergent'),
                  value: detergent,
                  items: inventory.map<DropdownMenuItem<String>>((dynamic inventory){
                    return DropdownMenuItem<String>(
                        value: inventory['InventoryID'].toString(),
                        child: Text('${inventory['ItemName']}'),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      detergent = newValue;
                      print(detergent);
                    });
                  },
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'This field is required.';
                    }
                    return null;
                  },
                ),
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
            registeredAdd();
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contact = TextEditingController();
  String serviceType = '';
  String serviceName = '';
  String serviceCost = '';
  String detergent = '';
  int _load = 0;
  bool hasData = false;
  bool isLoading = true;
  int multiply = 0;
  int loadPrice = 0;

  List<dynamic> service = [];
  List<dynamic> inventory = [];

  Future<void> walkinAdd() async{

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
    final SharedPreferences pref = await SharedPreferences.getInstance();

    ApiResponse apiResponse = await addWalkin(
        _contact.text, _load.toString(),
        serviceType,'${pref.getString('token')}'
    );

    Navigator.pop(context);

    if(apiResponse.error == null){
      await successDialog(context, '${apiResponse.data}');

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      Navigator.pop(context);
      errorDialog(context, '${apiResponse.error}');
      print(apiResponse.error);
    }
  }

  Future<void> settingsDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getInfos('${prefs.getString('token')}');
    ApiResponse settingRes = await getInventory('${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        service = response.data1 as List<dynamic>;
        inventory = settingRes.data as List<dynamic>;
        isLoading = false;
      });
    }else{

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


  void _bottomModalConfirmation(){
    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
              top: Radius.circular(25)
          )
      ),
      builder: (context) => SizedBox(
        height: 300,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              const Text(
                'Review Information',
                style: LoginStyle.modalTitle,
              ),
              const SizedBox(height: 20,),
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RowItem(title: Text('Contact Number', style: InvStyle.modalSubTitle,),
                          description: Text(_contact.text,style: const TextStyle(fontWeight: FontWeight.bold))),
                      RowItem(title: Text('Laundry Load', style: InvStyle.modalSubTitle),
                          description: Text('$_load', style: const TextStyle(fontWeight: FontWeight.bold))),
                      RowItem(title: Text('Laundry Service', style: InvStyle.modalSubTitle),
                          description: Text(serviceName, style: const TextStyle(fontWeight: FontWeight.bold))),
                      RowItem(title: Text('Total Cost', style: InvStyle.modalSubTitle),
                          description: Text(serviceCost, style: const TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  )
              ),
              Expanded(child: Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)
                        ),
                        fixedSize: Size(150, 20)
                      ),
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel', style: TextStyle(color: Colors.white),),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          fixedSize: Size(150, 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5)
                          )
                      ),
                      onPressed: (){
                        walkinAdd();
                      },
                      child: const Text('Proceed', style: TextStyle(color: Colors.white),),
                    ),
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Scaffold(
          appBar: const ForAppBar(
            title: Text('Book Service'),
          ),
          body: Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.black,
              size: 50,
            ),
          )
      );
    }
    return Scaffold(
      appBar: const ForAppBar(
        title: Text('Book Service'),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Contact Number',
                    style: LoginStyle.formTitle,
                  ),
                  const SizedBox(height: 5,),
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

                  const Text(
                    'Select Laundry Service',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: service.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index){
                              Map serve = service[index] as Map;
                              List image = [
                                'assets/sport-wear.png',
                                'assets/jacket.png',
                                'assets/bed-sheets.png'
                              ];
                              bool costing = _load > serve['LoadWeight'];
                              multiply = (_load/serve['LoadWeight']).floor();
                              if(multiply < 2 && _load !=0){
                                multiply = 1;
                              }

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)
                                      ),
                                      backgroundColor: Colors.white,
                                      side: BorderSide(
                                              color: serviceType == '${serve['ServiceID']}' ? ColorStyle.tertiary
                                                  : Colors.white
                                      )
                                    ),
                                    onPressed: ()async{
                                      setState(() {
                                        serviceType = '${serve['ServiceID']}';
                                        serviceName = '${serve['ServiceName']}';
                                        serviceCost = '${serve['LoadPrice'] * multiply}';
                                        multiply;
                                      });
                                    },
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset(
                                            image[index],
                                            width: 32,
                                            height: 32,
                                            color: serviceType == '${serve['ServiceID']}'
                                                    ? ColorStyle.tertiary
                                                    : Colors.black,
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(
                                          '${serve['ServiceName']}',
                                          style: TextStyle(
                                            color: serviceType == '${serve['ServiceID']}'
                                                ? ColorStyle.tertiary
                                                : Colors.black
                                          ),
                                          overflow: TextOverflow.clip,
                                        )
                                      ],
                                    )
                                ),
                              );
                            }
                        ),
                      ),
                  const SizedBox(height: 15,),
                  RowItem(
                    title: const Text('Laundry Load (kg)',style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    description: InputQty.int(
                      maxVal: 100,
                      initVal: 0,
                      minVal: 0,
                      steps: 1,
                      onQtyChanged: (val) {

                        setState(() {
                          _load = val;
                          multiply;
                          serviceCost;
                          print('multiply $multiply');
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 15,),
                  const Divider(),


                ],
              ),
            )
        ),
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
            print('load: $serviceType');
            if(_contact.text.isEmpty || _load == 0 || serviceType == ''){
               errorDialog(context, 'Please provide value in all fields');
            }else{
              _bottomModalConfirmation();
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

