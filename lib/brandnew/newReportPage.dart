

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/ConstWidgets.dart';
import 'package:capstone/brandnew/dialogs.dart';
import 'package:capstone/brandnew/newAuditLogPage.dart';
import 'package:capstone/brandnew/newChartPage.dart';
import 'package:capstone/brandnew/newReportRatingPage.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({super.key});

  @override
  State<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'Report'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewReportRatingScreen()));
              },
              child: Ink(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: RowItem(
                    title: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.yellowAccent.shade400,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.star,color: Colors.white,),
                        ),
                        const Text(' Shop Rating',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    description: const Icon(CupertinoIcons.chevron_forward)
                ),
              ),
            ),
            const SizedBox(height: 10,),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NewChartScreen()));
              },
              child: Ink(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: RowItem(
                    title: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.bar_chart,color: Colors.white,),
                        ),
                        const Text(' Dashboard',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    description: const Icon(CupertinoIcons.chevron_forward)
                ),
              ),
            ),
            const SizedBox(height: 10,),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ServiceListScreen()));
              },
              child: Ink(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: RowItem(
                    title: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.list_alt,color: Colors.white,),
                        ),
                        const Text(' All Transactions',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    description: const Icon(CupertinoIcons.chevron_forward)
                ),
              ),
            ),
            const SizedBox(height: 10,),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const UserLogScreen()));
              },
              child: Ink(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: RowItem(
                    title: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.cyan,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.people_alt,color: Colors.white,),
                        ),
                        const Text(' User Log',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    description: const Icon(CupertinoIcons.chevron_forward)
                ),
              ),
            ),
            const SizedBox(height: 10,),

            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const InventoryLogScreen()));
              },
              child: Ink(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                ),
                child: RowItem(
                    title: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.brown,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(Icons.inventory,color: Colors.white,),
                        ),
                        const Text(' Inventory Log',style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),)
                      ],
                    ),
                    description: const Icon(CupertinoIcons.chevron_forward)
                ),
              ),
            ),
            const SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}


class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({super.key});

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  List<DateTime?> _pickDate1 = []; List<DateTime?> _pickDate2 = []; String dateRange1 = ''; String dateRange2 = '';
  String page = ''; bool isBook = true; bool hasData = false; bool isloading = true;

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

  Future<void> reportDisplay() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getReport(page, '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        report = response.data as List<dynamic>;
        hasData = report.isNotEmpty;
        isloading = false;
      });
    }else{
      if(!mounted) return;
      await errorDialog(context, '${response.error}');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: backAppBar(context, 'All Transactions'),
      ),
      body: isloading
          ? loading()
          : hasData ? SingleChildScrollView(
        padding: const EdgeInsets.all(4),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            ToggleSwitch(
              minWidth: 100,
              minHeight: 30,
              animationDuration: 800,
              cornerRadius: 5.0,
              activeBgColors: const [[ColorStyle.tertiary], [ColorStyle.tertiary]],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.white,
              inactiveFgColor: ColorStyle.tertiary,
              initialLabelIndex: page == '' ? 0 : int.parse(page),
              totalSwitches: 2,
              labels: const ['Bookings', 'Walk-in'],
              customTextStyles: const [
                TextStyle(
                    fontWeight: FontWeight.bold),
              ],
              radiusStyle: true,
              onToggle: (index) {
                page = index.toString();
                reportDisplay();
              },
            ),
            const SizedBox(height: 10,),
            Container(
              decoration: const BoxDecoration(
                color: ColorStyle.tertiary,
                borderRadius: BorderRadius.vertical(top: Radius.circular(5))
              ),
              padding: const EdgeInsets.all(4),
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
                constraints: const BoxConstraints(
                  maxHeight: 400
                ),
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

                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(page == '0' ? '${rep['DateIssued']}' :'${rep['DateIssued']}')
                                  ),
                                  Expanded(
                                      child: Text(page == '1' ? '${rep['WalkinLoad']} kg/s' :'${rep['CustomerLoad']} kg/s')
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
      )
          : const Center(child: Text('No Record Found'),),
    );
  }
}



