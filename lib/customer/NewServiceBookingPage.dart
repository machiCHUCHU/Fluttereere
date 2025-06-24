
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewServiceBookingScreen extends StatefulWidget {
  final String shopId;
  const NewServiceBookingScreen({super.key, required this.shopId});

  @override
  State<NewServiceBookingScreen> createState() => _NewServiceBookingScreenState();
}

class _NewServiceBookingScreenState extends State<NewServiceBookingScreen> {
  List<dynamic> services = []; int selectedIndex = 0; int totalPrice = 0;
  int? serviceId; String pickedDate = ''; String pickedDateDisp = ''; List<DateTime?> date = []; String chosenDate = '';
  DateTime? dateSelected; String schedule = ''; String time = ''; String timeformatted = ''; bool isLoading = true;
  int total = 0; String load = ''; String shopid = ''; int? cusId;


  Future<void> datepick1() async {
    var pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        firstDate: DateTime.now()
      ),
      dialogSize: const Size(325, 400),
      value: date,
      borderRadius: BorderRadius.circular(15),

    );
    setState(() {
      date = pickedDates!;
      chosenDate = DateFormat('yyyy-MM-dd').format(date[0]!);
      pickedDateDisp = DateFormat('MM-dd-yyyy').format(date[0]!);
    });
  }

  Future<void> serviceSelection() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await selectService(widget.shopId, '${prefs.getString('token')}');


    if(response.error == null){
      setState(() {
        services = response.data as List<dynamic>;
        cusId = prefs.getInt('customerid');
        isLoading = false;
      });
    }else{
      await errorDialog(context, '${response.error}');
    }
  }


  Future<void> serviceAvail() async{

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context){
          return loading();
        }
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await availService(records,'${prefs.getString('token')}');


    if(response.error == null){
      await successDialog(context, '${response.data}');
      Navigator.popUntil(context, (route) => route.isFirst);
    }else{
      await warningTextDialog(context, 'Service Unavailable', '${response.error}');
    }
  }

  final controller = GroupButtonController();

  void _modalServices(){
    showMaterialModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        builder: (context){
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20)
            ),
            height: MediaQuery.of(context).size.height * .5,
            padding: const EdgeInsets.all(8),
            
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select Laundry Services',style: TextStyle(fontWeight: FontWeight.bold),),
                const Divider(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(0),
                    children: [
                        GroupButton(
                          isRadio: false,
                          controller: controller,
                          onSelected: (selected, index, isSelected) {
                            Map selectedService = services[index];
                            totalPrice = controller.selectedIndexes.fold(0, (sum, selectedIndex) {
                              Map selectedService = services[selectedIndex];
                              return sum + (selectedService['LoadPrice'] as int);
                            });
                            if(isSelected){
                              records.add({
                                'CustomerLoad': '${selectedService['LoadWeight']}',
                                'LoadCost': '${selectedService['LoadPrice']}',
                                'Schedule': '$chosenDate $time',
                                'ShopID':'${selectedService['ShopID']}',
                                'ServiceID':'${selectedService['ServiceID']}'
                              });
                            }else{
                              records.removeWhere((record) => '${record['ServiceID']}' == '${selectedService['ServiceID']}');
                            }
                            setState(() {
                              controller.selectedIndexes;
                              totalPrice;
                            });

                          },
                          buttons: services.map((service) => service['ServiceID'].toString()).toList(),
                          buttonBuilder: (isSelected,value,context){
  
                            int index = services.indexWhere((service) => '${service['ServiceID']}' == value);
                            String serviceoption = ''; String category = '';
  
                            if(services[index]['ServiceType'] == 'full'){
                              serviceoption = 'Full Service';
                            }else{
                              serviceoption = 'Self Service';
                            }
  
                            switch(services[index]['ServiceType']){
                              case 'full':
                                category = 'Full Service';
                                break;
                              case 'wash':
                                category = 'Wash Only';
                                break;
                              case 'dry':
                                category = 'Dry Only';
                                break;
                              default:
                                category = 'Wash-Dry Only';
                                break;
                            }
  
                            return Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Colors.black,width: 2)
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                        color: ColorStyle.tertiary,
                                        borderRadius: BorderRadius.vertical(top: Radius.circular(2)),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: RowItem(
                                            title: Text('${services[index]['ServiceName']}',style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                                            description: Icon(isSelected ? Icons.check_circle : Icons.check_circle_outline,color: Colors.white,)
                                        ),
                                    ),
                                    const Divider(height: 0,),
  
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: RowItem(
                                          title: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Service Option',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                              Text(serviceoption)
                                            ],
                                          ),
                                          description: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Text('Service Category',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                              Text(category)
                                            ],
                                          ),
                                      ),
                                    ),
                                    const SizedBox(height: 5,),
  
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: RowItem(
                                        title: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Load Weight',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                            Text('${services[index]['LoadWeight']} kg')
                                          ],
                                        ),
                                        description: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text('Service Price       ',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                            Text('₱${services[index]['LoadPrice']}')
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Laundry Type',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                          Text('${services[index]['LoadType']} kg')
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 0,),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('Description',style: TextStyle(color: Colors.grey,fontSize: 12),),
                                          Text('${services[index]['Description']} kg')
                                        ],
                                      ),
                                    ),
                                  ],
                                )
  
                              );
                          },
                        )
                    ],
                  ),
                ),
              ],
            ),
          );

        }
    );
  }

  List<Map<String,dynamic>> records = [];

  void add(String name){

    Map<String, dynamic> newRecord = {
      'name': name,
    };

    records.add(newRecord);
}

  void showTimePickerDialog() {
    showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    ).then((selectedTime) {
      if (selectedTime != null) {
        setState(() {
          time = "${selectedTime.hour}:${selectedTime.minute}";
          timeformatted = selectedTime.format(context);
        });
      } else {
      }
    });
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
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
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
                      onPressed: () async{
                        await datepick1();
                        setState(() {
                          schedule = chosenDate;
                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.calendar_month,
                            color: ColorStyle.tertiary,
                          ),
                          schedule.isEmpty
                              ? const SizedBox.shrink()
                              : Text(pickedDateDisp,style: const TextStyle(color: Colors.black),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),

              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: ColorStyle.tertiary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5)),
                    ),
                    child: const Text(
                      'Select Time for Pick-up/Drop-off',
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
                          padding: const EdgeInsets.all(4)
                      ),
                      onPressed: (){
                        showTimePickerDialog();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.timelapse,
                            color: ColorStyle.tertiary,
                          ),
                          time.isEmpty
                              ? const SizedBox.shrink()
                              : Text(timeformatted,style: const TextStyle(color: Colors.black),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20,),

              Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: ColorStyle.tertiary,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(5))
                  ),
                  child: const Text('Select Laundry Service',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),)
              ),
              Container(
                constraints: BoxConstraints(
                  maxHeight: controller.selectedIndexes.isEmpty ? 100 : 300,
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
                width: double.infinity,
                padding: const EdgeInsets.all(4),
                child: Column(
                  children: [
                    controller.selectedIndexes.isEmpty
                        ? const Expanded(child: Center(child: Text('No Service Selected'),))
                        : Expanded(
                      child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.selectedIndexes.length,
                      itemBuilder: (context,index){
                        int selectedIndex = controller.selectedIndexes.elementAt(index);
                        Map service = services[selectedIndex] as Map;
                        totalPrice = controller.selectedIndexes.fold(0, (sum, index) {
                          return sum + (service['LoadPrice'] as int);
                        });


                        return Padding(
                          padding: const EdgeInsets.all(4),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: const [
                                  BoxShadow(
                                      blurRadius: 1,
                                      color: Colors.grey
                                  )
                                ]
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                              leading: Container(
                                decoration: BoxDecoration(
                                    color: ColorStyle.tertiary,
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                padding: const EdgeInsets.all(8),
                                child: const Icon(Icons.local_laundry_service,color: Colors.white,),
                              ),
                              title: Text(service['ServiceName'],style: const TextStyle(color: ColorStyle.tertiary,fontWeight: FontWeight.bold),),
                              subtitle: IntrinsicHeight(
                                child: Row(
                                  children: [
                                    Text(service['ServiceType'], style: const TextStyle(fontSize: 12),),
                                    const VerticalDivider(width: 5,color: Colors.black,),
                                    Text(service['ServiceOffer'], style: const TextStyle(fontSize: 12),)
                                  ],
                                ),
                              ),
                              trailing: Text('₱${service['LoadPrice']}',style: const TextStyle(fontSize: 18,color: ColorStyle.tertiary),),
                            ),
                          ),
                        );
                      },
                    ),
                    ),
                    const Divider(),
                    RowItem(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total: ',style: TextStyle(fontSize: 14,color: ColorStyle.tertiary,fontWeight: FontWeight.bold),),
                            Text('₱$totalPrice',
                              style: const TextStyle(fontSize: 20,color: ColorStyle.tertiary,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        description: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: ColorStyle.tertiary,
                                foregroundColor: Colors.white,
                                fixedSize: Size(MediaQuery.of(context).size.width *.4, 20)
                            ),
                            onPressed: (){
                              if(chosenDate.isEmpty || time.isEmpty){
                                warningTextDialog(context, 'Select a Schedule', 'Please select a schedule '
                                    'first');
                              }else{
                                _modalServices();
                              }
                            },
                            child: const Text('Select Service')
                        )
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      blurRadius: 1,
                      color: Colors.grey
                    )
                  ]
                ),
                padding: const EdgeInsets.all(8),
                child: const Text(
                  'Notes:\n'
                  '- Please have your laundry prepared for drop-off/pick-up before the set time you\'ve selected.'
                      ' Otherwise, your laundry request will be cancelled.',
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.blue
                  ),
                  textAlign: TextAlign.justify,
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
            backgroundColor: ColorStyle.tertiary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(0)
          ),
          onPressed: (){
            if(chosenDate.isEmpty || controller.selectedIndexes.isEmpty){
              warningDialog(context, 'Please fill up the form');
            }else if(DateTime.parse(chosenDate).isBefore(DateTime.now().subtract(const Duration(days: 1)))){
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
