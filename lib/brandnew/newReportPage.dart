

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({super.key});

  @override
  State<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  List<DateTime?> _pickDate1 = [];
  List<DateTime?> _pickDate2 = [];
  String dateRange1 = '';
  String dateRange2 = '';

  bool isBook = true;

  @override
  void initState() {
    reportDisplay();
    super.initState();
  }

  final List<String> status = [
    'Pending',
    'Washing',
    'Drying',
    'Folding',
    'Pickup',
    'Complete',
  ];
  final List<String> types = [
    'Booked',
    'Walkin',
  ];

  final List<String> service = [
    'Light Load',
    'Heavy Load',
    'Comforter Load'
  ];
  String? selectedService;
  String? selectedType;
  String stat = '';
  String? forstat;
  String type = '';
  int serviceCount = 0;
  double serviceLoad = 0;

  List<dynamic> report = [];

  Future<void> datepick1() async {
    var pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(),
      dialogSize: const Size(325, 400),
      value: _pickDate1, // Initial value passed to the picker
      borderRadius: BorderRadius.circular(15),
    );
    setState(() {
      _pickDate1 = pickedDates!;
      dateRange1 = DateFormat('yyyy-MM-dd').format(_pickDate1[0]!);
    });
  }

  Future<void> datepick2() async {
    var pickedDates = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(),
      dialogSize: const Size(325, 400),
      value: _pickDate2, // Initial value passed to the picker
      borderRadius: BorderRadius.circular(15),
    );
    setState(() {
      _pickDate2 = pickedDates!;
      dateRange2 = DateFormat('yyyy-MM-dd').format(_pickDate2[0]!);
    });
  }

  void filter(){
    AwesomeDialog(
      context: context,
      animType: AnimType.topSlide,
      dialogType: DialogType.noHeader,
      title: 'Filter',
      body: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Column(
            children: [
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  side: const BorderSide(color: ColorStyle.tertiary),
                  fixedSize: Size(MediaQuery.of(context).size.width, 20),
                ),
                onPressed: () async {
                  await datepick1();
                  setState(() {
                    dateRange1 = dateRange1;
                  });
                },
                child: Text(
                  dateRange1 == '' ? 'Start Date (From)' : dateRange1,
                  style: const TextStyle(color: ColorStyle.tertiary),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                  side: const BorderSide(color: ColorStyle.tertiary),
                  fixedSize: Size(MediaQuery.of(context).size.width, 20),
                ),
                onPressed: () async {
                  await datepick2();
                  setState(() {

                    dateRange2 = dateRange2;
                  });
                },
                child: Text(
                  dateRange2 == '' ? 'End Date (To)' : dateRange2,
                  style: const TextStyle(color: ColorStyle.tertiary),
                ),
              ),
              DropdownButton2(
                  items: service.map((String serve) => DropdownMenuItem<String>(
                      value: serve,
                      child: Center(
                        child: Text(
                          serve,
                          style: const TextStyle(
                            color: ColorStyle.tertiary,
                            fontSize: 14
                          ),
                        ),
                      )
                  )).toList(),
                value: selectedService,
                hint: const Text('Select Service',style: TextStyle(color: ColorStyle.tertiary,fontSize: 14),),
                onChanged: (String? value){
                    setState((){
                      selectedService = value;
                    });
                },
                underline: const SizedBox(),
                buttonStyleData: ButtonStyleData(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: ColorStyle.tertiary),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              DropdownButton2(
                items: types.map((String type) => DropdownMenuItem<String>(
                    value: type,
                    child: Center(
                      child: Text(
                        type,
                        style: const TextStyle(
                            color: ColorStyle.tertiary,
                            fontSize: 14
                        ),
                      ),
                    )
                )).toList(),
                value: selectedType,
                hint: const Text('Select Service Type',style: TextStyle(color: ColorStyle.tertiary,fontSize: 14),),
                onChanged: (String? value){
                  setState((){
                    selectedType = value;
                  });
                },
                underline: const SizedBox(),
                buttonStyleData: ButtonStyleData(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: ColorStyle.tertiary),
                  ),
                ),
              )
            ],
          );
        },
      ),
      btnOkOnPress: ()async{
        await reportDisplay();
      },
      btnCancelOnPress: (){

      }
    ).show();

  }

  Future<void> reportDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getReport(dateRange1, dateRange2, selectedService ?? '', selectedType ?? '', '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        report = response.data as List<dynamic>;
        serviceCount =  response.count ?? 0;
        serviceLoad = response.tot ?? 0;
      });
    }else{
      print(response.error);
    }
  }


  @override
  Widget build(BuildContext context) {
    print(report);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
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
        actions: [
          IconButton(
              onPressed: (){
                filter();
              },
              icon: const Icon(Icons.filter_alt_sharp,color: Colors.white,),
            tooltip: 'Filter',
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all()
              ),
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                    children: [
                      Expanded(child: Column(
                        children: [
                          Text('$serviceCount',style: const TextStyle(color: ColorStyle.tertiary, fontSize: 22,fontWeight: FontWeight.bold),),
                          const Text('Total Services Made',style: TextStyle(fontSize: 12),textAlign: TextAlign.center,)
                        ],
                      ),),
                      Expanded(child: Column(
                        children: [
                          Text('${serviceLoad} kg/s',style: const TextStyle(color: ColorStyle.tertiary, fontSize: 22,fontWeight: FontWeight.bold),),
                          const Text('Total Laundry Load', style: TextStyle(fontSize: 12),textAlign: TextAlign.center,)
                        ],
                      ))
                    ],
                  ),
            ),
            const SizedBox(height: 10,),
            Container(
              color: ColorStyle.tertiary,
              padding: const EdgeInsets.all(8),
              child: const Row(
                children: [
                  Expanded(
                    child: Text('Date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                    ),
                  ),
                  Expanded(
                    child: Text('Load',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                    ),
                  ),
                  Expanded(
                    child: Text('Service Availed',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white)
                    ),
                  ),
                ],
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height * .5,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(5)),
                    color: Colors.white
                ),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: report.length,
                    itemBuilder: (context, index){
                      Map rep = report[index] as Map;

                      return Column(
                        children: [
                          InkWell(
                            onTap: (){
                              print('wrwe');
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(selectedType == 'Walkin' ? '${rep['DateIssued']}' :'${rep['DateIssued']}')
                                  ),
                                  Expanded(
                                      child: Text(selectedType == 'Walkin' ? '${rep['WalkinLoad']} kg/s' :'${rep['CustomerLoad']} kg/s')
                                  ),
                                  Expanded(
                                      child: Text('${rep['ServiceName']}')
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Divider(height: 0,)
                        ],
                      );
                    }
                )
            ),
          ],
        ),
      ),
    );
  }
}



