
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/loginStyle.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
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
  List<dynamic> customer = []; String? customerId; String? customerName; String customerImage ='';
  List<dynamic> service = []; String? serviceName;
  List<dynamic> inventory = []; String? detergent;

  String? serviceType;
  String serviceCost = '';
  bool hasData = false;
  bool isLoading = true;
  List<DateTime?> date = [];
  String chosenDate = '';
  String schedule = '';
  bool isloading = true;
  int multiplier = 0;
  double weight = 0;
  int shopweight = 0;
  int shopprice = 0;
  int total = 0;




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
      setState(() {
        customer = response.data as List<dynamic>;
      });
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

  Future<void> registeredAdd() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await addBookings(
        _load.text, schedule,
        customerId.toString(), serviceName.toString(),
        total.toString(),
        '${prefs.getString('token')}');

    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.popUntil(context, (route) => route.isFirst);
    }else{
      errorDialog(context, '${response.error}');
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

  void _bottomModalCustomer() {
    showMaterialModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
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
                              print(customerImage);
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
    print(customerImage == 'null');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Set a Service'),
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18
        ),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
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
                      multiplier = (weight / shopweight).ceil();
                      total = multiplier * shopprice;
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
                    await datepick1();
                    setState(() {
                      schedule = '$chosenDate';
                    });
                  },
                  child: Align(alignment: Alignment.centerLeft,
                    child: Text(schedule.isEmpty ? 'Select Schedule' : schedule, style: const TextStyle(fontSize: 16, color: ColorStyle.tertiary),),)
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
              ListView.builder(
                  itemCount: service.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index){
                    Map serve = service[index] as Map;
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
                                    serviceName = '${serve['ServiceID']}';
                                    shopweight = serve['LoadWeight'];
                                    shopprice = serve['LoadPrice'];
                                    multiplier = (weight / shopweight).ceil();


                                    total = multiplier * shopprice;
                                  });
                                },
                                leading: Image.asset(icon[index],color: ColorStyle.tertiary,),
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
                                      shopweight = serve['LoadWeight'];
                                      shopprice = serve['LoadPrice'];
                                      multiplier = (weight / shopweight).ceil();


                                      total = multiplier * shopprice;
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
              const SizedBox(height: 15,),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 2,
                      color: Colors.grey,
                      offset: Offset(0, 22)
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _load = TextEditingController();
  String serviceType = '';
  String? serviceName;
  String serviceCost = '';
  String detergent = '';
  bool hasData = false;
  bool isLoading = true;
  int multiplier = 0;
  double weight = 0;
  int shopweight = 0;
  int shopprice = 0;
  int total = 0;

  List<dynamic> service = [];
  List<dynamic> inventory = [];

  Future<void> walkinAdd() async{

    /*showDialog(
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
    );*/
    final SharedPreferences pref = await SharedPreferences.getInstance();

    ApiResponse apiResponse = await addWalkin(
        _contact.text, _load.text
        ,
        serviceName.toString(),total.toString(),'${pref.getString('token')}'
    );


    if(apiResponse.error == null){
      await successDialog(context, '${apiResponse.data}');

      Navigator.popUntil(context, (route) => route.isFirst);
    } else {
      errorDialog(context, '${apiResponse.error}');
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


  /*void _bottomModalConfirmation(){
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
                          description: Text(_load.text, style: const TextStyle(fontWeight: FontWeight.bold))),
                      RowItem(title: Text('Laundry Service', style: InvStyle.modalSubTitle),
                          description: Text(serviceName!, style: const TextStyle(fontWeight: FontWeight.bold))),
                      RowItem(title: Text('Total Cost', style: InvStyle.modalSubTitle),
                          description: Text('₱$total.00', style: const TextStyle(fontWeight: FontWeight.bold))),
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
  }*/

  @override
  Widget build(BuildContext context) {
    if(isLoading){
      return Scaffold(
          appBar: AppBar(
            title: const Text('Book Service'),
            titleTextStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            leading: IconButton(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
            ),
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
      appBar: AppBar(
        title: const Text('Book Service'),
        titleTextStyle: const TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(CupertinoIcons.chevron_left,color: Colors.white,),
        ),
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
                          multiplier = (weight / shopweight).ceil();
                          total = multiplier * shopprice;
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
                  ListView.builder(
                      itemCount: service.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context,index){
                        Map serve = service[index] as Map;
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
                                        serviceName = '${serve['ServiceID']}';
                                        shopweight = serve['LoadWeight'];
                                        shopprice = serve['LoadPrice'];
                                        multiplier = (weight / shopweight).ceil();


                                        total = multiplier * shopprice;
                                      });
                                    },
                                    leading: Image.asset(icon[index],color: ColorStyle.tertiary,),
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
                                          shopweight = serve['LoadWeight'];
                                          shopprice = serve['LoadPrice'];
                                          multiplier = (weight / shopweight).ceil();


                                          total = multiplier * shopprice;
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
                  const SizedBox(height: 15,),

                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 2,
                              color: Colors.grey,
                              offset: Offset(0, 2)
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

class Customer {
  final String name;
  final String address;

  Customer({required this.name, required this.address});
}