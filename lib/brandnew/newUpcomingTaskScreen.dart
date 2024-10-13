import 'package:capstone/api_response.dart';
import 'package:capstone/connect/laravel.dart';
import 'package:capstone/services/servicesadd.dart';
import 'package:capstone/styles/mainColorStyle.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:row_item/row_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewUpcomingTaskScreen extends StatefulWidget {
  const NewUpcomingTaskScreen({super.key});

  @override
  State<NewUpcomingTaskScreen> createState() => _NewUpcomingTaskScreenState();
}

class _NewUpcomingTaskScreenState extends State<NewUpcomingTaskScreen> {
  DateTime? _selectedDate; String _dateString = '';
  List<dynamic> upTask = [];

  Future<void> displayTask() async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    ApiResponse response = await getUpcomingTask(_dateString, '${prefs.getString('token')}');

    if(response.error == null){
      setState(() {
        upTask = response.data as List<dynamic>;
      });
    }else{
      print(response.error);
    }
  }

  void _bottomModalBookings(
      String name, String contact, String load, String total, String date,
      String payment, String service, String customerImage, String customerAddress) {


    showMaterialModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * .5,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.book,
                      size: 32,
                      color: ColorStyle.tertiary,
                    ),
                    Text(
                      ' Laundry Details',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const Divider(height: 0),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        leading: ProfilePicture(
                          name: name,
                          fontsize: 14,
                          radius: 18,
                          img: customerImage == 'null' || customerImage == null
                              ? null
                              : '$picaddress/$customerImage',
                        ),
                        title: Text(name),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Address',
                              style: TextStyle(color: Colors.grey),
                            ),
                            Text(
                              customerAddress,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Contact Information',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    contact,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Date Requested',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    date,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Service Availed',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    service,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Laundry Weight',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    '$load kg/s',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            RowItem(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Estimated Total',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    '₱$total.00',
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              description: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Payment Status',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    payment,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    displayTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(upTask);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Laundry'),
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
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white
            ),
            child: DatePicker(
              height: 90,
              DateTime.now().add(Duration(days: 1)),
              selectionColor: ColorStyle.tertiary,
              daysCount: 7,
              initialSelectedDate: DateTime.now().add(Duration(days: 1)),
              onDateChange: (date){
                setState(() {
                  _selectedDate = date;
                  _dateString = DateFormat('yyyy-MM-dd').format(_selectedDate!);
                });
                displayTask();
              },
            ),
          ),
          upTask.isEmpty
              ? Text('No booking for this day')
              : ListView.builder(
              shrinkWrap: true,
              itemCount: upTask.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index){
                Map task = upTask[index] as Map;

                String pic = ''; Color picColor; Color bgColor;

                switch(task['ServiceName']){
                  case 'Light Load':
                    pic = 'assets/sport-wear.png';
                    bgColor = Colors.lightGreen.shade100;
                    picColor = Colors.green;
                    break;
                  case 'Heavy Load':
                    pic = 'assets/jacket.png';
                    bgColor = Colors.orangeAccent.shade100;
                    picColor = Colors.orange;
                    break;
                  case 'Comforter Load':
                    pic = 'assets/bed-sheets(1).png';
                    bgColor = Colors.purpleAccent.shade100;
                    picColor = Colors.purple;
                    break;
                  default:
                    picColor = Colors.transparent;
                    bgColor = Colors.transparent;
                    break;
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    tileColor: Colors.white,
                    onTap: (){
                      _bottomModalBookings(
                          '${task['CustomerName']}', '${task['CustomerContactNumber']}', '${task['CustomerLoad']}', '${task['LoadCost']}',
                          '${task['Schedule']}', '${task['PaymentStatus']}', '${task['ServiceName']}',
                          '${task['CustomerImage']}', '${task['CustomerAddress']}');
                    },
                    minTileHeight: 60,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    contentPadding: const EdgeInsets.all(4),
                    leading: Tooltip(
                      message: '${task['ServiceName']}',
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Image.asset(pic,color: picColor,scale: 5,),
                      ),
                    ),
                    title: Text('${task['CustomerName']}',style: TextStyle(color: picColor),),
                    subtitle: Text('${task['CustomerContactNumber']}'),
                  ),
                );
              }
          )
        ],
      ),
    );
  }
}

