import 'dart:math';

import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:capstone/api_response.dart';
import 'package:capstone/brandnew/setWidget/appbar.dart';
import 'package:capstone/services/services.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:capstone/styles/signupStyle.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

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
  late MyData _data;
  bool isBook = true;

  @override
  void initState() {
    super.initState();
    _data = MyData();
    _data._fetchData(
      startDate: dateRange1,
      endDate: dateRange2,
      status: stat ?? '',
      type: type ?? '',
    );
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
  String? stat;
  String? forstat;
  String? type;

  void datepick1() async {
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

  void datepick2() async {
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: const ForAppBar(
        title: Text('Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: const BorderSide(color: Colors.black),
                      fixedSize: const Size(100, 20),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                    ),
                    onPressed: datepick1,
                    child: Text(
                      dateRange1.isEmpty ? 'Start Date' : dateRange1,
                      style: const TextStyle(color: ColorStyle.tertiary),
                    ),
                  ),
                  const SizedBox(width: 5),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      side: const BorderSide(color: Colors.black),
                      fixedSize: const Size(100, 20),
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                    ),
                    onPressed: datepick2,
                    child: Text(
                      dateRange2.isEmpty ? 'End Date' : dateRange2,
                      style: const TextStyle(color: ColorStyle.tertiary),
                    ),
                  ),
                  const SizedBox(width: 5),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Status',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorStyle.tertiary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: status
                          .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ColorStyle.tertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                          .toList(),
                      value: stat,
                      onChanged: (String? value) {
                        switch(value){
                          case 'Pending':
                            forstat = '0';
                            break;
                        case 'Washing':
                            forstat = '1';
                            break;
                        case 'Drying':
                            forstat = '2';
                            break;
                        case 'Folding':
                            forstat = '3';
                            break;
                        case 'Pickup':
                            forstat = '4';
                            break;
                        default:
                            forstat = '5';
                            break;
                        }
                        setState(() {
                          stat = value;
                          forstat;
                          print(forstat);
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        width: 120,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Colors.black,
                          ),
                          color: Colors.white,
                        ),
                        elevation: 2,
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        iconEnabledColor: ColorStyle.tertiary,
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Booked',
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorStyle.tertiary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      items: types
                          .map((String item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: const TextStyle(
                            fontSize: 14,
                            color: ColorStyle.tertiary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ))
                          .toList(),
                      value: type,
                      onChanged: (String? value) {
                        setState(() {
                          type = value;
                          isBook = !isBook;
                          _data.isBook = !_data.isBook;
                          _data.toggleIsBook();
                          _data._fetchData(
                            startDate: dateRange1,
                            endDate: dateRange2,
                            status: forstat ?? '',
                            type: type ?? '',
                          );
                        });
                      },
                      buttonStyleData: ButtonStyleData(
                        width: 120,
                        padding: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                      ),
                      iconStyleData: const IconStyleData(
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        iconEnabledColor: ColorStyle.tertiary,
                        iconDisabledColor: Colors.grey,
                      ),
                      dropdownStyleData: DropdownStyleData(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorStyle.tertiary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      fixedSize: const Size(80, 20),
                      padding: const EdgeInsets.all(0),
                    ),
                    onPressed: () {
                      _data._fetchData(
                        startDate: dateRange1,
                        endDate: dateRange2,
                        status: forstat ?? '',
                        type: type ?? '',
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.filter_alt_sharp, color: Colors.white),
                        Text(
                          'Filter',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              PaginatedDataTable(
                columns: isBook
                    ? const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Contact Number')),
                  DataColumn(label: Text('Load')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Payment Status')),
                  DataColumn(label: Text('Service Availed')),
                ]
                    : const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Contact Number')),
                  DataColumn(label: Text('Load')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Payment Status')),
                  DataColumn(label: Text('Service Availed')),
                ],
                source: _data,
                header: Text(
                  isBook ? 'Bookings' : 'Walk-in',
                  textAlign: TextAlign.center,
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

class MyData extends DataTableSource {
  List<dynamic> _laundry = [];
  bool isBook = true;
  String dateWalk = '';
  MyData();



  void toggleIsBook() {
    isBook == !isBook;
    notifyListeners();
  }

  Future<void> _fetchData({
    required String startDate,
    required String endDate,
    required String status,
    required String type,
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getReport(
      startDate,
      endDate,
      status,
      type,
      '${prefs.getString('token')}',
    );

    if (response.error == null) {
      _laundry = response.data as List<dynamic>;
      notifyListeners();
      print(_laundry);
    } else {
      print(response.error);
    }
  }

  @override
  DataRow? getRow(int index) {
    Map _laun = _laundry[index] as Map;
    String? stat;
    switch(_laun['Status']){
      case '0':
        stat = 'Pending';
        break;
      case '1':
        stat = 'Washing';
        break;
      case '2':
        stat = 'Drying';
        break;
      case '3':
        stat = 'Folding';
        break;
      case '4':
        stat = 'Pick-up';
        break;
      default:
        stat = 'Complete';
        break;
    }
    return DataRow(
      cells: isBook
          ? [
        DataCell(Text('${_laun['Schedule']}')),
        DataCell(Text('${_laun['CustomerName']}')),
        DataCell(Text('${_laun['CustomerContactNumber']}')),
        DataCell(Text('${_laun['CustomerLoad']}')),
        DataCell(Text('${_laun['LoadCost']}')),
        DataCell(Text(stat)),
        DataCell(Text('${_laun['PaymentStatus']}')),
        DataCell(Text('${_laun['ServiceName']}')),
      ]
          : [
        DataCell(Text('${_laun['DateIssued']}')),
        DataCell(Text('${_laun['ContactNumber']}')),
        DataCell(Text('${_laun['WalkinLoad']}')),
        DataCell(Text('${_laun['Total']}')),
        DataCell(Text(stat)),
        DataCell(Text('${_laun['PaymentStatus']}')),
        DataCell(Text('${_laun['ServiceName']}')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _laundry.length;

  @override
  int get selectedRowCount => 0;
}

